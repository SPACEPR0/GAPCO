Rails.application.routes.draw do
  
  devise_for :users#, :skip => [:registrations]

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end
  
  authenticated :user do
    # Routes for authenticated users
    root to: 'welcome#index', as: :authenticated_root
  end

  root to: redirect('login')


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
