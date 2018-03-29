namespace :influencers do
  desc 'import influencers from a csv'
  task csv_import: :environment do
    filename = File.join Rails.root, "influencers_test.csv"
    counter = 0

    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      if influencer.save
        counter += 1
      else
        puts "#{influencer.emal} - #{influencer.errors.full_messages.join(',')}"
      end
    end

    puts "Imported #{counter} influencers."
  end
end
