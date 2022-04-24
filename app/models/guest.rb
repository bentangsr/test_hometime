class Guest < ApplicationRecord
  acts_as_paranoid

  has_many :reservations, dependent: :destroy

  validates :email, uniqueness: true
  validates :email, presence: true
end