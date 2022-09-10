class UsersController < ApplicationController
    before_action :authorize_request,    except: [:create, :login]

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

    def update

    end

    def destroy
        
    end

    def show
        
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
   begin
    user_id =  @current_user[:id] 
    current_password = change_password_params['current_password']
    new_password = change_password_params['new_password']
    confirm_password = change_password_params['confirm_password']

    user = User.find_by(id: user_id)

    if !user 
     return render json: {status: "sucess", message: "Not found",}, :status => :not_found    
    else
        hashed_password = user[:password_digest]
          is_match = BCrypt::Password.new(hashed_password) == new_password
        if !is_match
            return render json: {status: "error", message: "Current password is invalid"}, :status => :bad_request
        else  
            if new_password != confirm_password
                return render json: {status: "error", message: "Password comfirmation is invalid"}, :status => :bad_request
            else 
                new_hash= BCrypt::Password.create(new_password)
               user.password_digest = new_hash
               updated = user.save()
               if updated
                return render json: {status: "Success", message: "Success ppas"}, :status => :created
               else
                return render json: {status: "error", message: "Not save"}, :status => :bad_request
               end

            end 
        end
    end
   rescue => exception
    return render json: { message: exception}, :status => :internal_server_error    
   end
    end

# User params
    private 
    def user_params
        params.permit(:email, :password)
    end

    private
    def change_password_params
        params.permit(:current_password, :new_password, :confirm_password)
    end
end
