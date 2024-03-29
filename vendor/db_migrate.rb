require 'active_record'
require 'pg'
require 'uuid'
# Config for database we want to migrate to.
# Here its necessary to expose all models we want to migrate.
# Each model has to be ancestor of SetupDb with properly set relationships.
module NewVW
  class SetupDb < ActiveRecord::Base
    self.abstract_class = true
    establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      port: 5432,
      database: 'vw2db',
      username: 'vw2user',
      password: 'vw2userpwd'
    )
  end

  class User < SetupDb
    belongs_to :group
  end

  class Organisation < SetupDb
    has_many :groups
    has_many :users, through: :groups
    has_many :forms
  end

  class Group < SetupDb
    belongs_to :organisation
    has_many :users
  end

  class Form < SetupDb
    belongs_to :organisation
  end

  class Report < SetupDb
    belongs_to :form
  end
end

# Config for old database we want to migrate from.
# Configuration of each model has to match real state.
module OldVW
  class SetupDb < ActiveRecord::Base
    self.abstract_class = true
    establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      port: 5432,
      database: 'vw_production',
      username: 'postgres',
      password: 'postgres123'
    )
  end

  class User < SetupDb
    belongs_to :group
  end

  class Organisation < SetupDb
    has_many :groups
    has_many :users, through: :groups
  end

  class Group < SetupDb
    belongs_to :organisation
  end

  class Form < SetupDb
    belongs_to :organisation
    serialize :data, JSON
  end

  class Report < SetupDb
    belongs_to :form
    serialize :data, JSON
  end
end

module Convert
  class Organisations
    def self.all
      old_organisations = OldVW::Organisation.all
      old_organisations.each { |organisation| single(organisation.id) }
      return true if old_organisations.size == NewVW::Organisation.all.size
    end

    def self.single(id)
      old_organisation = OldVW::Organisation.find(id)
      new_parameters = parameters_for(old_organisation)
      new_organisation = NewVW::Organisation.find_or_create_by(id: id)
      new_organisation.update_attributes(new_parameters)
    end

    private

    def self.parameters_for(organisation)
      {
        id: organisation.id,
        name: organisation.name,
        use: organisation.use
      }
    end
  end

  class Groups
    def self.all
      old_groups = OldVW::Group.all
      old_groups.each { |group| single(group.id) }
      return true if old_groups.size == NewVW::Group.all.size
    end

    def self.single(id)
      old_group = OldVW::Group.find(id)
      new_parameters = parameters_for(old_group)
      new_group = NewVW::Group.find_or_create_by(id: id)
      new_group.update_attributes(new_parameters)
    end

    private

    def self.parameters_for(group)
      {
        id: group.id,
        name: group.name,
        organisation_id: group.organisation_id,
        parent_id: group.parent_id
      }
    end
  end

  class Users
    def self.all
      old_users = OldVW::User.all
      old_users.each { |user| single(user.id) }
      return true if old_users.size == NewVW::User.all.size
    end

    def self.single(id)
      old_user = OldVW::User.find(id)
      new_parameters = parameters_for(old_user)
      new_user = NewVW::User.find_or_create_by(id: id)
      new_user.update_attributes(new_parameters)
    end

    private

    def self.parameters_for(user)
      {
        id: user.id,
        email: user.email,
        login: user.login,
        first_name: user.first_name,
        last_name: user.last_name,
        password_digest: user.encrypted_password,
        timezone_name: user.timezone_name,
        role: user.role_id,
        group_id: user.group_id
      }
    end
  end

  class Forms
    def self.all
      old_forms = OldVW::Form.all
      old_forms.each { |form| single(form.id) }
      return true if old_forms.size == NewVW::Form.all.size
    end

    def self.single(id)
      old_form = OldVW::Form.find(id)
      pure_data = validate_uuids(old_form.data['properties'])
      pure_data = change_ids(pure_data)
      pure_data = sanitize(pure_data)

      old_order = old_form.data['order']
      new_order = id_order(pure_data, old_order)

      new_parameters = parameters_for(old_form, pure_data, new_order)

      if new_form = NewVW::Form.find_by(id: id)
        new_form.update_attributes(new_parameters)
      else
        new_form = NewVW::Form.new
        new_form.update_attributes(new_parameters)
      end
    end

    # Deletes UUID keys, adds id and uuid as values inside.
    def self.change_ids(data)
      data.each_with_index do |slice, index|
        slice[1]['uuid'] = slice[0]
        slice[1]['id'] = index + 1
        slice.delete_at(0)
      end.flatten
    end

    def self.validate_uuids(data)
      data.select do |key, value|
        UUID.validate(key)
      end.to_a
    end

    def self.id_order(pure_data, uuid_order)
      order = []
      uuid_order.each do |uuid|
        data_field = pure_data.select { |field| field['uuid'] == uuid }.first
        order << data_field['id'] if data_field
      end
      order
    end

    def self.sanitize(collection)
      collection.each do |item|
        item['type'] = item['abstractType'].downcase
        item.delete('abstractType')
        item.delete('inputType')
        item['title'] = item['fieldTitle'].values.first
        item['hint'] = item['hint'].values.first
        item.delete('fieldTitle')
        item.delete('allowList')
        item.delete('hidden')
        item['items'].delete('items') if item['items'] && item['items']['items']
        item['items'].delete('type') if item['items'] && item['items']['type']
        unless item['elements'].nil?
          item['items'] = item['elements']
          item.delete('elements')
        end

        if item['type'] == 'date / time'
          item['type'] = 'date_time'
          item['items']['minimum'] = item['minimum_picker']
          item['items']['maximum'] = item['maximum_picker']
          item.delete('maximum_picker')
          item.delete('minimum_picker')
        end

        if item['type'] == 'yes / no'
          item['type'] = 'yes_no'
        end

        if item['type'] == 'explanation text'
          item['type'] = 'explanation_text'
          item['items']['report'] = item['fieldContent']
        end

        if item['type'] == 'page break'
          item['type'] = 'page_break'
        end
      end
    end

    def self.new_organisation_for(form)
      if new_organisation = NewVW::Organisation.find_by(id: form.organisation_id)
        return new_organisation.id
      else
        return nil
      end
    end

    def self.parameters_for(form, pure_data, order)
      if form.data['properties'] && form.data['properties']['verification']
        verification_required = form.data['properties']['verification']['verificationRequired']
      end

      if form.data['properties'] && form.data['properties']['verification'] &&
          form.data['properties']['verification']['properties'] &&
          form.data['properties']['verification']['properties']['status']
        default = form.data['properties']['verification']['properties']['status']['default']
      end

      {
        id: form.id,
        name: form.name,
        active: form.data['isActive'] || nil,
        verification_required: verification_required || nil,
        verification_default: default || nil,
        order: order,
        data: pure_data,
        groups: form.data['groups'] || nil,
        deleted_at: form.deleted_at,
        organisation_id: new_organisation_for(form)
      }
    end
  end

  class Reports
    def self.single(id)
      old_form = old_report.form
      new_form = NewVW::Form.find(old_form.id)
      old_report = OldVW::Report.find(id)
    end
  end
end
