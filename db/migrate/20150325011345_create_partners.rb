class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :partner_name
      t.string :company_name
      t.string :company_identification
      t.string :company_entry_description
      t.string :immediate_destination
      t.string :immediate_destination_name
      t.string :immediate_origin
      t.string :immediate_origin_name
      t.string :originating_financial_institution

      t.timestamps
    end
  end
end
