class FinancialInstitution < ActiveRecord::Base
  def as_json(options={})
  {
    :financial_institution_id => self.id,
    :name => self.name,
    :type => self.type_code,
    :logo => self.logo_url,
    :created_at    => self.created_at,
    :updated_at    => self.updated_at
  }
  end
end
