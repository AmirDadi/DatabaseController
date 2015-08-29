Rails.application.routes.draw do
  
  get 'queries' => 'queries#index'
  get 'queries/new'
  post 'queries/create'
  get 'queries/:id' => 'queries#show'
  get 'databases/new'
  post 'databases/create'

  get 'queries/select_star/:table' => 'queries#select_star'
  get 'set_database/:db_id' => 'users#set_database'
  get 'roll_back/:query_id' => 'queries#roll_back'
  resources :db_grants
  resources :users
  resources :table_grants

  # Routes Added by Dadi
  root to: "home#index"

  #home
  get 'home/index'
  
  #users
  #get 'users/new'
  ##post 'users/create'

  #tables
  get 'tables' => 'tables#index'
  post 'tables/set_database'
  # !Routes Added by Dadi

  devise_for :users, :path_prefix => 'auth'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
