class Admin::AmazonProductsController < Admin::BaseController

  def create
    if @product = Spree::Amazon::Product.save_to_spree_or_find(params[:asin])
      redirect_to edit_admin_product_path(@product)
    else
      redirect_to admin_amazon_products_path
    end
  end

  def index
    @searcher = Spree::Search::Amazon.new(params.merge(:taxon => params[:taxon_id]))
    # @searcher = Spree::Search::Amazon.new(params)
    @amazon_products = @searcher.retrieve_products
  end

end
