class SessionsController < ApplicationController

  # def create
  #   user = User.find_by(email: params[:email])
  #   # byebug
  #   if user && user[:password] == params[:password]
  #     session[:user_id] = user.id
  #     byebug
  #     render json: user, status: :created
  #   else
  #     render json: { error: { login: 'Invalid Username or password' } }, status: :unauthorized
  #   end
  # end

  # def destroy
  #   session.delete :user_id
  #   head :no_content
  # end
  before_action :authorize, except: [:create]


  def show
    render json: @current_user, status: :ok
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.password == params[:password]
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end



  private

  def user_params
    params.permit(:email,:password)
  end
end
