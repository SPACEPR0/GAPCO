class Evidence < ApplicationRecord
  validates :title, :day, :action, presence: true
  belongs_to :recommendation
  has_many :evidencefiles, :dependent => :destroy

  accepts_nested_attributes_for :evidencefiles, allow_destroy: true, reject_if: proc { |att| att['document'].nil? }
end
