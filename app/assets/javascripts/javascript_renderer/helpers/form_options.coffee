optionsNullSelector = (value) ->
  false

optionsStringSelectorBuilder = (_reference) ->
  reference = _reference
  (value) ->
    value && reference == value.toString()

optionsArraySelectorBuilder = (_reference)->
  reference = []
  for index, ref_value of _reference
    reference.push ref_value.toString()
  (value) ->
    value && reference.indexOf(value.toString()) > -1

disabledAndSelector = (options, selected_selector, disabled_selector) ->
  options['selected'] = true if selected_selector(options['value'])
  options['disabled'] = true if disabled_selector(options['value'])

stringOption = (value, selected_selector, disabled_selector) ->
  options = { value: value }
  disabledAndSelector options, selected_selector, disabled_selector
  H.contentTag 'option', H.htmlEscape(value), H.htmlEscapeAttributes(options)

selectorForOptions = (reference) ->
  reference = reference.toString() if typeof reference == 'number' || reference == true || reference == false

  return [ optionsNullSelector,                     optionsNullSelector ] if reference == null || reference == undefined
  return [ optionsStringSelectorBuilder(reference), optionsNullSelector ] if typeof reference == 'string'
  return [ optionsArraySelectorBuilder(reference),  optionsNullSelector ] if reference instanceof Array

  [ selectorForOptions( reference['selected'] )[0], selectorForOptions( reference['disabled'] )[0] ]

helper 'optionsForSelect', (container, selectors) ->
  return container.toString() if typeof container == 'string' || typeof value == 'number' || value == true || value == false

  [ selected_selector, disabled_selector ] = selectorForOptions selectors

  unless container instanceof Array
    array_container = []
    for index, value of container
      array_container.push [ index, value ]
    container = array_container

  select_options = ''
  for index, value of container
    value = value.toString() if typeof value == 'number' || value == true || value == false
    value = '' if value == null

    if typeof value == 'string'
      select_options += stringOption(value, selected_selector, disabled_selector)
    if value instanceof Array
      [ content, value_option, options ] = if value.length == 3
        [ value[0], value[1], H._clone(value[2]) ]
      else if value.length == 2
        if typeof value[1] == 'object'
          [ value[0], value[0], H._clone(value[1]) ]
        else
          [ value[0], value[1], {} ]
      else
        [ value[0], value[0], {} ]

      content   = content.toString() if typeof content == 'number' || content == true || content == false
      content ||= ''

      value_option       = value_option.toString() if typeof value_option == 'number' || value_option == true || value_option == false
      options['value'] ||= value_option || content

      disabledAndSelector options, selected_selector, disabled_selector
      select_options += H.contentTag 'option', H.htmlEscape(content), H.htmlEscapeAttributes(options)

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
