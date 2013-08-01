Builtnyc::Application.routes.draw do

  resources :firms
  resources :places

  # get '/place/new', :to => 'places#new', :as => "new_place"
  # get '/place/index', :to => 'places#index'
  # post '/places', :to => 'places#create', :as => "places"
  # get '/place(/:id)', :to => 'places#show', :as => "place"


  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # root route
  root 'pages#index'

end
