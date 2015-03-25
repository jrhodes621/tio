class Transaction < ActiveRecord::Base
  belongs_to :batch
end
