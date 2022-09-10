class CoursesController < ApplicationController
    before_action :authorize_request,    except: [:index, :show]
  

    # Fetch all
    def index
        books = Course.all().joins(:user).select(:title, :description, :created_at, :user_id, :id).reverse_order
        render json: {status: "sucess", message: "Fetched successfully", data: books}, :status => :ok    
    end

    # Fetch One
    def show
        begin
            book = Course.find(params[:id])
            render json: {status: "Success", message: "Fetched successfully", data: book}, :status => :ok    
        rescue => exception
            render json: {message: exception, status_code: 404}, :status => :not_found    
        end
    end

# Create one
    def create
        user_id =  @current_user[:id]
        title = book_params[:title]
        description = book_params[:description]
        begin
            book = Course.new()
            book.title = title
            book.description = description
            book.user_id = user_id
            if book.save()
            render json: {
                status: "Sucess", 
                status_code: 201,
                message: "Created successfully", 
                data:{
                    id: book[:id],
                    title: book[:title]
                }
            }, 
            :status => :created    
        else
            render json: {
                errors: book.errors,
                status_code: 400
            }, 
            :status => :bad_request 
        end 
        rescue => exception
            render json: {
                errors: exception, status_code: 500
            }, 
            :status => :internal_server_error 
        end  
    end


    def destroy
        begin
        book = Course.find(params[:id])
        book.destroy
        render json: {status: "sucess", message: "Deleted successfully"}, :status => :ok    
        rescue => exception
        render json: {message: exception, status_code: 404}, :status => :not_found    
        end
    end

    def update
        begin
            book = Course.find(params[:id])

            if book.update(book_params)
            render json: {
                status: "Sucess", 
                status_code: 201,
                message: "updates successfully", 
                data:{
                    id: book[:id],
                }
            }, 
            :status => :created    
        else
            render json: {
                errors: book.errors,
                status_code: 400
            }, 
            :status => :bad_request 
        end 
        rescue => exception
            render json: {
                errors: exception, status_code: 500
            }, 
            :status => :internal_server_error 
        end  
    end

   private 
    def book_params
        params.permit(:title, :description)
    end
end
