optionsNullSelector = (value) ->
  false

optionsStringSelectorBuilder = (_reference) ->
  reference = H.htmlEscape _reference
  (value) ->
    value && reference == value.toString()

optionsArraySelectorBuilder = (_reference)->
  reference = []
  for index, ref_value of _reference
    reference.push H.htmlEscape( ref_value.toString() )
  (value) ->
    value && reference.indexOf(value.toString()) > -1

disabledAndSelector = (options, selected_selector, disabled_selector) ->
  options['selected'] = true if selected_selector(options['value'])
  options['disabled'] = true if disabled_selector(options['value'])

stringOption = (value, selected_selector, disabled_selector) ->
  content = H.htmlEscape value
  options = { value: content }
  disabledAndSelector options, selected_selector, disabled_selector
  H.contentTag 'option', content, options

selectorForOptions = (reference) ->
  reference = reference.toString() if typeof reference == 'number' || reference == true || reference == false

  return [ optionsNullSelector,                     optionsNullSelector ] if reference == null || reference == undefined
  return [ optionsStringSelectorBuilder(reference), optionsNullSelector ] if typeof reference == 'string'
  return [ optionsArraySelectorBuilder(reference),  optionsNullSelector ] if reference instanceof Array

  [ selectorForOptions( reference['selected'] )[0], selectorForOptions( reference['disabled'] )[0] ]

helper 'optionsForSelect', (container, selectors) ->
  return container if typeof container == 'string'

  [ selected_selector, disabled_selector ] = selectorForOptions selectors

  select_options = ''
  for index, value of container
    value = value.toString() if typeof value == 'number' || value == true || value == false
    if typeof value == 'string'
      select_options += stringOption(value, selected_selector, disabled_selector)
    if value instanceof Array
      if value.length == 3
        [ content, value_option, options ] = value
        options            = H._clone options
        options['value'] ||= H.htmlEscape( (value_option || content).toString() )
        disabledAndSelector options, selected_selector, disabled_selector
        select_options += H.contentTag 'option', content, options
      else if value.length == 2
        # Check if last is a hash
        html_options = H._clone options
        select_options += H.contentTag 'option', value[0]
      else
        select_options += stringOption(value, selected_selector, disabled_selector)

  select_options

# collection_check_boxes
# collection_radio_buttons
# collection_select
# grouped_collection_select
# grouped_options_for_select
# option_groups_from_collection_for_select
# options_from_collection_for_select
# select
# time_zone_options_for_select
# time_zone_select
