Builtnyc::Application.routes.draw do

  resources :firms

  get '/place/index', :to => 'places#index'
  get '/place(/:id)', :to => 'places#show', :as => "place"


  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # root route
  root 'pages#index'

end
