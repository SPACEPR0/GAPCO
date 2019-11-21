class Evidence < ApplicationRecord
  validates :title, :day, presence: true
  belongs_to :recommendation
  has_many :evidencefiles, :dependent => :destroy
end
