class EllieFTP < Net::FTP
  attr_accessor :host, :username, :password, :debug

  def initialize
    options = {}
    @username = ENV['ELLIE_FTP_USERNAME']
    @password = ENV['ELLIE_FTP_PASSWORD']
    @host = ENV['ELLIE_FTP_HOST']
    @debug = true
    options[:username] = @username
    options[:password] = @password
    options[:debug_mode] = @debug
    super(@host, options)
  end

  def upload_orders_csv(file)
    directory = '/EllieInfluencer/ReceiveOrder'
    puts "Starting orders csv upload of #{file} to #{directory} on #{@host}"
    chdir directory
    put(File.open(file))
    close
    puts 'Successfully uploaded CSV'
  end
end
