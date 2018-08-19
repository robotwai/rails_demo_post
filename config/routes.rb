Rails.application.routes.draw do
  

  # 安卓接口
  get 'people/get_one_data'
  get 'people/get_data'
  post 'people/save_data'
  post 'people/remove'
  post 'people/update_data'
  resources :people

  root 'static_pages#home'
  # get 'home' to 'static_pages#home'

  get '/help', to: 'static_pages#help'

  get '/about', to: 'static_pages#about'

  get '/signup', to: 'users#new'
  post 'signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login',to: 'sessions#create'
  delete '/logout',to: 'sessions#destroy'
  resources :users do
    member do
      get :following,:followers
    end
  end

  resources :account_activations, only: [:edit]

  resources :password_resets ,only: [:new,:edit,:create,:update]
  resources :microposts ,only: [:create,:destroy]
  resources :comments ,only: [:create,:destroy]
  resources :relationships ,only: [:create,:destroy]
  resources :dots ,only: [:create,:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "app/loggin", to: 'apps#loggin'
  get "app/feed", to: 'apps#feed'
  post "app/seedmicropost", to: 'apps#seedmicropost'
  post "app/register", to: 'apps#register'
  post "app/dot", to: 'apps#dot'
  post "app/dotDestroy",to: 'apps#dotDestroy'
  get "app/getCommit", to: 'apps#getCommit'
  get "app/getDots", to: 'apps#getDots'
  post "app/seedcommit", to: 'apps#seedcommit'
  get "app/getUser", to: 'apps#getUser'
  get "app/getUserMicroposts", to: 'apps#getUserMicroposts'
  post "app/unfollow", to: 'apps#unfollow'
  post "app/follow", to: 'apps#follow'
  get "app/get_follower_users", to: 'apps#get_follower_users'
  post "app/user_update", to: 'apps#user_update'
end
