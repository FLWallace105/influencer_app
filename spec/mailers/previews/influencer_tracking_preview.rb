# Preview all emails at http://localhost:3000/rails/mailers/influencer_tracking
class InfluencerTrackingPreview < ActionMailer::Preview
  def send_tracking_info
    tracking = InfluencerTracking.first
    InfluencerTrackingMailer.send_tracking_info(tracking)
  end
end
