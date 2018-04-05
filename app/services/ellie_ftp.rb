class EllieFTP < Net::FTP
  def initialize
    super
    connect(ENV['ELLIE_FTP_HOST'], ENV['ELLIE_FTP_PORT'])
    login(ENV['ELLIE_FTP_USERNAME'], ENV['ELLIE_FTP_PASSWORD'])
  end

  def upload_orders_csv(file)
    directory = '/EllieInfluencer/ReceiveOrder'
    puts "Starting orders csv upload of #{file} to #{directory} on #{ENV['ELLIE_FTP_HOST']}"
    chdir directory
    put(File.open(file))
    close
    File.delete(file)
    puts 'Successfully uploaded CSV'
  end
end
