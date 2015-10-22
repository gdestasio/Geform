Rails.application.routes.draw do
  #require 'sidekiq/web'
  #mount Sidekiq::Web => '/sidekiq'
  resources :uploads
  
  devise_for :admins, controllers: { sessions: 'users/sessions' }, :skip => :registrations
  devise_for :users, controllers: { registrations: "users/registrations" , sessions: 'users/sessions' }

  scope :users do
    get '/' => 'users#index', :as => :users
    get '/:id/edit' => 'users#edit', :as => :user_edit
    patch '/:id/update' => 'users#update', :as => :user_update
    post '/change_password' => 'users#change_password', :as => :user_change_password
    get '/confirmation/:token' => 'users#confirmation', :as => :user_confirmation
    patch '/activate' => 'users#activate', :as => :user_activate

    scope :events do
      get '/' => 'users/events#index', :as => :users_events
      get '/:id/show' => 'users/events#show', :as => :users_events_show
      post '/:id/join' => 'users/events#join', :as => :users_events_join
      post '/:id/revoke' => 'users/events#revoke', :as => :users_events_revoke
      post '/:id/add_wl' => 'users/events#add_wl', :as => :users_events_add_wl
      post '/:id/remove_wl' => 'users/events#remove_wl', :as => :users_events_remove_wl
      get '/loadmore' => 'users/events#loadmore'      
    end

    scope :documents do 
      get '/' => 'users/documents#index', :as => :users_documents
    end

    scope :exonerations do 
      get '/' => 'users/exonerations#index', :as => :users_exonerations
    end

    scope :autocertifications do 
      get '/' => 'users/autocertifications#index', :as => :users_autocertifications
    end

    scope :certificates do 
      get '/' => 'users/certificates#index', :as => :users_certificates
      get '/download/:id' => 'users/certificates#download', :as => :users_certificates_download
    end
  end

  # WEB
  scope :admins do
    get '/' => 'admins#index', :as => :admins
    scope :events do
      get '/' => 'admins/events#index', :as => :admins_events
      get '/new' => 'admins/events#new', :as => :admins_events_new
      get '/new_from_credits' => 'admins/events#new_out_of_credits', :as => :admins_events_new_out_of_credits      
      post '/' => 'admins/events#create', :as => :admins_events_create
      get '/:id/show' => 'admins/events#show', :as => :admins_events_show
      get '/:id/edit' => 'admins/events#edit', :as => :admins_events_edit
      patch '/' => 'admins/events#update', :as => :admins_events_update
      delete '/' => 'admins/events#destroy', :as => :admins_events_destroy
      post '/:id/change_status/:status' => 'admins/events#change_status', :as => :admins_events_change_status
      get '/:id/transits' => 'admins/events#transits', :as => :admins_events_transits
      get '/:id/booked' => 'admins/events#booked', :as => :admins_events_booked
      get '/:id/waiting' => 'admins/events#waiting', :as => :admins_events_waiting
      get '/generator' => 'admins/events#generator', :as => :admins_events_generator
      post '/generate' => 'admins/events#generate', :as => :admins_events_generate
      get '/credits' => 'admins/events#credits', :as => :admins_events_credits
      get '/loadmore' => 'admins/events#loadmore'
      post '/close' => 'admins/events#close_event'
      post '/generate_credits' => 'admins/events#generate_credits'
      get '/remove_brochure' => 'admins/events#remove_brochure'
      get '/download_brochure' =>'admins/events#download_brochure', :as => :admins_events_download_brochure
    end
    scope :users do
      get '/' => 'admins/users#index', :as => :admins_users
      get '/new' => 'admins/users#new', :as => :admins_users_new
      post '/' => 'admins/users#create', :as => :admins_users_create
      get '/:id/show' => 'admins/users#show', :as => :admins_users_show
      get '/:id/edit' => 'admins/users#edit', :as => :admins_users_edit
      patch '/' => 'admins/users#update', :as => :admins_users_update
      delete '/' => 'admins/users#destroy', :as => :admins_users_destroy
      get '/loadmore' => 'admins/users#loadmore'
    end
    scope :transits do
      get '/' => 'admins/transits#index', :as => :admins_transits
    end

    scope :stats do
      get '/' => 'admins/stats#index', :as => :admins_stats
    end
  end

  # WEB
  scope :associations do
    get '/' => 'associations#index', :as => :associations
    scope :events do
      get '/' => 'associations/events#index', :as => :associations_events
      get '/new' => 'associations/events#new', :as => :associations_events_new
      post '/' => 'associations/events#create', :as => :associations_events_create
      get '/:id/show' => 'associations/events#show', :as => :associations_events_show
      get '/:id/edit' => 'associations/events#edit', :as => :associations_events_edit
      patch '/' => 'associations/events#update', :as => :associations_events_update
      get '/:id/booked' => 'associations/events#booked', :as => :associations_events_booked
      get '/:id/waiting' => 'associations/events#waiting', :as => :associations_events_waiting
    end

    scope :users do
      get '/' => 'associations/users#index', :as => :associations_users
      get '/:id/show' => 'associations/users#show', :as => :associations_users_show
    end
  end

  # API
  namespace :api do
    namespace :v1 do
      scope :admins do
        post '/login' => 'admins#login', defaults: {format: :json}
      end
      scope :events do
        get '/' => 'events#index', defaults: {format: :json}
      end
      scope :users do
        post '/' => 'users#create', defaults: {format: :json}
        get '/' => 'users#index', defaults: {format: :json}
      end
      scope :subscriptions do
        get '/' => 'subscriptions#index', defaults: {format: :json}
        post '/' => 'subscriptions#create', defaults: {format: :json}
      end
      scope :transits do
        post '/' => 'transits#create', defaults: {format: :json}
        get '/' => 'transits#index', defaults: {format: :json}
      end
    end
  end

  #root 'users/sessions#new'
  root 'website#index'
  get '/event/:id/show' => 'website#show', :as => :website_events_show
  get '/website/documents' => 'website#documents', :as => :website_documents
  get '/loadmore' => 'website#loadmore'
end
