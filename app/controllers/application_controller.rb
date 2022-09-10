class ApplicationController < ActionController::API
#  Encode token
    def encode_token(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, ENV['JWT_SECRET'])
      end

    #   Decode token
    def decode_token(token)
        decoded = JWT.decode(token, ENV['JWT_SECRET'])[0]
        HashWithIndifferentAccess.new decoded
    end
    
# Auth middlement
    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header

        begin
          decoded = decode_token(header)
           id =  decoded[:data][:user_id]
           @current_user = User.find(id)
           return @current_user
        rescue ActiveRecord::RecordNotFound => e
          render json: { message: e.message, status_code: 401 }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { message: e.message,  status_code: 401 }, status: :unauthorized
        end
      end
end
