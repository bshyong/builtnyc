Builtnyc::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users

  # root route
  root 'pages#index'

end
