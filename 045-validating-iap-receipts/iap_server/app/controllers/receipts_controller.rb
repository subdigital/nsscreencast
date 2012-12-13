class ReceiptsController < ApplicationController
  def validate
    receipt_data = params[:receipt_data]
    receipt = Itunes::Receipt.verify! receipt_data, :allow_sandbox
    render :json => {:status => "ok", :receipt => receipt}
  rescue StandardError => e
    render :json => {:status => "error", :message => e.message}, :status => 400
  end
end
