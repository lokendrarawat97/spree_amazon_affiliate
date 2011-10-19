require 'open-uri'
module Spree
  module Amazon

    class Product < Spree::Amazon::Base

      attr_accessor :price, :name, :taxon_id, :id, :description, :images, :url, :variants, :taxons
      attr_accessor :taxon_name, :binds, :props_str, :sale_props, :props, :created_at, :updated_at
      attr_accessor :variant_options, :variant_attributes

      class << self

        def class_name
          "Spree::Amazon::Product"
        end

        # Find product by ASIN
        #
        def find(product_asin)
          new( SpreeEcs::Product.find(product_asin, { :response_group => "Large, Variations" }))
        end

        def multi_find(asins)
          SpreeEcs::Product.multi_find(asins, { :response_group => "Large, Variations" }).map{|v| new(v) }
        end

        def name
          "Product"
        end

        def prepare_id(product_id)
          product_id.to_s
        end

        def save_to_spree_or_find(amazon_id_or_id)
          unless @product = ::Product.find_by_amazon_id(amazon_id_or_id)
            @product = find(amazon_id_or_id).try(:save_to_spree)
          end
          @product
        end

        # Search products
        #
        def search(options={})
          options[:q] ||= '*'
          Rails.logger.debug "SEARCH OPTS #{options.inspect}"
          @results = SpreeEcs::Product.search(options)
          unless @results.blank?
            Spree::Amazon::ProductCollection.build({
                                                    :current_page  => @results[:current_page],
                                                    :products      => @results[:products].map{ |item| new(item) },
                                                    :total_entries => @results[:total_entries],
                                                    :num_pages     => @results[:num_pages],
                                                    :per_page      => 10,
                                                    :search_index  => options[:search_index]
                                                   })
          else
            Spree::Amazon::ProductCollection.build_empty
          end
        end

      end # end class << self

      def available?
        true
      end

      def has_stock?
        true
      end

      def has_variants?
        !@variants.blank?
      end

      # Product images
      #
      def images
        @images.blank? ? [] : @images.map{ |x| Spree::Amazon::Image.new(x, @name) }
      end

      def master
        self
      end

      def persisted?
        false
      end

      def possible_promotions
        [ false ]
      end

      def price
        @price
      end

      # Save amazon product to base or find on amazon id
      #
      def save_to_spree
        ::Product.save_from_amazon({
                                     :attributes =>{
                                       :amazon_id      => self.id,
                                       :sku            => self.id,
                                       :name           => self.name,
                                       :count_on_hand  => 10,
                                       :available_on   => 1.day.ago,
                                       :description    => self.description,
                                       :price          => self.price.to_f
                                     },
                                     :price => self.price.to_f,
                                     :images => self.images
                                   })
      end

      def taxons
        @taxons.map{ |x| Spree::Amazon::Taxon.find(x[:id]) }
      end

      def to_param
        "#{self.id}"
      end

      def variants
        @_variants ||= Spree::Amazon::Variant.build_variants_collection(self, @variants)
        @_variants
      end

    end
  end

end
