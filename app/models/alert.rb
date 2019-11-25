class Alert < ApplicationRecord
    validates :content, :expiration, presence: true
    serialize :usersNO,Hash
end
