class Question < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :answers
  validates :title, presence: true
end
