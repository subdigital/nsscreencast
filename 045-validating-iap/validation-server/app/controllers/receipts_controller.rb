class ReceiptsController < ApplicationController
  skip_before_filter :validate_authenticity_token, :only => :validate
  def validate
    receipt_data = params[:receipt_data]
    receipt = Itunes::Receipt.verify! receipt_data, :allow_sandbox_receipt
    render :json => receipt
  end
end
