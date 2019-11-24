class Recommendation < ApplicationRecord
  belongs_to :area
  has_many :evidences, :dependent => :destroy
  has_many :goals, :dependent => :destroy
end
