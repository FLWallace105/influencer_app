class InfluencerTrackingMailer < ApplicationMailer
  def send_tracking_info(influencer_tracking)
    @influencer_tracking = influencer_tracking
    @influencer = @influencer_tracking.influencer

    mail to: @influencer.email, from: "Marika.com <no-reply@marika.com>", subject: "Your order has been shipped!"
    @influencer_tracking.email_sent_at = Time.current
    @influencer_tracking.save
  end
end
