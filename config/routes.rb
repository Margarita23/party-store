Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  },
  defaults: { format: :json }

  get "/profile", to: "users#show"

  put "/profile", to: "users#update"

  get "/current_user", to: "users#show"

  get "/users", to: "users#index"

  resources :orders, except: [:new, :edit]
  resources :items, except: [:new, :edit]

end
