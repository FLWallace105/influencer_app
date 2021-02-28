module ShopifyCache
  # Caches both Products and the associated ProductVariants
  def self.pull_products
    product_count = ShopifyAPI::Product.count()
    puts "Starting pull of Product"
    puts "Found #{product_count} records"

    Product.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('products')
    ProductVariant.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('product_variants')

    products = []
    variants = []
    shopify_products = ShopifyAPI::Product.find(:all)

    shopify_products.each do |shopify_product|
      products << build_product(shopify_product)
      shopify_variants = shopify_product.variants

      shopify_variants.each do |shopify_variant|
        variants << build_variant(shopify_variant)
      end
      wait_for_shopify_credits
    end

    while shopify_products.next_page?
      shopify_products = shopify_products.fetch_next_page

      shopify_products.each do |shopify_product|
        products << build_product(shopify_product)

        shopify_variants = shopify_product.variants
        shopify_variants.each do |shopify_variant|
          variants << build_variant(shopify_variant)
        end
      end
      wait_for_shopify_credits
    end

    store(Product, products.flatten)
    store(ProductVariant, variants.flatten)
  end

  def self.pull_collects
    pull_entity ShopifyAPI::Collect, Collect
  end

  def self.pull_custom_collections
    pull_entity ShopifyAPI::CustomCollection, CustomCollection
  end

  def self.pull_all
    pull_collects
    pull_custom_collections
    pull_products
  end

  # Used to cache a Shopify Entity to a local database.
  #
  # Arguments:
  #
  # * api_entity: The ShopifyAPI class to query
  # * db_entity: The ActiveRecord class to save into
  # * query_params: a hash corresponting to the index query params of the
  # ShopifyAPI::Entity::where function. Useful for limiting the scope of the
  # cache update
  # * &block(data): data is the attributes hash of the shopify entity. The result
  # of the block is passed to the ActiveRecord::Base#update function.
  #
  # Returns: nil
  def self.pull_entity(api_entity, db_entity, query_params = {})
    puts "Starting pull of #{api_entity}"
    puts "Found #{api_entity.count} records"

    db_entity.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!(db_entity.to_s.tableize)

    shopify_resources = api_entity.find(:all, params: { limit: 250 })
    resources = []
    resources << process_resources(db_entity.to_s.tableize, shopify_resources)

    while shopify_resources.next_page?
      shopify_resources = shopify_resources.fetch_next_page
      resources << process_resources(db_entity.to_s.tableize, shopify_resources)
      wait_for_shopify_credits
    end

    store(db_entity, resources.flatten)
  end

  def self.wait_for_shopify_credits
    return if ShopifyAPI.credit_left > 5

    puts "CREDITS LEFT: #{ShopifyAPI.credit_left}"
    puts "SLEEPING 10"
    sleep 10
  end

  def self.store(db_entity, resources)
    db_entity.import(resources, batch_size: 50, all_or_none: true)
    puts "Total #{db_entity} stored: #{resources.count}"
  end


  def self.process_resources(collection_name, shopify_resources)
    send("process_#{collection_name}", shopify_resources)
  end

  def self.process_custom_collections(custom_collections)
    my_custom_collections = []
    custom_collections.each do |custom_collection|
      attributes = {
        collection_id: custom_collection.id,
        handle: custom_collection.handle,
        title: custom_collection.title,
        updated_at: custom_collection.updated_at,
        body_html: custom_collection.body_html,
        published_at: custom_collection.published_at,
        sort_order: custom_collection.sort_order,
        template_suffix: custom_collection.template_suffix,
        published_scope: custom_collection.published_scope
      }
      my_custom_collections << CustomCollection.new(attributes)
    end
    my_custom_collections
  end

  def self.process_collects(collects)
    my_collects = []
    collects.each do |collect|  
      collect_attributes = collect.attributes
      attributes = {
        collect_id: collect_attributes['id'],
        collection_id: collect_attributes['collection_id'],
        product_id: collect_attributes['product_id'],
        featured: collect_attributes['featured'],
        created_at: collect_attributes['created_at'],
        updated_at: collect_attributes['updated_at'],
        position: collect_attributes['position'],
        sort_value: collect_attributes['sort_value']
      }
      my_collects << Collect.new(attributes)
    end
    my_collects
  end

  def self.build_product(product)
    attributes = {
      product_id: product.attributes['id'],
      title: product.attributes['title'],
      product_type: product.attributes['product_type'],
      created_at: product.attributes['created_at'],
      updated_at: product.attributes['updated_at'],
      handle: product.attributes['handle'],
      template_suffix: product.attributes['template_suffix'],
      body_html: product.attributes['body_html'],
      tags: product.attributes['tags'],
      published_scope: product.attributes['published_scope'],
      vendor: product.attributes['vendor'],
      options: product.attributes['options'][0].attributes,
      images: product.attributes['images'].map{|image| image.attributes },
      image: product.attributes['image']
    }
    Product.new(attributes)
  end

  def self.build_variant(variant)
    attributes = {
      variant_id: variant.attributes['id'],
      product_id: variant.prefix_options[:product_id],
      title: variant.attributes['title'],
      price: variant.attributes['price'],
      sku: variant.attributes['sku'],
      position: variant.attributes['position'],
      inventory_policy: variant.attributes['inventory_policy'],
      compare_at_price: variant.attributes['compare_at_price'],
      fulfillment_service: variant.attributes['fulfillment_service'],
      inventory_management: variant.attributes['inventory_management'],
      option1: variant.attributes['option1'],
      option2: variant.attributes['option2'],
      option3: variant.attributes['option3'],
      created_at: variant.attributes['created_at'],
      updated_at: variant.attributes['updated_at'],
      taxable: variant.attributes['taxable'],
      barcode: variant.attributes['barcode'],
      weight_unit: variant.attributes['weight_unit'],
      weight: variant.attributes['weight'],
      inventory_quantity: variant.attributes['inventory_quantity'],
      image_id: variant.attributes['image_id'],
      grams: variant.attributes['grams'],
      inventory_item_id: variant.attributes['inventory_item_id'],
      tax_code: variant.attributes['tax_code'] || '',
      old_inventory_quantity: variant.attributes['old_inventory_quantity'],
      requires_shipping: variant.attributes['requires_shipping']
    }
    ProductVariant.new(attributes)
  end
end
