class ApplicationController < ActionController::Base
  private

  def respond_with_json
    respond_to do |format|
      format.json { yield }
      format.html
    end
  end
end
