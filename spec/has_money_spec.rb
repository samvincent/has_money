require 'active_record'
require File.expand_path(File.dirname(__FILE__) + '/../lib/has_money')

describe HasMoney do

  describe "including has money" do
    it "should extend the class with class methods when included" do
      klass = Class.new
      klass.send :include, HasMoney
      klass.should respond_to(:has_money)
    end
  end

  describe "working with money" do
    before(:each) do
      @klass = Class.new
      @klass.class_eval do
        include HasMoney
        attr_accessor :price
        has_money :price
      end
      @product = @klass.new
      @product.price = 2999
    end

    it "should create an accessor method named in_dollars for the attribute" do
      @product.should respond_to(:price_in_dollars)
    end

    it "should create a setter method named in_dollars for the attribute" do
      @product.should respond_to(:price_in_dollars=)
    end

    it "should return the amount in dollars" do
      @product.price_in_dollars.should == '29.99'
    end

    it "should return the amount in dollars correctly when negative" do
      @product.price = -4200
      @product.price_in_dollars.should == '-42.00'
    end

    it "should set the amount in dollars with a float" do
      @product.price_in_dollars = 39.99
      @product.price.should == 3999
    end

    it "should set the amount in dollars with a string with decimals" do
      @product.price_in_dollars = '39.99'
      @product.price.should == 3999
    end

    it "should set the amount in dollars with a string without decimals" do
      @product.price_in_dollars = '39'
      @product.price.should == 3900
    end

    it "should set the amount in dollars with a dollar sign" do
      @product.price_in_dollars = "$39.99"
      @product.price.should == 3999
    end

    it "should set the amount in dollars with commas" do
      @product.price_in_dollars = "2,500.99"
      @product.price.should == 250099
    end

    it "should set the amount in dollars if only cents with a period" do
      @product.price_in_dollars = ".59"
      @product.price.should == 59
    end

    it "should set the amount in dollars if it has leading and trailing spaces" do
      @product.price_in_dollars = " 0.59 "
      @product.price.should == 59
    end

    it "should round the amount up to the nearest cent" do
      @product.price_in_dollars = '39.998'
      @product.price.should == 4000
    end

    it "should round the amount down to the nearest cent" do
      @product.price_in_dollars = '39.992'
      @product.price.should == 3999
    end

    it "should assume zero cents if none given after decimal point" do
      @product.price_in_dollars = '39.'
      @product.price.should == 3900
    end

    it "should set nil if nil is passed as dollars" do
      @product.price_in_dollars = nil
      @product.price.should == nil
    end

    it "should set nil if an empty string is passed in as dollars" do
      @product.price_in_dollars = ''
      @product.price.should == nil
    end

    it "should set nil if a non numerical string is passed in as dollars" do
      @product.price_in_dollars = 'two dollars'
      @product.price.should == nil
    end

    it "should respect negative signs" do
      @product.price_in_dollars = '-$8.12'
      @product.price.should == -812
    end

    it "should return string formatted to two decimal places" do
      @product.price_in_dollars = '99'
      @product.price_in_dollars.should == '99.00'
    end

    it "should return nil if the attribute is nil" do
      @product.price = nil
      @product.price_in_dollars.should == nil
    end
  end

  describe "working with money where cents are not allowed" do
    before(:each) do
      @klass = Class.new
      @klass.class_eval do
        include HasMoney
        attr_accessor :price
        has_money :price
      end
      @product = @klass.new
      @product.price = 2999
    end

    it "should create an accessor method named in_dollars for the attribute" do
      @product.should respond_to(:price_in_dollars_without_cents)
    end

    it "should create a setter method named in_dollars for the attribute" do
      @product.should respond_to(:price_in_dollars_without_cents=)
    end

    it "should return the amount in dollars" do
      @product.price_in_dollars_without_cents.should == '30'
    end

    it "should return the amount in dollars correctly when negative" do
      @product.price = -4200
      @product.price_in_dollars_without_cents.should == '-42'
    end

    it "should set the amount in dollars with a float" do
      @product.price_in_dollars_without_cents = 39.99
      @product.price.should == 4000
    end

    it "should set the amount in dollars with a string with decimals" do
      @product.price_in_dollars_without_cents = '39.99'
      @product.price.should == 4000
    end

    it "should set the amount in dollars with a string without decimals" do
      @product.price_in_dollars_without_cents = '39'
      @product.price.should == 3900
    end

    it "should set the amount in dollars with a dollar sign" do
      @product.price_in_dollars_without_cents = "$39.99"
      @product.price.should == 4000
    end

    it "should set the amount in dollars with commas" do
      @product.price_in_dollars_without_cents = "2,500.99"
      @product.price.should == 250100
    end

    it "should set the amount in dollars if only cents with a period" do
      @product.price_in_dollars_without_cents = ".59"
      @product.price.should == 100
    end

    it "should set the amount in dollars if it has leading and trailing spaces" do
      @product.price_in_dollars_without_cents = " 0.59 "
      @product.price.should == 100
    end

    it "should round the amount up to the nearest dollar" do
      @product.price_in_dollars_without_cents = '39.998'
      @product.price.should == 4000
    end

    it "should round the amount down to the nearest dollar" do
      @product.price_in_dollars_without_cents = '39.499'
      @product.price.should == 3900
    end

    it "should assume zero cents if none given after decimal point" do
      @product.price_in_dollars_without_cents = '39.'
      @product.price.should == 3900
    end

    it "should set nil if nil is passed as dollars" do
      @product.price_in_dollars_without_cents = nil
      @product.price.should == nil
    end

    it "should set nil if an empty string is passed in as dollars" do
      @product.price_in_dollars_without_cents = ''
      @product.price.should == nil
    end

    it "should set nil if a non numerical string is passed in as dollars" do
      @product.price_in_dollars_without_cents = 'two dollars'
      @product.price.should == nil
    end

    it "should respect negative signs" do
      @product.price_in_dollars_without_cents = '-$8.12'
      @product.price.should == -800
    end

    it "should return string formatted without decimal places" do
      @product.price_in_dollars_without_cents = '99'
      @product.price_in_dollars_without_cents.should == '99'
    end

    it "should return nil if the attribute is nil" do
      @product.price = nil
      @product.price_in_dollars_without_cents.should == nil
    end
  end

end
