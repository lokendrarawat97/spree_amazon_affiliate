require 'spec_helper'

describe Admin::AmazonTaxonsController do

  context "#authorize_admin" do
    let(:user) { User.new }

    before do
      controller.stub :current_user => user
    end

    it "should render index successfully" do
      get :index
      response.should render_template :index
    end

  end

end
