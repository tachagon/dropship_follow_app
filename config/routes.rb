Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index'

  get 'test' => 'application#index'

  resources :products, only: [:index, :show, :create] do
  	get 'sync_product' => 'products#sync_product', :as => 'sync_product'
  end
  get 'products/sync_products' => 'products#sync_products', :as => 'sync_products'
  get 'products/search' => 'products#search', :as => 'products_search'

end
