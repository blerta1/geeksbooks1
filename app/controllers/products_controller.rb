class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]
  skip_before_action :authorize
  # GET /products.json
  def index
    if (session[:role]=="admin")
     @products = Product.all
    else 

    @products = Product.where(:author_id => session[:user_id])
   end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
   
    @product = Product.new 
    @categories = Category.all.map{|c| [ c.name, c.id ] }

   
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all.map{|c| [ c.name, c.id ] }
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.category_id = params[:category_id] 
     @product.author= session[:user_name]
     @product.author_id= session[:user_id]
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product.category_id = params[:category_id]
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
        @products = Product.all
         ActionCable.server.broadcast 'products',
         html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
   if( @product.destroy)
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
    else 
      respond_to do |format|
      format.html { redirect_to products_url, notice: 'Book could not be deleted due to its presence in one of the current ORDERS! ' }
      format.json { head :no_content }
    end
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
  

def require_permission
   unless User.find_by(id: session[:user_id], role: "admin")
    if session[:user_id] != @product.author_id
    redirect_to login_path , alert: "Log in as Admin Please!"
    #Or do something else here
    end
  end
end
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image, :price, :pdf, :author, :author_id,:category_id)
    end
    def who_bought
        @product = Product.find(params[:id])
        @latest_order = @product.orders.order(:updated_at).last
        if stale?(@latest_order)
           respond_to do |format|
             format.atom
           end
        end
    end
end
