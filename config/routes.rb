Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'static_pages#home'

  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :users, only: [] do
    resources :questions, except: %i[index show]
  end

  resources :questions, only: %i[index show]

  resources :users, only: [] do
    resources :answers, except: %i[index show]
  end
end
