Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :amazon_products, :only => [:create, :index]
    resources :amazon_imports, :only => [:create, :index, :new]
    resources :amazon_taxons, :only => [:index]
  end
end
