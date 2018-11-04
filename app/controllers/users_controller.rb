class UsersController < ApplicationController
  skip_before_action :authorize
  #before_action :books_listing, only: [:show]
  before_action :authorize_admin, only: [:show, :index, :edit, :destroy, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name, :email)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html {redirect_to login_path, method: :new, alert: 'User was successfully created. You need to log in!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end
rescue_from 'User::Error' do |exception|
  redirect_to users_url, notice: exception.message
end
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    current_password = params[:user].delete(:current_password) 
        # Return and simultaneously delete value
    respond_to do |format|
       if @user.update(user_params) && @user.authenticate(current_password)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        @user.errors.add(:current_password, "for user is incorrect") unless @user.authenticate(current_password)
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  rescue_from 'User::Error' do |exception|
  redirect_to users_url, notice: exception.message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation)
    end
end
