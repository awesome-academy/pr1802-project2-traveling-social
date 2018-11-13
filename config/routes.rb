Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  scope "(:locale)", locale: /en|vi/ do
    mount Ckeditor::Engine => '/ckeditor'
    devise_for :users
    root 'pages#index'
    get 'statistic', to: 'pages#statistic'
    mount RailsAdmin::Engine => '/wp-admin', as: 'rails_admin'
    resources :users, only: [:show, :edit, :update, :destroy] do
      resources :follows, only: [:create, :destroy, :index]
    end
    resources :micro_posts do
      resources :upvotes, only: [:create, :destroy]
      resources :downvotes, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
    resources :profiles, only: :show
    resources :locations
    resources :locations, only: :show do
      resources :reviews, except: :show
    end
    resources :users, only: :show do
      resources :reviews, except: :show
      resources :images, only: :index
    end
    resources :reviews, only: [:show] do
      resources :comments, only: [:create]
    end
    resources :cities, only: [:show, :index]
    resources :cities, only: :show do
      resources :locations, only: [:index, :show]
    end
    resources :comments, only: [:destroy, :edit, :update] do
      resources :comments, only: [:index, :create]
    end
  end
end
