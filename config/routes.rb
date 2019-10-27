Rails.application.routes.draw do
  
  devise_for :users#, :skip => [:registrations]

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'edit', to: 'devise/registrations#edit'
    delete 'logout', to: 'devise/sessions#destroy'
  end
  
  authenticated :user do
    resources :areas
    # Routes for authenticated users
    root to: 'areas#index', as: :authenticated_root
    #get "/areas", to: 'areas#index'
  end

  unauthenticated :user do
    get "/areas", to: redirect('login')
  end
  root to: redirect('login')


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
