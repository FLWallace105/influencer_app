class Influencer::Import
  include ActiveModel::Model
  attr_accessor :file, :imported_count, :updated_count

  def dry_run
    @line_num = 1
    @last_good = ""
    $bad_row_num = nil
    $bad_row_data = nil
    bad_row = false
    CSV.foreach(file.path, :encoding => 'ISO-8859-1', :headers => true) do |row|
      @line_num += 1
      #puts "#{@line_num} : #{row}"
      
      row.each do |myfield|
        
        mystring = myfield[1]
        #puts mystring
        if !mystring.nil?
            mystring.each_char { |c| 
            #puts c.inspect
            byte_num = c.bytes
            #puts byte_num.inspect
            new_byte = byte_num[0].to_i
            if new_byte > 127
              bad_row = true
            end
            
              }
        end

      end
      
    if bad_row == true
        puts "bad row = #{@line_num}"
        puts "bad row = #{row}"
        $bad_row_num = @line_num
        $bad_row_data = row
        break
    end

    end
    if !$bad_row_num.nil?
      errors.add(:base, "Line #{$bad_row_num} - #{$bad_row_data}, Non ASCII Character found.")
      errors.add(:base, "No influencers were added due to non ASCII characters.")
    end
    return bad_row
    
  end

  def process!
    @imported_count = 0
    @updated_count = 0

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      if CustomCollection.find_by_collection_id(row[:collection_id]).nil?
        errors.add(:base, "Line #{$INPUT_LINE_NUMBER} - #{influencer.try(:email)}, Collection id not found.")
      elsif influencer.persisted?
        process_existing_influencer(influencer)
      else
        process_new_influencer(influencer)
      end
    end
  end

  def save
    my_halt = dry_run
    if my_halt == false
      process!
    end
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
