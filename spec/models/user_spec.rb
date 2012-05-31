require 'spec_helper'

describe User do

  subject{User}

  it{should respond_to(:find_by_sofort_token)}

  context "#find_by_sofort_token" do

    let(:user){User.new}

    before do
      user.build_sofort_token
      user.save!
      @token = user.sofort_token
    end

    it "finds user" do
      User.find_by_sofort_token(@token).id.should eq user.id
    end

  end

end