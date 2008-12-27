ActionController::Routing::Routes.draw do |map|
  map.resources :diseases
    
  map.with_options(:controller => "search", :name_prefix => "search_") do |search|
    search.connect 'search/:action/:id'
    search.start 'search', :action => "step1"
    search.step2 'search/step2/:id', :action => "step2"
    search.step3 'search/step3/:id', :action => "step3"
    search.step4 'search/step4/:id', :action => "step4"
  end

  map.with_options(:controller => "user", :name_prefix => "user_") do |user|
    user.connect 'user/remote_handler', :action => "remote_handler"
    user.connect 'user', :action => "index"
    user.login 'user/login',  :action => "login"
    user.join  'user/join',  :action => 'join'
    user.logout 'user/logout',  :action => "logout"
    user.index 'user/index',  :action => "index"
    user.connect 'user/change_profile/:id', :action => "change_profile"
    user.connect 'user/get_current_profile/:id', :action => "get_current_profile"    
  end

  map.with_options(:controller => "resource", :name_prefix => "resource_") do |r|
    r.index 'resource/index', :action => "index"
    r.connect 'resource/remote_search', :action => "remote_search"
    r.connect 'resource/new/:step/:source/:title/:address/:city/:state/:phone/:latitude/:longitude/:website',
      :action => "new", :controller => "resource", :website => nil, :phone => nil, :latitude => nil, :longitude => nil,
      :requirements => { :latitude => %r([^/;,?]+),  :longitude => %r([^/;,?]+),  :website => %r([^/;,?]+)}
    r.steps 'resource/new/:step/:id', :action => "new"

    r.new 'resource/new', :action => "new", :controller => "resource"
  end  
  
  map.with_options(:controller => "profile", :name_prefix => "profile_") do |p|
    p.new 'profile/new/:id', :action => "new"
    p.edit 'profile/edit/:id', :action => "edit"
    p.create 'profile/create/:id', :action => 'create'
  end
  map.resources :profiles, :controller => "profile"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #  map.connect ':controller/:action/:id'
  #  map.connect ':controller/:action/:id.:format'
  #
  map.root :controller => "search"
 
end
