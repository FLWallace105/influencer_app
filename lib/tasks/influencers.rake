namespace :create do
  desc 'Import influencers from a csv without creating orders for them. If an
        influencer already exists it will be updated.'
  task influencers: :environment do
    filename = File.join Rails.root, "test_influencers.csv"
    counter = 0

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      if influencer.save
        counter += 1
      else
        puts "#{influencer.email} - #{influencer.errors.full_messages.join(',')}"
      end
    end

    puts "Imported #{counter} influencers."
  end

  desc 'Import influencers from a csv and create orders for them.
        If an influencer already exists it will be updated and an order will
        still be created for that influencer.'
  task influencers_and_orders: :environment do
    import = Influencer::Import.new(file: File.open("test_influencers.csv"))
    import.save
    puts "Imported #{import.imported_count} #{'influencer'.pluralize(import.imported_count)}."
    puts import.errors.full_messages
  end
end
