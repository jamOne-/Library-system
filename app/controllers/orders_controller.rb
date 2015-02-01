class OrdersController < ApplicationController
  before_action :logged_in_user, only: [:create, :show, :index]
  before_action :admin_user,     only: [:destroy, :update, :index]
  before_action :correct_user,   only: [:show]
  before_action :get_order,      only: [:destroy, :show, :update]

  def create
    @order = Order.new
    @book = Book.find(params.permit(:book_id)[:book_id])

    if (@book.ordered)
      flash[:danger] = "You can't order this book"
      redirect_to @book
    else
      @order.expiration = Time.now + day_to_sec(3)
      @order.order_type = "Just ordered"
      @order.user_id = current_user.id
      @order.book_id = @book.id
      @order.save

      @book.update_attributes(:ordered => true, :order_id => @order.id)

      flash[:success] = "You have three days to confirm your order"
      redirect_to @order
    end
  end

  def destroy
    Book.find(@order.book_id).update_attributes(:ordered => false)
    @order.destroy
    flash[:success] = "Order deleted"
    redirect_to orders_url
  end

  def show
  end

  def index
    @orders = Order.all.order(:expiration, :updated_at).paginate(:page => params[:page], :per_page => 30)
  end

  def update
    @order.expiration = Time.now + day_to_sec(60)
    @order.order_type = "Borrowed" unless @order.order_type == "Borrowed"
    @order.save

    flash[:success] = "Order updated"
    redirect_to @order
  end

  private
    # Converts days to seconds
    def day_to_sec(days)
      60*60*24*days
    end
      
    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = Order.find(params[:id]).user
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end

    # Sets order variable
    def get_order
      @order = Order.find(params[:id])
    end
end
