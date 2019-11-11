class Area < ApplicationRecord
    belongs_to :user
    has_many :recommendations, :dependent => :destroy
end
