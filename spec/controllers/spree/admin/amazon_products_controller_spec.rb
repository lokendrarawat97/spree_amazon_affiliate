require 'spec_helper'

describe Spree::Admin::AmazonProductsController do

  it 'should create a spree product from amazon product' do
    pending 'need to figure out how to make controller route go to admin/amazon_products'
    post :create
    response.should redirect_to(admin_amazon_products_path)

    post :create, :asin => 'B003C4YIFE'
    response.should redirect_to(edit_admin_product_path(assigns[:product]))
  end

  it "should render index successfully" do
    pending 'need to figure out how to make controller route go to admin/amazon_products'
    get :index
    response.should be_success
    assigns[:amazon_products].should be_present

    get :index, :taxon_id => Spree::Amazon::Taxon.roots.first.id
    response.should be_success
    # TODO: Right now it is using the searcher rather than explicitly pulling products from the taxon
    assigns[:amazon_products].should be_present
    # assigns[:amazon_products].should == Spree::Amazon::Taxon.roots.first.products
  end

end
