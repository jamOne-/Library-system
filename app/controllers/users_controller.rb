class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :delete, :toggle_admin, :orders, :search]
  before_action :correct_user,   only: [:show, :edit, :update, :orders]
  before_action :admin_user,     only: [:index, :delete, :toggle_admin, :search]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @user_query = User.new
    @users = User.all.order(:admin, :name, :email).paginate(:page => params[:page], :per_page => 30)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Library!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def orders
    @user = User.find(params[:id])
    @orders = @user.orders.order(:expiration, :updated_at).paginate(:page => params[:page], :per_page => 30)
    render 'orders/index'
  end

  def toggle_admin
    @user = User.find(params[:id])
    @user.update_attributes(:admin => !@user.admin)
    redirect_to users_path
  end

  def search
    safe_params = remove_empty(params.require(:user).permit(:name, :email, :id))
    @user_query = User.new
    @user_query.attributes = safe_params

    @users = User.where(safe_params).order(:admin, :name, :email).paginate(:page => params[:page], :per_page => 30)
    render 'index'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end
end
