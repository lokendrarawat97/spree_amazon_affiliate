require 'spec_helper'

describe Spree::Admin::AmazonTaxonsController do

  it "should render index successfully" do
    pending 'need to figure out how to make controller route go to admin/amazon_taxons'
    get :index
    response.should be_success
    assigns[:taxons].should eql(@taxons = Spree::Amazon::Taxon.roots)

    get :index, :taxon_id => Spree::Amazon::Taxon.roots.first.id
    response.should be_success
    assigns[:taxons].map(&:id).should  eql(Spree::Amazon::Taxon.roots.first.children.map(&:id))
  end

end
