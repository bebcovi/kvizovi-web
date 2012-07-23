class BooksController < ApplicationController
  def index
    @books = Book.all

    respond_to do |format|
      format.json { render json: @books }
    end
  end

  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.json { render json: @book }
    end
  end

  def create
    @book = Book.create(params[:book])

    if @book.valid?
      head :created, location: book_path(@book)
    else
      render json: @book.errors, status: :bad_request
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(params[:book])
      head :ok
    else
      render json: @book.errors, status: :bad_request
    end
  end

  def destroy
    Book.destroy(params[:id])
    head :ok
  end
end
