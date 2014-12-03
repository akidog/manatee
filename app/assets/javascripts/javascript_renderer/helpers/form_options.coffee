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

  return [ reference,                               optionsNullSelector ] if typeof reference == 'function'
  return [ optionsNullSelector,                     optionsNullSelector ] if reference == null || reference == undefined
  return [ optionsStringSelectorBuilder(reference), optionsNullSelector ] if typeof reference == 'string'
  return [ optionsArraySelectorBuilder(reference),  optionsNullSelector ] if reference instanceof Array

  [ selectorForOptions( reference['selected'] )[0], selectorForOptions( reference['disabled'] )[0] ]

collectionValueForSelector = (_selector, value_method) ->
  selector = _selector
  (value) ->
    selector value[value_method]

selectorForOptionsFromCollection = (reference, _value_method) ->
  value_method = _value_method
  reference    = reference.toString() if typeof reference == 'number' || reference == true || reference == false

  return [ reference, optionsNullSelector           ] if typeof reference == 'function'
  return [ optionsNullSelector, optionsNullSelector ] if reference == null || reference == undefined
  return [ collectionValueForSelector(optionsStringSelectorBuilder(reference), value_method), optionsNullSelector ] if typeof reference == 'string'
  return [ collectionValueForSelector(optionsArraySelectorBuilder(reference), value_method),  optionsNullSelector ] if reference instanceof Array

  [ selectorForOptionsFromCollection( reference['selected'], _value_method )[0], selectorForOptionsFromCollection( reference['disabled'], _value_method )[0] ]






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

helper 'optionsFromCollectionForSelect', (collection, value_method, text_method, selectors) ->
  [ selected_selector, disabled_selector ] = selectorForOptionsFromCollection selectors, value_method
  selectors = { selected: [], disabled: [] }

  text_fetcher  = if typeof text_method  == 'function' then text_method  else ( (object) -> object[text_method]  )
  value_fetcher = if typeof value_method == 'function' then value_method else ( (object) -> object[value_method] )

  container = []
  for index, object of collection
    options = if object instanceof Array && object.length == 3
      object[2]
    else
      {}
    value = value_fetcher object
    container.push [ text_fetcher(object), value, options ]
    selectors['selected'].push(value) if selected_selector(object)
    selectors['disabled'].push(value) if disabled_selector(object)

  H.optionsForSelect container, selectors

helper 'groupedOptionsForSelect', (grouped_options, selectors, options = {}) ->
  [ selected_selector, disabled_selector ] = selectorForOptions selectors

  options_for_select = ''
  if options['prompt']
    prompt = if typeof options['prompt'] == 'string' || options['prompt'] == 'number'
      options['prompt'].toString()
    else
      H.translate 'helpers.select.prompt', default: 'Please select'
    options_for_select += H.contentTag( 'option', H.htmlEscape(prompt), { value: '' } )

  for index, options_in_group of grouped_options
    [ options_in_group, optgroup_options ] = if options['divider']
      if grouped_options instanceof Array
        [ options_in_group, { label: options['divider'] } ]
    else
      if grouped_options instanceof Array
        optgroup_options          = options_in_group[2] || {}
        optgroup_options['label'] = options_in_group[0]
        [ options_in_group[1], optgroup_options ]
      else
        [ options_in_group, { label: index } ]
    # if grouped_options instanceof Array
    #   optgroup_options          = options_in_group[2] || {}
    #   optgroup_options['label'] = options_in_group[0]
    #   options_for_select += H.contentTag('optgroup', H.optionsForSelect(options_in_group[1], selectors), optgroup_options )
    # else
    #   options_for_select += H.contentTag('optgroup', H.optionsForSelect(options_in_group, selectors), { label: index })

    options_for_select += H.contentTag('optgroup', H.optionsForSelect(options_in_group, selectors), optgroup_options )

  options_for_select

# collection_check_boxes
# collection_radio_buttons
# collection_select
# grouped_collection_select

# option_groups_from_collection_for_select

# select
# time_zone_options_for_select
# time_zone_select
