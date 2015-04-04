class Transaction < ActiveRecord::Base
  belongs_to :batch
  belongs_to :partner
end
