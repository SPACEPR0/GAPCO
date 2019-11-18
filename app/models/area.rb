class Area < ApplicationRecord
    validates :name, :user, :number, presence: true
    belongs_to :user
    has_many :recommendations, :dependent => :destroy
end
