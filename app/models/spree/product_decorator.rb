require 'open-uri'

Spree::Product.class_eval do
  class << self

    def save_from_amazon(options)
      if @spree_product = create!(options[:attributes])
        @master = @spree_product.master
        @master.count_on_hand = options[:count_on_hand]
        @master.price = options[:price]
        @master.save
        options[:images].map{ |image|
          @spree_product.images.create(:attachment => open(image.attachment.url(:large)))
        }
      end
      @spree_product
    end

  end # end class << self
end
