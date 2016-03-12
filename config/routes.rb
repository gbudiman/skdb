Rails.application.routes.draw do
  root    'heros#index'

  get     'heros/mock'                         => 'heros#index_mock'

  get     'heros'                              => 'heros#index_fetch'
  get     'heros/:id'                          => 'heros#view'
  get     'heros/fetch/:id'                    => 'heros#view_fetch'
  get     'heros/fetch/:id/:level/:plus'       => 'heros#view_fetch'

  get     'heros/search/:q'                    => 'heros#search'
  get     'heros/fetch/having/atb/effect/:e/target/:r'   => 'heros#fetch_having_atb_effect'
  get     'skills/search/:q'                   => 'skills#search'
  get     'attributes/search/:q'               => 'atbs#search'

  get     'compare'                            => 'heros#index'
  get     'compare/*ids'                       => 'heros#compare' #, constraint: { ids: /\d+/ }

  get     'heros/debug/:n'                     => 'heros#debug'
  get     'heros/debug/:n/:level/:plus'        => 'heros#debug'

  get     'visitors/fetch/stats'               => 'visitor#stats_fetch'

  get     'stat'                               => 'stat#index'
  get     'stat/fetch'                         => 'stat#index_fetch'

  get     'coupons'                            => 'coupons#index'
  get     'coupons/fetch'                      => 'coupons#index_fetch'

  get     'tiers'                              => 'tiers#index'
  get     'tiers/fetch'                        => 'tiers#index_fetch'

  get     'equip_recommendations'              => 'equip_recommendations#index'
  get     'equip_recommendations/fetch'        => 'equip_recommendations#index_fetch'
  # get     'stat/fetch/:level'                  => 'stat#index_fetch'
  # get     'stat/fetch/:level/:plus'            => 'stat#index_fetch'
  # get     'stat/fetch/update/:level'           => 'stat#index_fetch_update'
  # get     'stat/fetch/update/:level/:plus'     => 'stat#index_fetch_update'
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
