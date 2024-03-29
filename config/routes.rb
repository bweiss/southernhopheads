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
  
  #search
  match '/search', :to => 'search#index'

  # users
  devise_scope :user do
    get "signup", :to => "devise/registrations#new"
    get "signin", :to => "devise/sessions#new"
  end
  devise_for :users
  resources :users, :only => [:index, :show, :update, :destroy], :shallow => true do
    resources :payments
  end

  match '/users/unsubscribe/:signature' => 'users#unsubscribe', :as => 'unsubscribe'

  get  'preferences', :to => 'preferences#edit'
  post 'preferences', :to => 'preferences#update'  
  get  'profile',     :to => 'profile#edit'
  post 'profile',     :to => 'profile#update'
  
  # articles
  get '/articles/queue', :to => 'articles#queue', :as => :article_queue
  match '/articles/:id/publish' => 'articles#publish', :as => :publish_article
  match '/articles/:id/email'   => 'articles#email',   :as => :email_article
  match '/articles/:id/bump'    => 'articles#bump',    :as => :bump_article
  resources :articles, :shallow => true do
    resources :comments
  end

  # events
  get '/events/queue', :to => 'events#queue', :as => :event_queue
  match '/events/:id/publish' => 'events#publish', :as => :publish_event
  match '/events/:id/email'   => 'events#email',   :as => :email_event
  match 'events/:id/bump'     => 'events#bump',    :as => :bump_event
  resources :events, :shallow => true do
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
