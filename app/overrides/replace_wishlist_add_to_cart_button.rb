if Rails.application.railties.all.map(&:railtie_name).include? "spree_wishlist"

  Deface::Override.new(:virtual_path => "wishlists/show",
                       :name => "replace_wishlist_add_to_cart_button",
                       :replace => "code[erb-loud]:contains('populate_orders_url')",
                       :closing_selector => "code[erb-silent]:contains('end')",
                       :text => %q{<% if product.amazon_id.present? %>
                                   <%= amazon_affiliate_link(product.amazon_id) %>
                                 <% else %>
                                   <%= form_for :order, :url => populate_orders_url do |f| %>
                                     <%= hidden_field_tag "variants[#{variant.id}]", 1, :size => 3 %>
                                     <%= link_to t(:add_to_cart), '#', :onclick => "$(this).parent().submit(); return false;" %>
                                   <% end %>
                                 <% end %>})

end
