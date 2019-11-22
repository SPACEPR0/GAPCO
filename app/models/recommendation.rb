class Recommendation < ApplicationRecord
    validates :name, :time_beg, :time_limit, :number, presence: true
    belongs_to :area
    has_many :evidences, :dependent => :destroy
    has_many :goals, :dependent => :destroy
end
