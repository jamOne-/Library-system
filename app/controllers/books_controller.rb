class BooksController < ApplicationController
  before_action :admin_user, only: [:new, :create, :destroy, :edit, :update]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      flash[:success] = "Book succesfully added!"
      redirect_to @book
    else
      render 'new'
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "Book deleted"
    redirect_to books_url
  end

  def show
    @book = Book.find(params[:id])
  end

  def index
    @book_query = Book.new
    @books = Book.all.order(:ordered, :author, :title, :year).paginate(:page => params[:page], :per_page => 30)
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Book updated"
      redirect_to @book
    else
      render 'edit'
    end
  end

  def search
    safe_params = remove_empty(params.require(:book).permit(:title, :author, :id))
    @book_query = Book.new
    @book_query.attributes = safe_params

    @books = Book.where(safe_params).order(:ordered, :author, :title, :year).paginate(:page => params[:page], :per_page => 30)
    render 'index'
  end

  private
    def book_params
      params.require(:book).permit(:title, :author, :year)
    end
end
