class CreatePowereposAuth < ActiveRecord::Migration[6.0]
  def change
    create_table :powerepos_auths do |t|
      t.string :token_type
      t.text :access_token
      t.integer :expires_in
      t.text :refresh_token
      t.timestamps
    end
  end
end
