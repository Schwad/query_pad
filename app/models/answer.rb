class Answer < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :question
  validates :body, presence: true

  def question_title
    question&.title
  end
end
