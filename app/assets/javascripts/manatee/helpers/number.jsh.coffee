# numberHelperBuilder = (_translation_key, _i18n_function) ->
#   i18n_function   = _i18n_function.bind I18n
#   translation_key = _translation_key
#   (number, options = {}) ->
#     return null if number == false || number == null || number == undefined
#     i18n_options = if options['locale']
#       translated_options = @_clone @translate( translation_key, locale: options['locale'] )
#       translated_options['negative_format'] = options['negative_format']
#       translated_options
#     else
#       @_clone options
#
#     result = if number < 0 && i18n_options['negative_format']
#       i18n_options['format'] = i18n_options['negative_format']
#       i18n_function(-number, i18n_options)
#     else
#       i18n_function(number, i18n_options)
#
#     if i18n_options['escape'] || i18n_options['escape'] == undefined
#       @htmlEscape result
#     else
#       result

numberHelperBuilder = (_translation_key, _i18n_function) ->
  i18n_function   = _i18n_function.bind I18n
  translation_key = _translation_key
  (number, options = {}) ->
    return null if number == false || number == null || number == undefined
    i18n_options = if options['locale']
      @_clone @translate( translation_key, locale: options['locale'] )
    else
      opts = @_clone options
      for key, value of @translate(translation_key)
        opts[key] = value if opts[key] == undefined
      opts

    result = if number < 0 && options['negative_format']
      i18n_options['format'] = options['negative_format']
      i18n_function(-number, i18n_options)
    else
      i18n_function(number, i18n_options)

    if options['escape'] || options['escape'] == undefined
      @htmlEscape result
    else
      result


helper 'numberToCurrency', numberHelperBuilder.call(this, 'number.currency.format', I18n.toCurrency )

# TODO: Add number helper tests and fix I18n-js gem
helper 'numberToHuman',      numberHelperBuilder.call(this, 'number.human.decimal_units', I18n.toNumber     )
helper 'numberToHumanSize',  numberHelperBuilder.call(this, 'number.human.storage_units', I18n.toHumanSize  )
helper 'numberToPercentage', numberHelperBuilder.call(this, 'number.percentage.format',   I18n.toPercentage )

# number_to_phone
# number_with_delimiter
# number_with_precision
