# encoding: utf-8

class ErasController < ApplicationController
  before_filter :authenticate_school!

  def index
    @eras = Era.scoped
  end

  def new
    @era = current_school.eras.new
  end

  def create
    @era = current_school.eras.create(params[:era])

    if @era.valid?
      redirect_to eras_path, notice: "Književno razdoblje je uspješno stvoreno."
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :new
    end
  end

  def edit
    @era = Era.find(params[:id])
  end

  def update
    @era = Era.find(params[:id])

    if @era.update_attributes(params[:quiz])
      redirect_to eras_path, notice: "Književno razdoblje je uspješno izmjenjeno."
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :new
    end
  end

  def destroy
    current_school.eras.destroy(params[:id])
    redirect_to eras_path, notice: "Književno razdoblje je uspješno izbrisano."
  end
end
