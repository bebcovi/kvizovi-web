class ApplicationController < ActionController::API
  private

  def respond_with_json
    respond_to do |format|
      format.json { yield }
      format.html
    end
  end
end
