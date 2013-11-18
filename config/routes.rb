Southernhopheads::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  # static pages
  get  'about',    :to => 'home#about'
  get  'admin',    :to => 'home#admin'

  # contact us page
  get  'contact',  :to => 'messages#new', :as => :contact
  post 'contact',  :to => 'messages#create', :as => :contact

  # calendar
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  
  # users
  devise_scope :user do
    get "signup", :to => "devise/registrations#new"
    get "signin", :to => "devise/sessions#new"
  end
  devise_for :users
  resources :users, :only => [:index, :show, :update, :destroy]
  match '/users/unsubscribe/:signature' => 'users#unsubscribe', as: 'unsubscribe'
  
  get  'preferences', :to => 'preferences#edit'
  post 'preferences', :to => 'preferences#update'  
  get  'profile',     :to => 'profile#edit'
  post 'profile',     :to => 'profile#update'
  
  # articles
  get 'queue', :to => 'articles#queue'
  match '/articles/:id/publish' => 'articles#publish', :as => :publish_article
  match '/articles/:id/email' => 'articles#email', :as => :email_article
  resources :articles, :shallow => true do
    resources :comments
  end

  # forums
  resources :forums, :shallow => true do
    resources :posts do
      resources :comments
    end
  end

  # breweries/beers
  resources :breweries, :shallow => true do
    resources :beers do
      resources :reviews
    end
  end
end
