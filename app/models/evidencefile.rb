class Evidencefile < ApplicationRecord
  belongs_to :evidence
  has_one_attached :document
end
