require 'spec_helper'

describe TelBr do

  context "dealing with invalid strings" do 

    it "rejects blank strings" do
      expect(TelBr.new("")).not_to be_valid
    end

    it "rejects nil values" do
      expect(TelBr.new(nil)).not_to be_valid
    end

    it "rejects if greater than 11" do
      expect(TelBr.new('223456789012')).not_to be_valid
    end

    it "rejects if less than 10" do
      expect(TelBr.new('223456789')).not_to be_valid
    end

    it "returns the error massage" do
      expect(TelBr.new("").error).to include("Invalid telephone")
      expect(TelBr.new(nil).error).to include("Invalid telephone")
      expect(TelBr.new("223456789012").error).to include("Invalid telephone")
      expect(TelBr.new("223456789").error).to include("Invalid telephone")
    end

  end

  context "dealing with different telephone formats" do

    it "validates formatted telephones" do
      telephone = TelBr.new("(11)2234-5678")
      expect(telephone).to be_valid
      expect(telephone.ddd).to eq("11")
      expect(telephone.number).to eq("22345678")
    end

    it "validates unformatted telephones" do
      telephone = TelBr.new("1122345678")
      expect(telephone).to be_valid
      expect(telephone.ddd).to eq("11")
      expect(telephone.number).to eq("22345678")
    end

    it "validates messed telephones" do
      telephone = TelBr.new("(11)<br>+2234/n5678")
      expect(telephone).to be_valid
      expect(telephone.ddd).to eq("11")
      expect(telephone.number).to eq("22345678")
    end
    
  end

  context "public methods for a given telephone number" do

    let(:telephone_eight_digits) { TelBr.new("(11) 22345678") }
    let(:telephone_nine_digits) { TelBr.new("(11) 987345678") }

    it "returns the ddd" do
      expect(telephone_eight_digits.ddd).to eq("11")
      expect(telephone_nine_digits.ddd).to eq("11")
    end

    it "returns the state" do
      expect(telephone_eight_digits.state).to eq("SP")
      expect(telephone_nine_digits.state).to eq("SP")
    end

    it "returns the region" do
      expect(telephone_eight_digits.region).to eq("Região Metropolitana de São Paulo.")
      expect(telephone_nine_digits.region).to eq("Região Metropolitana de São Paulo.")
    end

    it "returns the number" do
      expect(telephone_eight_digits.number).to eq("22345678")
      expect(telephone_nine_digits.number).to eq("987345678")
    end

    it "returns the stripped telephone" do
      expect(telephone_eight_digits.stripped).to eq("1122345678")
      expect(telephone_nine_digits.stripped).to eq("11987345678")
    end

    it "returns the formated telephone" do
      expect(telephone_eight_digits.formatted).to eq("(11) 2234-5678")
      expect(telephone_nine_digits.formatted).to eq("(11) 98734-5678")
    end

  end

  context "identify the number type" do

    it "returns rural landline" do
      expect(TelBr.new("(51) 57105678").type).to eq("rural landline")
    end

    it "returns landline" do
      expect(TelBr.new("(11) 22345678").type).to eq("landline")
      expect(TelBr.new("(11) 32345678").type).to eq("landline")
      expect(TelBr.new("(11) 42345678").type).to eq("landline")
      expect(TelBr.new("(11) 52345678").type).to eq("landline")
    end

    it "returns mobile" do
      expect(TelBr.new("(11)982345678").type).to eq("mobile")
    end

    it "returns invalid" do
      expect(TelBr.new("(11) 111285678").type).to eq("invalid")
    end

  end

  context "validating ddds" do 

    context "invalid ddd" do
   
      let(:telephone) { TelBr.new("(01)22345678") }

      it "rejects invalid ddd" do
        expect(telephone).not_to be_valid
      end

      it "returns the error message" do
        expect(telephone.error).to include("Invalid DDD")
      end
    end

    context "valid ddd" do 
    
      let(:telephone) { TelBr.new("(11)22345678") }

      it "validates valid ddd" do
        expect(telephone).to be_valid
      end

      it "returns no error messages" do
        expect(telephone.error).to be_empty
      end

    end

  end

  context "validating numbers" do

    context "invalid number" do

      it "rejects invalid numbers" do
        telephone = TelBr.new("(11)12345678")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Invalid number")
      end

      it "rejects landline with 9 digits" do
        telephone = TelBr.new("(11)223456789")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Invalid number")
      end

      it "rejects rural landline with 9 digits" do
        telephone = TelBr.new("(51)957105678")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Number should have 8 digits")
      end

      it "rejects mobile with 9 digits where ddd does not require the ninety number" do
        telephone = TelBr.new("(51)983354321")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Number should have 8 digits")
      end

      it "rejects mobile with 8 digits where ddd requires the nineth digit" do
        telephone = TelBr.new("(11)87654321")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Number should have 9 digits")
      end

    end

    context "valid number" do 

      it "validates mobile with 9 digits where ddd requires the ninety number" do
        telephone = TelBr.new("11)982345678")
        expect(telephone).to be_valid
        expect(telephone.error).to be_empty
      end

      it "validates mobile with 8 digits where ddd does not require the ninety number" do
        telephone = TelBr.new("51)82345678")
        expect(telephone).to be_valid
        expect(telephone.error).to be_empty
      end

    end

    context "special cases" do

      it "rejects nextel SME with 9 digits when ddd between 21 and 28" do
        telephone = TelBr.new("(21)970111111")
        expect(telephone).not_to be_valid
        expect(telephone.error).to include("Number should have 8 digits")
      end

    end

  end

end