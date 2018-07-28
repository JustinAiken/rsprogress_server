Rails.application.routes.draw do
  devise_for :users

  get "current_progress", controller: "current_progress", action: "show"
  root to: "current_progress#show"

  resource :profile, only: [:show, :edit, :update], controller: :profile
  get :profile, action: :show, controller: :profile

  resources :arrangement_progresses, only: [:show]
  resources :game_progresses, only: [:index] do
    resources :arrangement_progresses, only: [:index]
  end

  resources :arrangements, only: [] do
    resource :arrangement_note, only: [:create]
    resource :personal_flag,    only: [:create]
  end

  resources :songs, only: [:index, :show]
  resources :artists, only: [:index] do
    resources :songs, only: [:index]
  end

  namespace :api do
    devise_for :users, controllers: {sessions: 'api/sessions'}
    resource :profile, only: [:show]

    resources :game_progresses, only: [:create, :show]
    resources :arrangements,    only: [:create, :show, :update] do
      resources :flags, only: [:create]
      resources :notes, only: [:create]
    end
    resources :flags,           only: [:index]
    resources :notes,           only: [:index]
  end
end
