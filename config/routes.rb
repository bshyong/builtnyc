Builtnyc::Application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # root route
  root 'pages#index'

end
