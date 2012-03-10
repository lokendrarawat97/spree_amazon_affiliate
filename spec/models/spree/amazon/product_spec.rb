require 'spec_helper'

describe Spree::Amazon::Product do

  describe '#save_to_spree' do

    it 'should create a spree product with images and a master variant with stock' do
      amazon_prod = subject.class.find('B005CWIVYI')
      amazon_prod.save_to_spree
      spree_prod = Spree::Product.find_by_amazon_id('B005CWIVYI')
      spree_prod.should be_present
      spree_prod.images.size.should be > 1
      spree_prod.master.should be_present
      spree_prod.master.count_on_hand.should eql(1)
    end

    it 'should encode html entities' do
      amazon_prod = subject.class.find('B006ZLX75S')
      amazon_prod.save_to_spree
      spree_prod = Spree::Product.find_by_amazon_id('B006ZLX75S')
      spree_prod.description.should_not include('&lt;b&gt;')
      spree_prod.description.should include('<b>')
    end

  end

  context 'ClassMethods' do

    describe 'save_to_spree_or_find' do

      it 'should create a spree product if it doesnt exist already' do
        subject.class.should_receive(:find).once
        spree_prod = subject.class.save_to_spree_or_find('B0051VVOB2')
        spree_prod.should eql(Spree::Product.find_by_amazon_id('B0051VVOB2'))
      end

      it 'should load spree product if it exists' do
        amazon_prod = subject.class.find('B0051VVOB2')
        amazon_prod.save_to_spree
        subject.class.should_not_receive(:find)
        spree_prod = subject.class.save_to_spree_or_find('B0051VVOB2')
        spree_prod.should eql(Spree::Product.find_by_amazon_id('B0051VVOB2'))
      end

    end

  end

end
