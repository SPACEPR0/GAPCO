class Area < ApplicationRecord
    belongs_to :users
    has_many :recommendations
end
