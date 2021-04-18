class Task < ApplicationRecord
  belongs_to :user
  validates :name, :priority, :status, :deadline, presence: true
end
