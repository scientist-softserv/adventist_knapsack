class CreateProxyDepositRights < ActiveRecord::Migration[6.1]
  def change
    create_table :proxy_deposit_rights do |t|
      t.references :grantor
      t.references :grantee
      t.timestamps null: false
    end
    
  end
end
