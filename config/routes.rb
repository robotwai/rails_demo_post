Rails.application.routes.draw do
  
  get 'people/get_one_data'
  get 'people/get_data'
  post 'people/update_data'
  resources :people
  get 'static_pages/home'

  get 'static_pages/help'

  get 'static_pages/about'
  get 'static_pages/json'
  post 'people/save_data'
  post 'people/remove'

  get '/signup', to: 'users#new'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
