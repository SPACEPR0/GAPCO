class Evidence < ApplicationRecord
  belongs_to :recommendation
  has_many :evidencefiles
end
