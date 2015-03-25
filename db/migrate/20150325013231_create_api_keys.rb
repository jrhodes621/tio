class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :access_token
      t.string :salt
      t.references :partner, index: true
      t.boolean :deleted
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
