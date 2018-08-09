Rails.application.routes.draw do
  get '/', to: 'cryptos#index'
  post '/result', to: 'cryptos#result'
end
