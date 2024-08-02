Rails.application.routes.draw do
  scope '/api/v1' do
    scope '/auth' do
      post '/signup', to: 'users#sign_up'
      post '/signin', to: 'users#login'
      put '/change_password', to: 'users#change_password'
    end

    scope '/stores' do
      post '/create_store', to: 'stores#create_store'
      get '/fetch_stores', to: 'stores#fetch_stores'
      get '/fetch_store/:store_slug', to: 'stores#fetch_store'
      put '/update_store/:public_id', to: 'stores#update_store'
    end

    scope '/integrations' do
      get '/fetch_integration_count/:store_slug', to: 'integrations#fetch_integration_count'
      post '/create_integration/:store_slug', to: 'integrations#create_integration'
      get '/fetch_integrations/:store_slug', to: 'integrations#fetch_integrations'
      delete '/delete_integration/:store_slug/:integration_public_id', to: 'integrations#delete_integration'
      put '/update_integration/:store_slug/:integration_public_id', to: 'integrations#update_integration'
    end

    scope '/products' do
      post '/create_product/:store_slug', to: 'products#create_product'
      get '/fetch_product_count/:store_slug', to: 'products#fetch_product_count'
      get '/fetch_products/:store_slug', to: 'products#fetch_products'
      get '/fetch_product/:product_slug', to: 'products#fetch_product'
      get '/fetch_product_by_public_id/:public_id', to: 'products#fetch_product_by_public_id'
      delete '/delete_product/:product_slug', to: 'products#delete_product'
      put '/update_product/:store_slug/:public_id', to: 'products#update_product'
      post '/create_payment_link/:product_slug', to: 'products#create_payment_link'
      delete '/delete_image/:public_id', to: 'products#delete_image'
      put '/add_image/:public_id', to: 'products#add_image'
      put '/change_product_logo/:public_id', to: 'products#change_product_logo'
      put '/change_store_logo/:public_id', to: 'products#change_store_logo'
    end

    scope '/merchants' do
      post '/stripe_webhook/:store_slug', to: 'webhooks#stripe'
    end
  end
end
