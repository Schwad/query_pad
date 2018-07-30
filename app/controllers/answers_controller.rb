class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy]
  before_action :authorise_user, only: %i[edit update destroy]

  def show; end

  def new
    @answer = Answer.new(user_id: current_user.id, question_id: params[:question_id])
  end

  def edit; end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      flash[:notice] = 'Answer submitted!'
      redirect_to @answer.question
    else
      flash[:alert] = @answer.errors.full_messages.join(", ")
      redirect_to new_user_answer_path(current_user)
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = 'Answer saved!'
      redirect_to @answer.question
    else
      flash[:alert] = @answer.errors.full_messages.join(", ")
      redirect_to edit_user_answer_path(@answer)
    end
  end

  def destroy
    if @answer.destroy
      flash[:notice] = 'Answer successfully deleted!'
      redirect_to questions_path
    else
      flash[:alert] = @answer.errors.full_messages.join(", ")
      redirect_to @answer.question
    end
  end

  private

  def authorise_user
    if current_user.id != @answer.user_id && !current_user.moderator_user
      flash[:alert] = 'You are not allowed to manipulate this resource'
      redirect_to questions_path and return
    end
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
