class Api::V1::SessionsController  < ApplicationController
  before_action only: [:destroy] do 
    authenticate_cookie
  end

  # REGISTER
  # def create
  #   @user = User.create(user_params)
  #   if @user.valid?
  #     token = encode_token({user_id: @user.id})
  #     render json: {user: @user, token: token}
  #   else
  #     render json: {error: "Invalid username or password"}
  #   end
  # end

 # REGISTER
  def create
    username = params["username"]
    email = params["email"]
    password = params["password"]
    password_confirmation = params["password_confirmation"]
    if email && password #user_params
      
      signup_hash = User.handle_signup(username, email, password, password_confirmation)

      # signup_hash = User.handle_signup(user_params)
      if signup_hash
        cookies.signed[:jwt] = {value:  signup_hash[:token], httponly: true}
        render json: { 
          user_id: signup_hash[:user_id],
          name: signup_hash[:name],
        }
      else
        render json: {status: 'incorrect email or password', code: 422}  
      end
    else
      render json: {status: 'specify email address and password', code: 422}
    end
    # @user = User.create(user_params)
    # if @user.valid?
      # token = encode({user_id: @user.id})
      # render json: {user: @user, token: token}
    # else
    #   render json: {error: "Invalid username or password"}
    # end
  end

  # LOGGING IN
  def login
    email = params["email"]
    password = params["password"]
    if email && password
      login_hash = User.handle_login(email, password)
      if login_hash
        cookies.signed[:jwt] = {value:  login_hash[:token], httponly: true}
        render json: { 
          user_id: login_hash[:user_id],
          name: login_hash[:name],
        }
      else
        render json: {status: 'incorrect email or password', code: 422}  
      end
    else
      render json: {status: 'specify email address and password', code: 422}
    end
  end

  # //////////
  def is_logged_in?
    if authenticate_cookie && current_user
      render json: {
        logged_in: true,
        # usr: current_user,
        user: {
          id: current_user.id,
          name: current_user.name
        }
      }
    # else
    #   render json: {
    #     logged_in: false,
    #     message: 'no such user'
    #   }
    end
  end

  def destroy
    user = current_user
    if user  
      cookies.delete(:jwt)
      render json: {status: 'OK', code: 200}
    else
      render json: {status: 'session not found', code: 404}
    end
  end

  # private

  # def user_params
  #   params.permit(:username, :email, :password, :password_confirmation)
  # end

end