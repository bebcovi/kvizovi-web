class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  private

  def respond_with_json
    respond_to do |format|
      format.json { yield }
      format.html
    end
  end
end
