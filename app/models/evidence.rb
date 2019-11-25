class Evidence < ApplicationRecord
  validates :title, :day, presence: true
  belongs_to :recommendation
  has_many :evidencefiles, :dependent => :destroy

  accepts_nested_attributes_for :evidencefiles, allow_destroy: true
end
