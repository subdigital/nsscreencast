AuthServer::Application.routes.draw do
  match 'auth/login' => "auth#authenticate", :via => :post
  match 'home/index' => "home#index", :via => :get
end
