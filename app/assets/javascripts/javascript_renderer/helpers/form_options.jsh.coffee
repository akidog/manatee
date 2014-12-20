optionsNullSelector = (value) ->
  false

optionsStringSelectorBuilder = (_reference) ->
  reference = _reference
  (value) ->
    value.toString() && reference == value.toString()

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
  @contentTag 'option', @htmlEscape(value), @htmlEscapeAttributes(options)

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

collectionFetcherBlock = (_accessor_method) ->
  accessor_method = _accessor_method
  if typeof accessor_method == 'function'
    accessor_method
  else
    (object) ->
      object[accessor_method]

extractNamePrefixAndMethod = ((object, method_or_prefix_and_method) ->
  [ prefix, method ] = if typeof method_or_prefix_and_method == 'string'
    class_name = object['_class'] || object['_type'] || object['class'] || object['type']
    if class_name
      class_name = class_name() if typeof class_name == 'function'
      [ @underscore(class_name), method_or_prefix_and_method ]
    else
      [ null, method_or_prefix_and_method ]
  else
    method_or_prefix_and_method

  name = if prefix then prefix + '[' + method + ']' else method
  [ name, prefix, method ]).bind(this)

multipleHiddenInput = ((name, options) ->
  multiple_hidden_input = if options['multiple']
    name = name + '[]' if name[-2..-1] != '[]'
    if options['include_hidden'] == true || options['include_hidden'] == undefined
      @tag 'input', type: 'hidden', name: name, value: '', disabled: options['disabled']
    else
      ''
  else
    ''
  options['include_hidden'] = undefined
  [name, multiple_hidden_input]).bind(this)



helper 'optionsForSelect', (container, selectors) ->
  return container.toString()   if typeof container == 'string' || typeof value == 'number' || value == true || value == false
  return container().toString() if typeof container == 'function'

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
      select_options += stringOption.call(this, value, selected_selector, disabled_selector)
    if value instanceof Array
      [ content, value_option, options ] = if value.length == 3
        [ value[0], value[1], @_clone(value[2]) ]
      else if value.length == 2
        if typeof value[1] == 'object'
          [ value[0], value[0], @_clone(value[1]) ]
        else
          [ value[0], value[1], {} ]
      else
        [ value[0], value[0], {} ]

      content   = content.toString() if typeof content == 'number' || content == true || content == false
      content ||= ''

      value_option       = value_option.toString() if typeof value_option == 'number' || value_option == true || value_option == false
      options['value'] ||= value_option || content

      disabledAndSelector options, selected_selector, disabled_selector
      select_options += @contentTag 'option', @htmlEscape(content), @htmlEscapeAttributes(options)

  select_options

helper 'optionsFromCollectionForSelect', (collection, value_method, text_method, selectors) ->
  [ selected_selector, disabled_selector ] = selectorForOptionsFromCollection selectors, value_method
  selectors = { selected: [], disabled: [] }

  text_fetcher  = collectionFetcherBlock text_method
  value_fetcher = collectionFetcherBlock value_method

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

  @optionsForSelect container, selectors

helper 'groupedOptionsForSelect', (grouped_options, selectors, options = {}) ->
  [ selected_selector, disabled_selector ] = selectorForOptions selectors

  options_for_select = ''
  if options['prompt']
    prompt = if typeof options['prompt'] == 'string' || options['prompt'] == 'number'
      options['prompt'].toString()
    else
      @translate 'helpers.select.prompt', default: 'Please select'
    options_for_select += @contentTag( 'option', @htmlEscape(prompt), { value: '' } )

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

    options_for_select += @contentTag('optgroup', @optionsForSelect(options_in_group, selectors), @htmlEscapeAttributes(optgroup_options) )

  options_for_select

helper 'optionGroupsFromCollectionForSelect', (collection, group_method, group_label_method, option_key_method, option_value_method, selectors) ->
  group_fetcher       = collectionFetcherBlock group_method
  group_label_fetcher = collectionFetcherBlock group_label_method

  options_for_select = ''
  for index, object of collection
    options_for_select += @contentTag('optgroup', @optionsFromCollectionForSelect(group_fetcher(object), option_key_method, option_value_method, selectors), { label: @htmlEscape( group_label_fetcher object ) } )

  options_for_select

# EXPLAIN: When object is a Ruby object, two things can happen:
#          1. If it don't responds to method [], class if infered by .class method
#          2. If it responds to method [], class is infered by object['_class'] || object['_type'] || object['class'] || object['type'] in that order
#
# IMPORTANT: Removed 'index' and 'required' options, they seems too much cryptic to be used
helper 'selectForObject', (object, method_or_prefix_and_method, choices_or_options, options_or_choices) ->
  [ name, prefix, method ] = extractNamePrefixAndMethod object, method_or_prefix_and_method

  [ choices, options ] = if typeof options_or_choices == 'function'
    [ options_or_choices, @_clone( choices_or_options || {} ) ]
  else
    [ choices_or_options, @_clone( options_or_choices || {} ) ]

  [ name, multiple_hidden_input ] = multipleHiddenInput name, options

  pre_selector = selectorForOptions( object[method] )[0]
  selector = (value)->
    selected = pre_selector value
    # Welcome black magic!
    options['prompt'] = undefined if selected
    selected

  if typeof choices == 'object'
    unless choices instanceof Array
      array_choices = []
      for index, value of choices
        array_choices.push [ index, value ]
      choices = array_choices

    if choices[1] instanceof Array
      choices_options            = {}
      choices_options['divider'] = options['divider'] unless options['divider'] == undefined
      options['divider']         = undefined
      return multiple_hidden_input + @selectTag(name, @groupedOptionsForSelect(choices, selector, choices_options), options)

  multiple_hidden_input + @selectTag(name, @optionsForSelect(choices, selector), options)

# TODO: Finish form_options helpers
# collection_check_boxes
# collection_radio_buttons
# collection_select
# grouped_collection_select

# TODO: Think about implementing or not time zone helpers
# time_zone_options_for_select
# time_zone_select
