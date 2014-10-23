class TelBr
  require 'rules'
  attr_reader :telephone

  def initialize(telephone)
    @telephone = telephone.to_s
    validate_telephone
  end

  def valid?
    @error.empty? ? true : false
  end

  def error
    @error
  end

  def ddd
    stripped[0,2]
  end

  def state
    DDDS[ddd][:state]
  end

  def region
    DDDS[ddd][:region]
  end

  def number
    stripped[2,9]
  end

  def stripped
    @telephone.scan(/[0-9]/).join
  end

  def formatted
    number.size == 8 ? "(#{ddd}) #{number[0,4]}-#{number[4,4]}" : "(#{ddd}) #{number[0,5]}-#{number[5,4]}"
  end

  def type
    number_type
  end

  private

    def validate_telephone
      return @error = "Invalid telephone"              unless valid_string?
      return @error = "Invalid DDD"                    unless valid_ddd?
      return @error = "Invalid number"                 unless valid_number_type?
      return @error = "Number should have 8 digits"    if should_have_eight_digits?
      return @error = "Number should have 9 digits"    if should_have_nine_digits?
      return @error = ""
    end

    def valid_string?
      [10, 11].include?(stripped.size)
    end

    def valid_ddd?
      DDDS.keys.include?(ddd)
    end

    def valid_number_type?
      number_type != 'invalid'
    end

    def should_have_eight_digits?
      (!ddd_requires_nineth_digit? && number.size == 9) || (!is_mobile? && number.size == 9)
    end

    def should_have_nine_digits?
      ddd_requires_nineth_digit? && is_mobile? && number.size == 8
    end

    def is_mobile?
      type == 'mobile' ? true : false
    end

    def ddd_requires_nineth_digit?
      DDDS[ddd][:ninth_digit] && is_mobile?
    end

    def number_type
      return 'invalid' if number.nil? || (number.size == 9 && number[0].to_i != 9)
      number.size == 9 ? eight_digits = number[1,8] : eight_digits = number
      case
        # SPECIAL CASES
        when MOBILE_SME_FIRST_2_DIGITS[DDDS[ddd][:state]].include?(eight_digits[0,2].to_i)
          return 'mobile sme'
        when MOBILE_SPECIAL_CASES_FIRST_4_DIGITS[DDDS[ddd][:state]].include?(eight_digits[0,4].to_i)
          return 'mobile'
        when MOBILE_SPECIAL_CASES_FIRST_2_DIGITS[DDDS[ddd][:state]].include?(eight_digits[0,2].to_i)
          return 'mobile'

        # DEFAULT CASES
        when eight_digits[0,2].to_i == 57                 # 57            rural landline
          return 'rural landline'
        when (2..5).include?(eight_digits[0,1].to_i)      # 2 to 5        landline
          return 'landline'
        when MOBILE_BANDS[DDDS[ddd][:state]].include?(eight_digits[0,2].to_i)
          return 'mobile'
        else
          return 'invalid'
      end
    end
end