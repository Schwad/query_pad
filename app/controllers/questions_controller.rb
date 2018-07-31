class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show edit update destroy]
  before_action :authorise_user, only: %i[edit update destroy]
  before_action :set_query, only: :search

  def index
    @questions = Question.all.order(score: :desc).includes(:answers, :user).page params[:page] if sorting_strategy.blank?
    @questions = Question.all.order(created_at: :desc).includes(:answers, :user).page params[:page] if sorting_strategy == 'recent'
  end

  def show; end

  def new
    @question = Question.new(user_id: current_user.id)
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Question submitted!'
      redirect_to @question
    else
      flash[:alert] = @question.errors.full_messages.join(", ")
      redirect_to new_user_question_path(current_user)
    end
  end

  def update
    if @question.update(question_params)
      flash[:notice] = 'Question saved!'
      redirect_to @question
    else
      flash[:alert] = @question.errors.full_messages.join(", ")
      redirect_to edit_user_question_path(@question)
    end
  end

  def destroy
    if @question.destroy
      flash[:notice] = 'Question successfully deleted!'
      redirect_to questions_path
    else
      flash[:alert] = @question.errors.full_messages.join(", ")
      redirect_to @question
    end
  end

  def search
    @questions = Question.search_for(@query).page params[:page]
  end

  def sorting_strategy
    @sorting_strategy ||= params[:sorting_strategy]
  end

  private

  def authorise_user
    if current_user.id != @question.user_id && !current_user.moderator_user
      flash[:alert] = 'You are not allowed to manipulate this resource'
      redirect_to questions_path and return
    end
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def set_query
    @query ||= params[:q]
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end
