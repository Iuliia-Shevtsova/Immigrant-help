class Api::V1::UsersController  < ApplicationController
  before_action do 
    authenticate_cookie
  end
# ////////
  def index
    @users = User.all
    if @users
      render json: {
        users: @users
      }
    else
      render json: {
        status: 500,
        errors: ['no users found']
      }
    end
  end

  def show
    # render json: current_user.interests
    render json: {
      user: current_user.id
    }
  end
end