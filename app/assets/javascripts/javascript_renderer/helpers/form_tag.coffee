sanitizeToId = (name) ->
  name.replace(/\]/g, '').replace /[^-a-zA-Z0-9:.]/g, '_'

fieldTagBuilder = (_type) ->
  type = _type
  (name, value = null, options = {}) ->
    html_options         = H._clone options
    html_options['type']  = type
    html_options['name']  = name
    html_options['id']  ||= sanitizeToId(name)
    html_options['value'] = name if value
    H.tag 'input', html_options

for i, type of ['color', 'date', 'datetime', 'email', 'file', 'hidden', 'month', 'number', 'password', 'range', 'search', 'text', 'telephone', 'time', 'url', 'week']
  helper (type+'FieldTag'), fieldTagBuilder(type)

helper 'datetimeLocalFieldTag', fieldTagBuilder('datetime-local')
helper 'telephoneFieldTag', fieldTagBuilder('tel')
alias 'phone', 'telephone'

helper 'buttonTag', (content_or_options = null, options_or_content = {}) ->
  [content, options] = if typeof options_or_content == 'function'
    [ options_or_content, content_or_options ]
  else
    [ content_or_options, options_or_content ]

  if typeof content == 'object'
    options = H._clone content
    content = null
  else
    if options
      options = H._clone options
    else
      options = {}

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

helper 'fieldSetTag', (legend = null, content_or_options, options_or_content) ->
  [content, options] = if typeof options_or_content == 'function'
    [ options_or_content, content_or_options ]
  else
    [ content_or_options, options_or_content ]
  content = content() if typeof content == 'function'
  if legend
    content = H.contentTag('legend', legend) + content
  H.contentTag 'fieldset', content, options

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
  form_options = H._clone options
  html_options['type'] ||= 'image'
  html_options['alt']  ||= H.imageAlt source
  H.tag 'input', html_options

helper 'labelTag', (name, content_or_options = '', options_or_content = {}) ->
  [content, options] = if typeof options_or_content == 'function'
    [ options_or_content, H._clone content_or_options ]
  else
    [ content_or_options, H._clone options_or_content ]
  options['for'] ||= name
  H.contentTag 'label', content, options

helper 'radioButtonTag', (name, value, checked = false, options = {}) ->
  html_options = H._clone options
  html_options['type']    = 'radio'
  html_options['name']    = name
  html_options['value']   = value
  html_options['checked'] = 'checked' if checked
  html_options['id']    ||= sanitizeToId name
  H.tag 'input', html_options

helper 'selectTag', (name, content_or_options = '', options_or_content = {}) ->
  [content, options] = if typeof options_or_content == 'function'
    [ options_or_content, H._clone content_or_options ]
  else
    [ content_or_options, H._clone options_or_content ]

  options['name']  = name
  options['id']  ||= sanitizeToId(name)
  H.contentTag 'select', content, options

# select_tag
# submit_tag
# text_area_tag
# utf8_enforcer_tag
