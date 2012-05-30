require "spec_helper"

describe "sofort/form.html.erb" do

  let(:resource){User.new(:account_number => 112233)}
  let(:amount){25}
  before :all do
    resource.build_sofort_credential
    assign(:resource, resource)    
    assign(:amount, amount)
  end 

  before do
    render
  end

  it "displays sofort hidden inputs in a form" do
    rendered.should include("https:://www.sofort-ueberweisung.de/payment/start")
  end

  context "required fields" do

    it "displays customer/user_id" do
      rendered.should =~ /name="user_id"/
      rendered.should =~ /value="#{Sofort.customer_id}"/
    end

    it "displays project_id" do
      rendered.should =~/name="project_id"/ 
      rendered.should =~/value="#{Sofort.project_id}"/
    end

    it "displays hash" do
      rendered.should =~ /name="hash"/
    end

    it "displays amount" do 
      rendered.should =~/name="amount"/
      rendered.should =~/value="#{amount}"/
    end

    context "which are marked as required by config" do

      it "displays sender account number" do
        rendered.should =~ /name="sender_account_number"/
        rendered.should =~ /value="#{resource.account_number}"/
      end

      it "displays holder name" do
        rendered.should =~/name="sender_holder"/
        rendered.should =~/value="#{resource.holder}"/
      end

    end

  end
end