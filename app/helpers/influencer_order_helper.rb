module InfluencerOrderHelper
  def print_order_shipping_address(order)
    "#{order.shipping_address['address1']} #{order.shipping_address['address2']}
    #{order.shipping_address['city']}, #{order.shipping_address['province_code']}
    #{order.shipping_address['zip']}"
  end

  def print_order_billing_address(order)
    "#{order.billing_address['address1']} #{order.billing_address['address2']}
    #{order.billing_address['city']}, #{order.billing_address['province_code']}
    #{order.billing_address['zip']}"
  end

  def print_order_line_items(order)
    order_item_names = InfluencerOrder.where(name: order.name).map do |influencer_order|
      influencer_order.line_item["item_name"]
    end

    order_item_names.join(', ')
  end
end
