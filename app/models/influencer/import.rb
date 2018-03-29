class Influencer::Import
  include ActiveModel::Model
  attr_accessor :file, :imported_count

  def process!
    @imported_count = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      collection_id = row[:collection_id]

      if collection_id.try(:strip).try(:present?) && influencer.save
        @imported_count += 1
        orders = influencer.create_orders_from_collection(
          collection_id: collection_id,
          shipping_method_requested: row[:shipping_method_requested]
        )

        puts "created #{orders.count} orders for #{influencer.first_name} #{influencer.last_name}"
      else
        errors.add(:base, "Line #{$INPUT_LINE_NUMBER} - #{influencer.errors.full_messages.join(',')}")
      end
    end
  end

  def save
    process!
    errors.none?
  end
end
