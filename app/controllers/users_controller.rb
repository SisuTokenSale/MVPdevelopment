class UsersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def edit; end

  def update
    current_user.update!(strategy: user_params[:strategy])
    redirect_to user_url
  end

  private

  helper_method :user
  def user
    current_user
  end

  def user_params
    params.require(:user).permit(:strategy)
  end
end
