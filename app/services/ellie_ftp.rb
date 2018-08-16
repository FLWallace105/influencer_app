class EllieFTP < Net::FTP
  def initialize
    super
    connect(Rails.application.credentials[:ellie_ftp][:host],
            Rails.application.credentials[:ellie_ftp][:port])
    login(Rails.application.credentials[:ellie_ftp][:username],
          Rails.application.credentials[:ellie_ftp][:password])
  end

  def upload_orders_csv(file)
    directory = '/MarikaInfluencer/ReceiveOrder'
    puts "Starting orders csv upload of #{file} to #{directory} on #{Rails.application.credentials[:ellie_ftp][:host]}"
    chdir directory
    put(File.open(file))
    close
    File.delete(file)
    puts 'Successfully uploaded CSV'
  end

  def pull_order_tracking
    directory = '/MarikaInfluencer/SendOrder'
    puts "Polling tracking FTP server: #{directory}"
    chdir directory
    # in production match against: ORDERTRK, when manually testing match against TEST
    mlsd.select { |entry| entry.type == 'file' && /ORDERTRK/.match?(entry.pathname) }.each do |entry|
      puts "Found #{entry.pathname}"
      process_tracking_csv(entry.pathname)
    end
  end

  def process_tracking_csv(path)
    puts "Starting Tracking CSV processing of #{path}"
    tracking_data = get_tracking_csv(path)

    # add all influencer lines to the database
    # send an email if one has not been sent already
    tracking_data.select { |line| /^#INMK/ =~ line['fulfillment_line_item_id'] }.each do |tracking_line|
      begin
        tracking = InfluencerTracking.find_or_initialize_by(
          order_name: tracking_line['fulfillment_line_item_id']
        )
        next unless tracking.influencer.try(:email).present?
        tracking.update(carrier: tracking_line['carrier'], tracking_number: tracking_line['tracking_1'])

        unless tracking.email_sent?
          puts "Sending tracking email to #{tracking.influencer.email}"
          InfluencerTrackingMailer.send_tracking_info(tracking).deliver_later
        end
      rescue ActiveRecord::RecordNotFound => e
        puts e
        next
      end
    end

    move_file_to_archive(path)
  end

  def get_tracking_csv(remote_file)
    parse_tracking_csv(format_file_to_string(remote_file))
  end

  private

  # Retrieves a file and returns the contents as a string
  def format_file_to_string(remote_file)
    output = ""
    get(remote_file) { |data| output += data }
    File.delete(remote_file)
    output
  end

  def parse_tracking_csv(data)
    csv = CSV.parse(data).map { |line| line.map(&:strip) }
    headers = csv.shift
    csv.map { |line| headers.zip(line).to_h }
  end

  def move_file_to_archive(path)
    begin
      puts "Archiving #{path} on FTP server"
      pathname = Pathname.new path
      rename(path, pathname.dirname + 'Archive' + pathname.basename)
    rescue Net::FTPPermError => e
      puts e
      puts 'Archive file exists already or cannot be overwritten. Removing original.'
      delete path
    end
  end
end
