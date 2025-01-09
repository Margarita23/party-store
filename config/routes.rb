Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  },
  defaults: { format: :json }

  get "/profile", to: "users#show"

  put "/profile", to: "users#update"

  get "/items", to: "items#index"

  get "/current_user", to: "users#show"

  resources :orders, except: [:new, :edit]

end
