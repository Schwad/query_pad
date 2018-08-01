Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'static_pages#home'

  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [] do
    resources :questions, except: %i[index show]
    resources :votes, only: %i[create destroy]
    resources :answers, except: %i[index show]
  end

  resources :questions, only: %i[index show] do
    collection do
      get :search
      post :search
      get :my_questions
    end
  end
end
