IapServer::Application.routes.draw do
  post 'receipts/validate' => 'receipts#validate'
end
