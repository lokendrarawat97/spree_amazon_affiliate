require 'csv'

class Spree::Admin::AmazonImportsController < Spree::Admin::BaseController

  def create
    CSV.foreach(params[:upload_file].path, :headers => true) do |row|
      if new_product = Spree::Amazon::Product.find(row[0])
        new_product.save_to_spree
        product = Spree::Product.find_by_amazon_id(row[0])
        associate_product_with_taxon product, row[1]
        associate_product_with_taxon product, row[2]
      end
    end
    redirect_to admin_amazon_imports_path, :notice => t(:upload_complete)
  end

  def index
  end

  def new
    send_data File.read(File.expand_path('../../../../assets/templates/Amazon Import Template.csv', __FILE__)), :filename => t(:amazon_import_template) + '.csv'
  end

  private

  # This method accepts a taxon hierarchy string where each level has a delimeter of: >
  #
  # Example:
  # Categories > Clothing > Men
  # The above example will find or create a taxon tree with Categories as the root and assign the product to the Men's child taxon.
  def associate_product_with_taxon(product, taxon_hierarchy)
    return if product.nil? || taxon_hierarchy.nil?
    taxon_hierarchy = taxon_hierarchy.split(/\s*>\s*/)
    # Using find_or_create_by_name is more elegant, but our params code automatically downcases the taxonomy name.
    taxonomy = Spree::Taxonomy.find(:first, :conditions => ["lower(name) = ?", taxon_hierarchy[0].downcase])
    taxonomy = Spree::Taxonomy.create(:name => taxon_hierarchy[0].capitalize) if taxonomy.nil?
    last_taxon = taxonomy.root
    taxon_hierarchy.each_with_index do |taxon,i|
      next if i == 0
      last_taxon = last_taxon.children.find_or_create_by_name_and_taxonomy_id(taxon, taxonomy.id)
    end
    # Spree only needs to know the most detailed taxonomy item
    product.taxons << last_taxon unless product.taxons.include?(last_taxon)
    product.save
  end

end
