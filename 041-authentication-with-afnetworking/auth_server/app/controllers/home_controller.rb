class HomeController < ApplicationController
  before_filter :require_auth
  def index
  end
end
