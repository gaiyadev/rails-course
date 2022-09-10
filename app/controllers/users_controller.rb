class UsersController < ApplicationController
    def create
        begin
            user = User.create(user_params)
            if user.valid?
                render json: {status: "Success", message: "Created successfully", data: {email: user.email}}, status: :created    
            else
                render json: { errors: user.errors.full_messages }, status: :bad_request
            end 
        rescue => exception
            render json: { error: exception }, status: :internal_server_error
        end
    end

    def login
        begin
            user = User.find_by(email: user_params[:email])
        if user && user.authenticate(user_params[:password])
            token = encode_token({user_id: user.id, email: user.email})
            render json: {status: "Success", message: "Login successfully", data: {email: user.email, id: user.id}, token: token}, status: :ok    
        else
            render json: {message: "Invalid email and/or Password", statusCode: 403}, status: :forbidden    
        end
        rescue => exception
            render json: { error: exception }, status: :internal_server_error
        end
    end

# Change Password
    def change_password
        render json: {status: "sucess", message: "Fetched successfully", data: ''}, :status => :ok    
    end

# User params
    private 
    def user_params
        params.permit(:email, :password)
    end
end
