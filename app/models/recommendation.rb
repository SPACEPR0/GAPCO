class Recommendation < ApplicationRecord
    belongs_to :area
    has_many :evidences
end
