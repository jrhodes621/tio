require 'securerandom'

class Partner < ActiveRecord::Base
  has_many :transactions

  def create_api_key
    ApiKey.create!({
      :access_token =>  SecureRandom.hex,
      :salt => SecureRandom.hex,
      :partner => self
    })
  end

end
