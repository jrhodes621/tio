class CreateFinancialInstitutions < ActiveRecord::Migration
  def change
    create_table :financial_institutions do |t|
      t.String :name
      t.String :logo
      t.String :type_code
      t.String :status

      t.timestamps
    end
  end
end
