class Evidence < ApplicationRecord
  validates :name, :day, presence: true
  belongs_to :recommendation
  has_many :evidencefiles, :dependent => :destroy
end
