require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Sofort do

  context "configuration" do

    it "setup block yields itself" do
      Sofort.setup do |config|
        config.should be Sofort
      end
    end

    context "default values" do

      it "encryptor is sha512" do
        Sofort.encryptor.should be :sha512
      end

      it "stretches length is 128" do
        Sofort.stretches.should be 128
      end

      it "not in prepaid mode" do
        Sofort.prepaid_mode.should be false
      end

      it "country equals default locales" do
        Sofort.country.should be :de
      end

      it "timeout is 120 seconds" do
        Sofort.timeout.should be 120
      end

      it "reason is empty" do
        Sofort.reason.should be_empty
      end

    end

    context "reason configured with Proc" do

      before do
        Sofort.setup do |config|
          config.reason = Proc.new {|resource| "#{resource.email}/#{resource.holder} sends some money today."}
        end
      end

      it "calls the proc if resource is given" do
        email = "master@universe.com"
        expected_reason = "#{email}/Hans Meiser sends some money today."
        Sofort.reason(User.new(:email => email)).should eq expected_reason 
      end

    end

    context "configuration with limitations" do

      context "currency" do

        context "no other currency as eur,chf, :pln or gbp are allowed" do
         
          it "not accepts us dollar" do
            expect{Sofort.currency=:dollar}.to raise_error Sofort::Errors::NotAllowedCurrencyError
          end
          
          [:eur,:chf,:pln,:gbp].each do |currency|
            it "accepts #{currency}" do
              expect{Sofort.currency=currency}.to_not raise_error Sofort::Errors::NotAllowedCurrencyError
            end
          end
        end

      end

      context "country" do
  
        context "no other country codes than de,ch and at are allowed" do

          it "not accepts usa" do
            expect{Sofort.country=:usa}.to raise_error Sofort::Errors::NotAllowedCountryError
          end

          [:ch,:at,:de].each do |code|
            it "accepts #{code}" do
              expect{Sofort.country=code}.to_not raise_error Sofort::Errors::NotAllowedCountryError
            end
          end

        end

      end

    end

  end

end