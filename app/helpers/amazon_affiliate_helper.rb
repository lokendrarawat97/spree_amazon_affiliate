module AmazonAffiliateHelper
  def amazon_affiliate_url(product)
    link_to(t(:buy_on_amazon), "http://www.amazon.com/gp/product/#{product.amazon_id}/ref=as_li_tf_tl?ie=UTF8&tag=#{Spree::Config.amazon_options[:configure][:associate_tag]}&linkCode=as2&camp=217145&creative=399369&creativeASIN=#{product.amazon_id}", :class => 'amazon-affiliate-link', :target => '_blank') +
    image_tag("http://www.assoc-amazon.com/e/ir?t=#{Spree::Config.amazon_options[:configure][:associate_tag]}&l=as2&o=1&a=#{product.amazon_id}&camp=217145&creative=399369", :width=>"1", :height=>"1", :border=>"0", :alt=>"", :style=>"border:none !important; margin:0px !important;")
  end
end
