require_relative '../test_helper'

class NumberTest < Manatee::ViewTest

  def test_number_to_currency
    assert_helper nil,                                     :numberToCurrency, nil
    assert_helper '$1,234,567,890.50',                     :numberToCurrency, 1234567890.50
    assert_helper '$1,234,567,892',                        :numberToCurrency, 1234567891.50, precision: 0
    assert_helper '1,234,567,890.50 - K&#269;',            :numberToCurrency, '-1234567890.50', unit: 'K&#269;', format: '%n %u', negative_format: '%n - %u', escape: false
    assert_helper '&amp;pound;1,234,567,890.50',           :numberToCurrency, '1234567890.50',  unit: '&pound;'
    assert_helper '&lt;b&gt;1,234,567,890.50&lt;/b&gt; $', :numberToCurrency, '1234567890.50',  format: '<b>%n</b> %u'
    assert_helper '&lt;b&gt;1,234,567,890.50&lt;/b&gt; $', :numberToCurrency, '-1234567890.50', negative_format: '<b>%n</b> %u'
    assert_helper '&lt;b&gt;1,234,567,890.50&lt;/b&gt; $', :numberToCurrency, '-1234567890.50', negative_format: '<b>%n</b> %u'
  end

  # def test_number_to_phone
  #   assert_helper nil,                                          :numberToPhone, nil
  #   assert_helper '555-1234',                                   :numberToPhone, 5551234
  #   assert_helper '(800) 555-1212 x 123',                       :numberToPhone, 8005551212, area_code: true, extension: 123
  #   assert_helper '+18005551212',                               :numberToPhone, 8005551212, delimiter: '', country_code: 1
  #   assert_helper '+&lt;script&gt;&lt;/script&gt;8005551212',   :numberToPhone, 8005551212, delimiter: '', country_code: '<script></script>'
  #   assert_helper '8005551212 x &lt;script&gt;&lt;/script&gt;', :numberToPhone, 8005551212, delimiter: '', extension: '<script></script>'
  # end

  # def test_number_to_percentage
  #   assert_helper nil,                            :numberToPercentage, nil
  #   assert_helper '100.000%',                     :numberToPercentage, 100
  #   assert_helper '100.000 %',                    :numberToPercentage, 100, format: '%n %'
  #   assert_helper '&lt;b&gt;100.000&lt;/b&gt; %', :numberToPercentage, 100, format: '<b>%n</b> %'
  #   assert_helper '<b>100.000</b> %',             :numberToPercentage, 100, format: raw('<b>%n</b> %')
  #   assert_helper '100%',                         :numberToPercentage, 100, precision: 0
  #   assert_helper '123.4%',                       :numberToPercentage, 123.400, precision: 3, strip_insignificant_zeros: true
  #   assert_helper '1.000,000%',                   :numberToPercentage, 1000, delimiter: '.', separator: ','
  #   assert_helper '98a%',                         :numberToPercentage, '98a'
  #   assert_helper 'NaN%',                         :numberToPercentage, Float::NAN
  #   assert_helper 'Inf%',                         :numberToPercentage, Float::INFINITY
  # end

  # def test_number_with_delimiter
  #   assert_helper nil,          :numberWithDelimiter, nil
  #   assert_helper '12,345,678', :numberWithDelimiter, 12345678
  #   assert_helper '0',          :numberWithDelimiter, 0
  # end

  # def test_number_with_precision
  #   assert_helper nil,        :numberWithPrecision, nil
  #   assert_helper '-111.235', :numberWithPrecision, -111.2346
  #   assert_helper '111.00',   :numberWithPrecision, 111, precision: 2
  #   assert_helper '0.00100',  :numberWithPrecision, 0.001, precision: 5
  #   assert_helper '3.33',     :numberWithPrecision, Rational(10, 3), precision: 2
  # end

  # def test_number_to_human_size
  #   assert_helper nil,       :numberToHumanSize, nil
  #   assert_helper '3 Bytes', :numberToHumanSize, 3.14159265
  #   assert_helper '1.2 MB',  :numberToHumanSize, 1234567, precision: 2
  # end

  # def test_number_to_human
  #   assert_helper nil,              :numberToHuman, nil
  #   assert_helper '0',              :numberToHuman, 0
  #   assert_helper '1.23 Thousand',  :numberToHuman, 1234
  #   assert_helper '489.0 Thousand', :numberToHuman, 489000, precision: 4, strip_insignificant_zeros: false
  # end

  # def test_number_to_human_escape_units
  #   volume = { unit: '<b>ml</b>', thousand: '<b>lt</b>', million: '<b>m3</b>', trillion: '<b>km3</b>', quadrillion: '<b>Pl</b>' }
  #   assert_helper '123 &lt;b&gt;lt&lt;/b&gt;',   :numberToHuman, 123456,                units: volume
  #   assert_helper '12 &lt;b&gt;ml&lt;/b&gt;',    :numberToHuman, 12,                    units: volume
  #   assert_helper '1.23 &lt;b&gt;m3&lt;/b&gt;',  :numberToHuman, 1234567,               units: volume
  #   assert_helper '1.23 &lt;b&gt;km3&lt;/b&gt;', :numberToHuman, 1_234_567_000_000,     units: volume
  #   assert_helper '1.23 &lt;b&gt;Pl&lt;/b&gt;',  :numberToHuman, 1_234_567_000_000_000, units: volume
  #
  #   #Including fractionals
  #   distance = { mili: '<b>mm</b>', centi: '<b>cm</b>', deci: '<b>dm</b>', unit: '<b>m</b>',
  #                ten: '<b>dam</b>', hundred: '<b>hm</b>', thousand: '<b>km</b>',
  #                micro: '<b>um</b>', nano: '<b>nm</b>', pico: '<b>pm</b>', femto: '<b>fm</b>'}
  #   assert_helper '1.23 &lt;b&gt;mm&lt;/b&gt;',  :numberToHuman, 0.00123,             units: distance
  #   assert_helper '1.23 &lt;b&gt;cm&lt;/b&gt;',  :numberToHuman, 0.0123,              units: distance
  #   assert_helper '1.23 &lt;b&gt;dm&lt;/b&gt;',  :numberToHuman, 0.123,               units: distance
  #   assert_helper '1.23 &lt;b&gt;m&lt;/b&gt;',   :numberToHuman, 1.23,                units: distance
  #   assert_helper '1.23 &lt;b&gt;dam&lt;/b&gt;', :numberToHuman, 12.3,                units: distance
  #   assert_helper '1.23 &lt;b&gt;hm&lt;/b&gt;',  :numberToHuman, 123,                 units: distance
  #   assert_helper '1.23 &lt;b&gt;km&lt;/b&gt;',  :numberToHuman, 1230,                units: distance
  #   assert_helper '1.23 &lt;b&gt;um&lt;/b&gt;',  :numberToHuman, 0.00000123,          units: distance
  #   assert_helper '1.23 &lt;b&gt;nm&lt;/b&gt;',  :numberToHuman, 0.00000000123,       units: distance
  #   assert_helper '1.23 &lt;b&gt;pm&lt;/b&gt;',  :numberToHuman, 0.00000000000123,    units: distance
  #   assert_helper '1.23 &lt;b&gt;fm&lt;/b&gt;',  :numberToHuman, 0.00000000000000123, units: distance
  # end

  # def test_number_helpers_escape_delimiter_and_separator
  #   assert_helper '111&lt;script&gt;&lt;/script&gt;111&lt;script&gt;&lt;/script&gt;1111', :numberToPhone, 1111111111, delimiter: '<script></script>'
  #
  #   assert_helper '$1&lt;script&gt;&lt;/script&gt;01',     :numberToCurrency, 1.01, separator: '<script></script>'
  #   assert_helper '$1&lt;script&gt;&lt;/script&gt;000.00', :numberToCurrency, 1000, delimiter: '<script></script>'
  #
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;010%',     :numberToPercentage, 1.01, separator: '<script></script>'
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;000.000%', :numberToPercentage, 1000, delimiter: '<script></script>'
  #
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;01',  :numberWithDelimiter, 1.01, separator: '<script></script>'
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;000', :numberWithDelimiter, 1000, delimiter: '<script></script>'
  #
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;010',     :numberWithDrecision, 1.01, separator: '<script></script>'
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;000.000', :numberWithDrecision, 1000, delimiter: '<script></script>'
  #
  #   assert_helper '9&lt;script&gt;&lt;/script&gt;86 KB', :numberToHuman_size, 10100, separator: '<script></script>'
  #
  #   assert_helper '1&lt;script&gt;&lt;/script&gt;01',                :numberToHuman, 1.01, separator: '<script></script>'
  #   assert_helper '100&lt;script&gt;&lt;/script&gt;000 Quadrillion', :numberToHuman, 10**20, delimiter: '<script></script>'
  # end
end
