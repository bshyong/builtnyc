Builtnyc::Application.routes.draw do

  get '/place/index', :to => 'places#index'

  get '/place(/:id)', :to => 'places#show'


  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # root route
  root 'pages#index'

end
