sanitizeToId = (name) ->
  name.toString().replace(/\]/g, '').replace /[^-a-zA-Z0-9:.]/g, '_'

humanizeToLabel = (name) ->
  sanitized = name.toString().replace(/\]/g, '').replace /[^-a-zA-Z0-9:.]/g, ' '
  sanitized[0].toUpperCase() + sanitized.slice(1);

fieldTagBuilder = (_type) ->
  type = _type
  (name, value = null, options = {}) ->
    html_options            = H._clone options
    html_options['type']    = type
    html_options['name']    = name
    html_options['id']    ||= sanitizeToId(name)
    html_options['value'] ||= value if value
    H.tag 'input', html_options

for i, type of ['color', 'date', 'datetime', 'email', 'file', 'hidden', 'month', 'number', 'password', 'range', 'search', 'text', 'time', 'url', 'week']
  helper (type+'FieldTag'), fieldTagBuilder(type)

helper 'datetimeLocalFieldTag', fieldTagBuilder('datetime-local')
helper 'telephoneFieldTag',     fieldTagBuilder('tel')

alias  'phoneFieldTag', 'telephoneFieldTag'

helper 'buttonTag', (content_or_options = null, options_or_content = {}) ->
  [content, options] = H._content_or_options content_or_options, options_or_content

  content = content() if typeof content == 'function'
  options['name'] ||= 'button'
  options['type'] ||= 'submit'
  H.contentTag 'button', (content || 'Button'), options

helper 'checkBoxTag', (name, value = 1, checked = false, options = {}) ->
  html_options = H._clone options
  html_options['type']    = 'checkbox'
  html_options['name']    = name
  html_options['value']   = value
  html_options['checked'] = 'checked' if checked
  html_options['id']    ||= sanitizeToId name
  H.tag 'input', html_options
alias  'checkboxTag', 'checkBoxTag'

helper 'fieldSetTag', (legend = null, content_or_options = '', options_or_content = {}) ->
  [content, options] = if typeof legend == 'function'
    content_and_options = [ legend, {} ]
    legend = null
    content_and_options
  else
    H._content_or_options content_or_options, options_or_content

  content   = content()                                if typeof content == 'function'
  content   = H.contentTag('legend', legend) + content if legend && legend != ''
  H.contentTag 'fieldset', content, options

alias  'fieldsetTag', 'fieldSetTag'

# TODO: Handle CSRF Token & UTF-8 Enforcer
helper 'formTag', (url = '#', options = {}, content = '') ->
  form_options = {}
  if typeof options == 'function' || typeof options == 'string'
    content = options
  else
    form_options = H._clone options
  form_options['action']   = url
  form_options['method'] ||= 'post'
  if form_options['multipart']
    form_options['enctype']   = 'multipart/form-data'
    form_options['multipart'] = undefined
  if form_options['remote']
    form_options['remote']      = undefined
    form_options['data-remote'] = true
  H.contentTag 'form', content, form_options

helper 'imageSubmitTag', (source, options = {}) ->
  options           = H._clone options
  options['src']  ||= H.imagePath source
  options['type'] ||= 'image'
  options['alt']  ||= H.imageAlt source
  H.tag 'input', options

helper 'labelTag', (name, content_or_options = null, options_or_content = {}) ->
  [content, options] = if typeof name == 'function'
    content_and_options = [name, {}]
    name = null
    content_and_options
  else
    H._content_or_options content_or_options, options_or_content

  content        ||= humanizeToLabel name
  options['for'] ||= sanitizeToId(name) if name
  H.contentTag 'label', content, options

helper 'radioButtonTag', (name, value, checked = false, options = {}) ->
  options = H._clone options
  options['type']    = 'radio'
  options['name']    = name
  options['value']   = value
  options['checked'] = 'checked' if checked
  options['id']    ||= sanitizeToId(name) + '_' + sanitizeToId(value)
  H.tag 'input', options

helper 'selectTag', (name, option_tags = '', options = {}) ->
  options = H._clone options

  if options['include_blank']
    option_tags = H.contentTag('option', '', value: '') + option_tags
  options['include_blank'] = undefined

  if options['prompt']
    option_tags = H.contentTag('option', options['prompt'], value: '') + option_tags
  options['prompt'] = undefined

  html_name = if options['multiple']
    unless name.toString()[-2..-1] == '[]'
      name + '[]'
  else
    name

  options['id']   ||= sanitizeToId name
  options['name'] ||= name
  H.contentTag 'select', option_tags, options

helper 'submitTag', (value = "Save changes", options = {}) ->
  options = H._clone options
  options['type']  ||= 'submit'
  options['name']  ||= 'commit'
  options['value'] ||= value
  H.tag 'input', options

handleSizeAttribute = (options) ->
  if typeof options['size'] == 'string'
    size = options['size'].toLowerCase()
    if (/\d+X\d+/i).test(size)
      xIndex = size.lastIndexOf('x');
      options['cols'] ||= size.substring 0, xIndex
      options['rows'] ||= size.substring xIndex+1
  options['size'] = undefined

helper 'textAreaTag', (name, content_or_options = '', options_or_content = {}) ->
  [content, options] = H._content_or_options content_or_options, options_or_content
  handleSizeAttribute options

  content = content() if typeof content == 'function'
  content ||= ''

  if typeof options['escape'] == 'undefined' || options['escape']
    content = H.htmlEscape content
  options['escape'] = undefined

  options['id']   ||= sanitizeToId name
  options['name'] ||= name
  H.contentTag 'textarea', "\n"+content, options

alias 'textareaTag', 'textAreaTag'

helper 'UTF8EnforcerTag', () ->
  H.tag 'input', type: 'hidden', name: 'utf8', value: "&#x2713;"

# utf8_enforcer_tag
