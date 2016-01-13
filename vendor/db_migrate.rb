require 'active_record'
require 'pg'

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
  end

  class Organisation < SetupDb
  end
end

module OldVW
  class SetupDb < ActiveRecord::Base
    self.abstract_class = true
    establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      port: 5432,
      database: 'vwdb5',
      username: 'postgres',
      password: 'postgres123'
    )
  end

  class User < SetupDb
  end

  class Organisation < SetupDb
  end
end

module Convert
  class Users
    def self.all
      old_users = OldVW::User.all
      old_users.each { |user| single(user.id) }
      return true
    end

    def self.single(id)
      old_user = OldVW::User.find(id)
      new_parameters = parameters_for(old_user)

      if new_user = NewVW::User.find_by(id: id)
        new_user.update_attributes(new_parameters)
        new_user.save
      else
        new_user = NewVW::User.new
        new_user.update_attributes(new_parameters)
        new_user.save
      end
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
        timezone: user.timezone_name,
        role: user.role_id
      }
    end
  end

  class Organisations
    def self.all
      old_organisations = OldVW::Organisation.all
      old_organisations.each { |organisation| single(organisation.id) }
      return true
    end

    def self.single(id)
      old_organisation = OldVW::Organisation.find(id)
      new_paramaters = parameters_for(old_organisation)

      if new_organisation = NewVW::Organisation.find_by(id: id)
        new_organisation.update_attributes(new_paramaters)
        new_organisation.save
      else
        new_organisation = NewVW::Organisation.new
        new_organisation.update_attributes(new_paramaters)
        new_organisation.save
      end
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
end
