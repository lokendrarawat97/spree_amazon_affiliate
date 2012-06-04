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
      options[:images].map{ |i|
        filename = File.basename(i.attachment.url(:large))
        unless image = @master.images.find_by_attachment_file_name(filename)
          image = @master.images.build
        end
        begin
          io = open(i.attachment.url(:large))
          def io.original_filename; File.basename(base_uri.path); end # Hack to make io.original_filename return an actual filename rather than string.io or jibberish.
          image.attachment = io
          image.save
        rescue # Rescue 404
        end
      }
    end
    product
  end

end
