class AuthController < ApplicationController
  before_filter :validate_params, :only => :authenticate

  def authenticate
    @user = login(params[:username], params[:password])
    if @user
      @user.regenerate_auth_token! if @user.auth_token_expired?
      
      render :status => 200, :json => {
        :username => @user.username,
        :email => @user.email,
        :auth_token => @user.auth_token,
        :auth_token_expires_at => @user.auth_token_expires_at
      }
    else
      render :status => 401, :json => {:error => "Invalid login"}
    end
  end

  private

  def validate_params
    if params[:username].blank? || params[:password].blank?
      render :status => 422, :json => {:error => "username & password parameters are required"}
      return false
    end
  end
end
