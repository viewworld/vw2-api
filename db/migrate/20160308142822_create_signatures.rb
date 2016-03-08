class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|

      t.timestamps null: false
    end
  end
end
