module SpreeEcs
  class Taxon < SpreeEcs::Base
    class << self

      def top_sellers(id)
        cache("spree_ecs:taxon:top-sellers:#{id}"){
          log("Taxon top sellers: #{id}")
          (Amazon::Ecs.browse_node_lookup(id, {:response_group => 'TopSellers'}).doc/'TopSeller/ASIN').map{ |x| x.text }
        }
      rescue
        []
      end

      # Find category by BrowseNodeId
      #
      def find(id)
        cache("spree_ecs:taxon:#{id}"){
          log("Find Taxon: #{id} ")
          parse_browse_node(Amazon::Ecs.browse_node_lookup(id, {:response_group => "BrowseNodeInfo"}))
        }
      end

      private

      def parse_browse_node(raw_data)
        doc = raw_data.doc
        log doc
        Rails.logger.debug doc
        browse_node_id = (doc/'BrowseNodes/BrowseNode/BrowseNodeId').text
        {
          :name         => (doc/'BrowseNodes/BrowseNode/Name').text.gsub('&amp;', '&'),
          :id           => browse_node_id,
          :search_index => 'All',
          :children     => children(browse_node_id, doc),
          :ancestors    => ancestors(doc)
        }
      end

      def children(browse_node_id, doc)
        (doc/'BrowseNodes/BrowseNode/Children/BrowseNode').map{|v|
          {
            :name         => v.at('Name').text.gsub('&amp;', '&'),
            :id           => v.at('BrowseNodeId').text,
            :search_index => 'All',
            :parent_id    => browse_node_id
          }
        }
      end

      def ancestors(doc)
        (doc/"Ancestors").map{ |v| parse_ancestor_node(v/"BrowseNode")}
      rescue
        []
      end

      def parse_ancestor_node(node)
        { :name => node.at('Name').text.gsub('&amp;', '&'), :id => node.at('BrowseNodeId').text }
      end
    end # end class << self

  end
end
