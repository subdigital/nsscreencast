class LattesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @lattes = Latte.order("created_at DESC")
    render :json => @lattes
  end

  def create
    @latte = Latte.new(params[:latte])
    if @latte.save
      render :json => {
        :success => true,
        :latte => @latte
      }
    else
      render :json => {
        :success => false,
        :errors => @latte.errors
      }
    end
  end
end
