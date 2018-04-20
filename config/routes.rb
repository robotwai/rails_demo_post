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
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
