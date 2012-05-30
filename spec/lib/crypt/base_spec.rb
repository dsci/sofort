require "spec_helper"

describe Sofort::Encryptors::Base do
  
  let(:values_holder){double("values_holder", :sofort_string => "123abcefg")}

  it "encrypts a given string" do
    Sofort::Encryptors::Base.digest(values_holder).should_not be_empty
    expect{ Sofort::Encryptors::Base.digest(values_holder) }.to_not raise_error
  end

  context "validates a given digest string with a given resource" do
  
    it "passes if digest is assigned to resource" do
      result = Sofort::Encryptors::Base.digest(values_holder)
      Sofort::Encryptors::Base.valid?(result,values_holder).should be true
    end

    it "validation fails if digest is not assigned to resource" do
      Sofort::Encryptors::Base.valid?("bertram12",values_holder).should be false
    end
  end
end