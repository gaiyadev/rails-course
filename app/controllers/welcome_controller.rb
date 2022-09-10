class WelcomeController < ApplicationController
  def index
    render json: { message: 'hlloe' }, status: :ok
  end
end
