require 'bigdecimal'

module HasMoney
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
        
    def has_money(*attributes)
      attributes.each do |attribute|
        class_eval <<-EOS      
          def #{attribute}_in_dollars
            self.class.calculate_dollars_from_cents(#{attribute})
          end
      
          def #{attribute}_in_dollars=(dollars)
            self.#{attribute} = self.class.calculate_cents_from_dollars(dollars)
          end
        EOS
      end
    end
    
    def calculate_dollars_from_cents(cents)
      return nil if cents.nil? ||  cents == ''
      (BigDecimal(cents.to_s) / 100).to_f
    end

    def calculate_cents_from_dollars(dollars)
      return nil if dollars.nil? || dollars == ''
      dollars.gsub!(/[$,]/, "") if dollars.class == String
      (BigDecimal(dollars.to_s).round(2) * 100).to_i
    end
        
  end
end