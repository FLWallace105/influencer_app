class Influencer::Import
  include ActiveModel::Model
  attr_accessor :file, :imported_count, :updated_count

  def process!
    @imported_count = 0
    @updated_count = 0

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      if CustomCollection.find_by_id(row[:collection_id]).nil?
        errors.add(:base, "Line #{$INPUT_LINE_NUMBER} - #{influencer.try(:email)}, Collection id not found.")
      elsif influencer.persisted?
        process_existing_influencer(influencer)
      else
        process_new_influencer(influencer)
      end
    end
  end

  def save
    process!
    errors.none?
  end

  private

  def process_existing_influencer(influencer)
    influencer.active = true

    if influencer.save
      @updated_count += 1
    else
      errors.add(:base, "Line #{$INPUT_LINE_NUMBER} - #{influencer.try(:email)}, #{influencer.errors.full_messages.join(', ')}")
    end
  end

  def process_new_influencer(influencer)
    if influencer.save
      @imported_count += 1
    else
      errors.add(:base, "Line #{$INPUT_LINE_NUMBER} - #{influencer.try(:email)}, #{influencer.errors.full_messages.join(', ')}")
    end
  end
end
