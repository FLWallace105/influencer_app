namespace :create do
  desc 'Import influencers from a csv. If an
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
end
