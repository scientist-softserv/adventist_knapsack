class CreateDefaultAdministrativeSet < ActiveRecord::Migration[6.1]
  def change
    create_table :hyrax_default_administrative_set do |t|
      t.string :default_admin_set_id, null: false
      t.timestamps null: false
    end
  end
end
