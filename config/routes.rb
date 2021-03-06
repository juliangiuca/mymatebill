ActionController::Routing::Routes.draw do |map|

  map.logout    '/logout',            :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',             :controller => 'sessions',  :action => 'new'
  map.register  '/register',          :controller => 'accounts',     :action => 'create'
  map.signup    '/signup',            :controller => 'accounts',     :action => 'new'
  map.resources :accounts
  map.resource  :session

  map.activate        '/activate/:activation_code', :controller => 'accounts',  :action => 'activate'
  map.forgot_password '/forgot_password',           :controller => 'passwords', :action => 'new'
  map.reset_password  '/reset_password/:id',        :controller => 'passwords', :action => 'edit'
  map.change_password '/change_password',           :controller => 'accounts',  :action => 'edit'
  map.successful_signup '/success',                 :controller => 'main',      :action => "success"

  map.connect   '/ac/actors_name',    :controller => :transactions, :action => :auto_complete_for_actor_name
  map.connect   '/ac/friends_name',   :controller => :transactions, :action => :auto_complete_for_friend_name
  map.connect   '/ut/understand_text',:controller => :transactions, :action => :understand
  map.easy_transaction   '/text',     :controller => :transactions, :action => :text_add

  map.resources :transactions
  map.resources :friends, :controller => :associates
  map.resources :visitor
  map.resources :actors
  map.resources :line_items

  map.transaction_magic_hash '/transactions/:unique_magic_hash', :controller => :transactions, :action => :show_anonymous

  map.home '', :controller => :transactions, :action => :index

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
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
