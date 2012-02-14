module AmazonAffiliateHelper

  # Generates an affiliate link to the Amazon Product page based on your Associate Tag.
  #
  # This is used to display the link on the Store product page.
  #
  # === Parameters
  # * <tt>{String} <b>asin</b></tt> The Amazon Product ID to link to.
  def amazon_affiliate_link(asin)
    link_to(t(:buy_on_amazon), amazon_affiliate_url(asin), :class => 'amazon-affiliate-link', :target => '_blank') +
    # image_tag("http://www.assoc-amazon.com/e/ir?t=#{Spree::Config.amazon_options[:configure][:associate_tag]}&a=#{asin}", :width=>"1", :height=>"1", :border=>"0", :alt=>"", :style=>"border:none !important; margin:0px !important;")
    image_tag("http://www.assoc-amazon.com/e/ir?t=#{SpreeAmazonAffiliate::Engine.amazon_options[:configure][:associate_tag]}&a=#{asin}", :width=>"1", :height=>"1", :border=>"0", :alt=>"", :style=>"border:none !important; margin:0px !important;")
  end

  # Generates an affiliate url to the Amazon Product page based on your Associate Tag.
  #
  # Used to get the product url by the link helper method, and the admin panel links.
  #
  # === Parameters
  # * <tt>{String} <b>asin</b></tt> The Amazon Product ID to link to.
  def amazon_affiliate_url(asin)
    # "http://www.amazon.com/dp/#{asin}?tag=#{Spree::Config.amazon_options[:configure][:associate_tag]}"
    "http://www.amazon.com/dp/#{asin}?tag=#{SpreeAmazonAffiliate::Engine.amazon_options[:configure][:associate_tag]}"
  end

end
