require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe YahooStock::Conversion do
  before :each do
    Timecop.return
  end
  
  describe "convert" do
    
  end
  
  describe "date" do
    describe "from MMM dd" do
      it "should convert dates to the closest date" do
        Timecop.freeze Date.parse("2011-09-01")
        YahooStock::Conversion.date("Jul  1").to_s.should == Date.parse("2011-7-1").to_s
        YahooStock::Conversion.date("Jan  1").to_s.should == Date.parse("2012-1-1").to_s
      end
    end

    describe "closest year for" do
      it "should return last year" do
        Timecop.freeze Date.parse("2011-06-01")
        YahooStock::Conversion.closest_year_for(12,30).should == 2010
      end

      it "should return this year" do
        Timecop.freeze Date.parse("2011-07-01")
        YahooStock::Conversion.closest_year_for(7,1).should == 2011
      end

      it "should return next year" do
        Timecop.freeze Date.parse("2011-08-01")
        YahooStock::Conversion.closest_year_for(1,1).should == 2012
      end

      it "should prefer leap years for Feb 29" do
        Timecop.freeze Date.parse("2011-06-01")
        YahooStock::Conversion.closest_year_for(2,29).should == 2012
      end
    end

    it "should convert dates from m/d/yy" do
      YahooStock::Conversion.date("1/2/03").should == Date.parse("2003-01-02")
    end

    it "should convert dates from m/d/yy from before 1970" do
      YahooStock::Conversion.date("2/4/68").should == Date.parse("1968-02-04")
    end

    it "should convert dates from dd-mon-yy" do
      YahooStock::Conversion.date("21-Nov-95").should == Date.parse("1995-11-21")
    end

    it "should convert dates with whitespace" do
      YahooStock::Conversion.date(" 9-Dec-10").should == Date.parse("2010-12-9")
    end

    it "should handle nil values" do
      YahooStock::Conversion.date(nil).should be(nil)
    end

    it "should handle empty strings" do
      YahooStock::Conversion.date("").should be(nil)
    end

    it "should handle N/A" do
      YahooStock::Conversion.date("N/A").should be(nil)
    end
  end
  
  describe "decimal" do
    it "should convert decimals" do
      YahooStock::Conversion.decimal("123.45").should == 123.45
    end
    
    it "should convert negative decimals" do
      YahooStock::Conversion.decimal("-123.45").should == -123.45
    end

    it "should handle nil values" do
      YahooStock::Conversion.decimal(nil).should be(nil)
    end

    it "should handle empty strings" do
      YahooStock::Conversion.decimal("").should be(nil)
    end

    it "should handle N/A" do
      YahooStock::Conversion.decimal("N/A").should be(nil)
    end
  end
  
  describe "integer" do
    it "should convert billions" do
      YahooStock::Conversion.integer("1.23B").should == 1_230_000_000
    end
    
    it "should convert millions" do
      YahooStock::Conversion.integer("1.23M").should == 1_230_000
    end
    
    it "should convert thousands" do
      YahooStock::Conversion.integer("1.23K").should == 1_230
    end
    
    it "should simply convert others to Fixnum" do
      YahooStock::Conversion.integer("12345").should == 12_345
    end
    
    it "should convert comma-delimited strings" do
      YahooStock::Conversion.integer("1,234").should == 1_234
    end

    it "should handle nil values" do
      YahooStock::Conversion.integer(nil).should be(nil)
    end

    it "should handle empty strings" do
      YahooStock::Conversion.integer("").should be(nil)
    end

    it "should handle N/A" do
      YahooStock::Conversion.integer("N/A").should be(nil)
    end
  end
  
end