class Recommendation < ApplicationRecord
    validates :name, :time_beg, :time_limit, :number, presence: true
    validate :time_limit_cannot_be_before_time_beg
    belongs_to :area
    has_many :evidences, :dependent => :destroy
    has_many :goals, :dependent => :destroy

    def time_limit_cannot_be_before_time_beg
        if time_limit < time_beg
            errors.add(:time_limit, "La fecha límite no puede ser menor a la inicial.")
            return false
        end
    end

end
