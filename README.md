# Telefonia BR

This gem does some tricks with [Brazilian Telephone Numbers](http://en.wikipedia.org/wiki/Telephone_numbers_in_Brazil). It validates telephone numbers based on its area code, bands of operation and the rules defined by [ANATEL](http://en.wikipedia.org/wiki/Brazilian_Agency_of_Telecommunications). The implementation of the ninth digit in Brazil has also been taken into account when developing this gem.

[API](https://github.com/gabrielhilal/telefonia_br_api) to illustrate its functionality: [http://telefonia-br.herokuapp.com?tel=(YY)XXXXXX](http://telefonia-br.herokuapp.com?tel=)

## Installation

Add this line to your application's Gemfile:

    gem "telefonia_br"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telefonia_br

## Usage

    require "telefonia_br"

    tel = TelBr.new("(YY)XXXXXXXX")  

    tel.stripped          # Return stripped telephone: YYXXXXXXXX
    tel.formatted         # Return formatted telephone: (YY) XXXX-XXXX

    tel.ddd               # Return the DDD: YY
    tel.state             # Return the state, such as "SP" for DDD 11 to 19
    tel.region            # Return the region, such as "São José dos Campos e Região." for DDD 12

    tel.number            # return the number: XXXXXXXX

    tel.valid?            # Check if a telephone number is valid
    tel.error             # Display the error if telephone number is invalid

## Error Messages

If a telephone number is invalid you might get one of the following messages:

    Invalid telephone
    Invalid DDD
    Invalid number
    Number should have 8 digits
    Number should have 9 digits

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-contribution`)
3. Commit your changes (`git commit -am "your message"`)
4. Push to the branch (`git push origin my-contribution`)
5. Create a new Pull Request