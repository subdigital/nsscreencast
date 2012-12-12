class ReceiptsController < ApplicationController

  def validate
    receipt = Itunes::Receipt.validate(params[:receipt_data], :allow_sandbox_servers)
    Rails.logger.info "Receipt: #{receipt}"
    render :json => { :status => "ok", :receipt => receipt }
  rescue StandardErr => e
    render :json => { :status => "error", :details => e.message }, :status => 400
  end
end
