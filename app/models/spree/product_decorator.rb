require 'open-uri'

Spree::Product.class_eval do

  def self.save_from_amazon(options)
    # Find an existing product to update or build a new one.
    if product = find_by_amazon_id(options[:asin])
      product.update_attributes(options[:attributes])    
    else
      product = new(options[:attributes])
      product.amazon_id = options[:asin]
    end
    if product.save
      # Update variants
      @master = product.master
      @master.is_master = true # No longer being set now?
      @master.count_on_hand = options[:count_on_hand]
      @master.price = options[:price]
      @master.save 
      options[:images].map{ |image|
        @master.images.create(:attachment => open(image.attachment.url(:large)))
      }
    end
    product
  end

end
