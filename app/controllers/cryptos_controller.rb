class CryptosController < ApplicationController
    def index
        Crypto.delete_all
        StartScrap.new.perform
        @cryptos = Crypto.all
        @date = Crypto.last.created_at
    end
    
    def result
        @crypto = Crypto.find_by(name: params[:crypto][:name])
    end
end
