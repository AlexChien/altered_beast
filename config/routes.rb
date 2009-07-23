ActionController::Routing::Routes.draw do |map|
  map.resources :sites, :moderatorships
  map.open_id_complete 'session', 
    :controller => "sessions", :action => "create",
    :requirements => { :method => :get }
    
  map.resources :monitorship

  map.resources :forums, :has_many => :posts do |forum|
    forum.resources :topics do |topic|
      topic.resources :posts
      topic.resource :monitorship
    end
    forum.resources :posts
  end
  
  map.resources :posts, :collection => {:search => :get}

  map.resources :users, :member => { :suspend   => :put,
                                     :settings  => :get,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :has_many => [:posts]
  
  # map.resources :users, :member => { :admin => :post } do |user|
  #   user.resources :moderators
  # end

  map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
  map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  map.login    '/login',                     :controller => 'sessions', :action => 'new'
  map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  map.settings '/settings',                  :controller => 'users',    :action => 'settings'
  
  map.resource  :session
  
  map.with_options :controller => 'posts', :action => 'monitored' do |map|
    map.formatted_monitored_posts 'users/:user_id/monitored.:format'
    map.monitored_posts           'users/:user_id/monitored'
  end
  
  map.root :controller => 'forums', :action => 'index'
end
