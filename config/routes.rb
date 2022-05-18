# frozen_string_literal: true

Rails.application.routes.draw do
  
  root 'homepage#index'

  resources :users
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create'
  post 'logout' => 'user_sessions#destroy', :as => :logout

  resources :surveys do
    resources :responses do
      collection do 
        get :submitted
      end
    end

    member do
      patch :sort
      patch :question_sort
      post :survey_title
      post :survey_description
      post :add_question_item
      post :add_answer_item
      post :duplicate_question
      post :save_checkbox
      patch :update_select
      post :add_question
      post :add_answer
      delete :remove_question
      delete :remove_answer
      patch :font_style
      patch :theme
      get :stats
    end 

    get 'duplicate', on: :member , to: "surveys#duplicate_survey"
    patch :tag
  end
  
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback" # for use with Github, Facebook
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  get "survey_style", to:"survey#style"

  resources :password_resets, only: [:new, :create, :edit, :update]
  get 'to/:survey_id' , as: 'responses_new' , to: 'responses#new'
  post 'to/:survey_id/done' , as: 'responses_done', to: 'responses#create'

end
