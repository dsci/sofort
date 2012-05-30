require "spec_helper"

describe ApplicationController, :type => :controller do
  
  controller do
    def index

    end
  end

  it "generates gateway url" do
    controller.sofort_gateway_url.should eq "https:://www.sofort-ueberweisung.de/payment/start"
  end
  
end