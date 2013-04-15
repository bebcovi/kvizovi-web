class VersionsController < ApplicationController
  def revert
    version = Version.find(params[:id])
    version.reify.save!
    redirect_to :back, notice: flash_success
  end
end
