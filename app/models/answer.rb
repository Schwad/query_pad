class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :body, presence: true

  def question_title
    question&.title
  end
end
