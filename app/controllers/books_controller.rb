# encoding: utf-8

class BooksController < ApplicationController
  before_filter :authenticate_school!

  def index
    @books = Book.scoped
  end

  def new
    @book = current_school.books.new
  end

  def create
    @book = current_school.books.create(params[:book])

    if @book.valid?
      redirect_to books_path, notice: "Knjiga je uspješno stvorena."
    else
      render :new
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(params[:book])
      redirect_to books_path, notice: "Knjiga je uspješno izmijenjena."
    else
      render :edit
    end
  end

  def destroy
    current_school.books.destroy(params[:id])
    redirect_to books_path, notice: "Knjiga je uspješno izbrisana."
  end
end
