class CreateFinancialInstitutions < ActiveRecord::Migration
  def change
    create_table :financial_institutions do |t|
      t.string :name
      t.string :logo
      t.string :type_code
      t.string :status

      t.timestamps
    end
  end
end
