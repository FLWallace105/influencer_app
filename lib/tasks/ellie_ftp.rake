desc 'pulls order tracking from the ftp server and sends tracking info email to influencers'
task pull_order_tracking_and_send_tracking_email: :environment do
  EllieFTP.new.pull_order_tracking
end
