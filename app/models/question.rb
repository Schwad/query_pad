class Question < ApplicationRecord
  include PgSearch
  acts_as_paranoid
  belongs_to :user
  has_many :answers
  validates :title, presence: true

  pg_search_scope :search_for, against: %i(title body), using: [:tsearch, :trigram]
end
