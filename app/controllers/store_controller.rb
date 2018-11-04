class StoreController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:edit, :update, :destroy]
  skip_before_action :authorize
  include CurrentCart
  before_action :set_cart
  def index
  	@products = Product.order(:title)
  end

  def search_results #displays search results
  	
   @found_products= Product.keyword_search(params[:search_keywords])
  end
  
end
