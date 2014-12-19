sanitizeToId = (name) ->
  name = name.toString()
  name = name[0..-3] if name[-2..-1] == '[]'
  name.replace(/\]/g, '').replace /[^-a-zA-Z0-9:.]/g, '_'

humanizeToLabel = (name) ->
  sanitized = name.toString().replace(/\]/g, '').replace /[^-a-zA-Z0-9:.]/g, ' '
  sanitized[0].toUpperCase() + sanitized.slice(1);

fieldTagBuilder = (_type) ->
  type = _type
  (name, value = null, options = {}) ->
    html_options            = @_clone options
    html_options['type']    = type
    html_options['name']    = name
    html_options['id']      = sanitizeToId(name) if html_options['id'] == undefined
    html_options['value'] ||= value if value
    @tag 'input', html_options

for i, type of ['color', 'date', 'datetime', 'email', 'file', 'hidden', 'month', 'number', 'password', 'range', 'search', 'text', 'time', 'url', 'week']
  helper (type+'FieldTag'), fieldTagBuilder.call(this, type)

helper 'datetimeLocalFieldTag', fieldTagBuilder.call(this, 'datetime-local')
helper 'telephoneFieldTag',     fieldTagBuilder.call(this, 'tel')

alias  'phoneFieldTag', 'telephoneFieldTag'

helper 'buttonTag', (content_or_options = null, options_or_content = {}) ->
  [content, options] = @_contentOrOptions content_or_options, options_or_content

  content = content() if typeof content == 'function'
  options['name'] ||= 'button'
  options['type'] ||= 'submit'
  @contentTag 'button', (content || 'Button'), options

helper 'checkBoxTag', (name, value = 1, checked = false, options = {}) ->
  html_options = @_clone options
  html_options['type']    = 'checkbox'
  html_options['name']    = name
  html_options['value']   = value
  html_options['checked'] = 'checked' if checked
  html_options['id']      = sanitizeToId(name) if html_options['id'] == undefined
  @tag 'input', html_options
alias  'checkboxTag', 'checkBoxTag'

helper 'fieldSetTag', (legend = null, content_or_options = '', options_or_content = {}) ->
  [content, options] = if typeof legend == 'function'
    content_and_options = [ legend, {} ]
    legend = null
    content_and_options
  else
    @_contentOrOptions content_or_options, options_or_content, ''

  content = content()                                if typeof content == 'function'
  content = @contentTag('legend', legend) + content if legend && legend != ''
  @contentTag 'fieldset', content, options

alias  'fieldsetTag', 'fieldSetTag'

buildFormOptions = (url, options) ->
  method                      = (options['method'] || 'post').toLowerCase()
  options['action']           = url
  options['method']           = if method == 'get' then 'get' else 'post'
  options['accept-charset'] ||= 'UTF-8'

  if options['multipart']
    options['enctype']   = 'multipart/form-data'
    options['multipart'] = undefined

  options['data-remote'] = 'true' if options['remote']
  options['remote'] = undefined

  enforce_utf8 = options['enforce_utf8'] == undefined || options['enforce_utf8']
  options['enforce_utf8'] = undefined

  authenticity_token = if ( @_context.protectFromForgery && options['authenticity_token'] == undefined ) || options['authenticity_token']
    if options['authenticity_token'] == undefined || options['authenticity_token'] == true then @csrfToken else options['authenticity_token']
  else
    false
  options['authenticity_token'] = undefined

  [ method, enforce_utf8, authenticity_token ]

buildFormContent = (content, method, enforce_utf8, authenticity_token) ->
  form_content = ''

  method_enforcer = method != 'get' && method != 'post'
  form_content += '<div style="display:none">'
  if enforce_utf8 || authenticity_token || method_enforcer
    form_content += @utf8EnforcerTag()                        if enforce_utf8
    form_content += @methodHiddenTag(method)                  if method_enforcer
    form_content += @authenticityTokenTag(authenticity_token) if authenticity_token
  form_content += '</div>'

  content = content() if typeof content == 'function'

  form_content + content

# TODO: Think about CSRF Token on server side race conditions
helper 'formTag', (url = '/', content_or_options, options_or_content) ->
  [content, options] = if typeof url == 'function'
    content_and_options = [url, {}]
    url = '/'
    content_and_options
  else
    @_contentOrOptions content_or_options, options_or_content, ''

  [ method, enforce_utf8, authenticity_token ] = buildFormOptions.call this, url, options

  @contentTag 'form', buildFormContent.call(this, content, method, enforce_utf8, authenticity_token), options

helper 'imageSubmitTag', (source, options = {}) ->
  options           = @_clone options
  options['src']  ||= @imagePath source
  options['type'] ||= 'image'
  options['alt']  ||= @imageAlt source
  @tag 'input', options

helper 'labelTag', (name, content_or_options = null, options_or_content = {}) ->
  [content, options] = if typeof name == 'function'
    content_and_options = [name, {}]
    name = null
    content_and_options
  else
    @_contentOrOptions content_or_options, options_or_content

  content        ||= humanizeToLabel name
  options['for'] ||= sanitizeToId(name) if name
  @contentTag 'label', content, options

helper 'radioButtonTag', (name, value, checked = false, options = {}) ->
  options = @_clone options
  options['type']    = 'radio'
  options['name']    = name
  options['value']   = value
  options['checked'] = 'checked' if checked
  options['id']    ||= sanitizeToId(name) + '_' + sanitizeToId(value)
  @tag 'input', options

helper 'selectTag', (name, option_tags = '', options = {}) ->
  options = @_clone options

  if options['include_blank']
    blank_content = if options['include_blank'] == true then '' else @htmlEscape( options['include_blank'] )
    option_tags = @contentTag('option', blank_content, value: '') + option_tags
  options['include_blank'] = undefined

  if options['prompt']
    prompt_content = if options['prompt'] == true then @translate('helpers.select.prompt', default: 'Please select') else @htmlEscape( options['prompt'] )
    option_tags = @contentTag('option', prompt_content, value: '') + option_tags
  options['prompt'] = undefined

  html_name = if options['multiple']
    unless name.toString()[-2..-1] == '[]'
      name + '[]'
  else
    name

  options['multiple'] = undefined if options['multiple'] == false

  options['id']     = sanitizeToId(name) if options['id'] == undefined
  options['name'] ||= name
  @contentTag 'select', option_tags, options

helper 'submitTag', (value = "Save changes", options = {}) ->
  options = @_clone options
  options['type']  ||= 'submit'
  options['name']  ||= 'commit'
  options['value'] ||= value
  @tag 'input', options

handleSizeAttribute = (options) ->
  if typeof options['size'] == 'string'
    size = options['size'].toLowerCase()
    if (/\d+X\d+/i).test(size)
      xIndex = size.lastIndexOf('x');
      options['cols'] ||= size.substring 0, xIndex
      options['rows'] ||= size.substring xIndex+1
  options['size'] = undefined

helper 'textAreaTag', (name, content_or_options = '', options_or_content = {}) ->
  [content, options] = @_contentOrOptions content_or_options, options_or_content
  handleSizeAttribute options

  content = content() if typeof content == 'function'
  content ||= ''

  if typeof options['escape'] == 'undefined' || options['escape']
    content = @htmlEscape content
  options['escape'] = undefined

  options['id']     = sanitizeToId(name) if options['id'] == undefined
  options['name'] ||= name
  @contentTag 'textarea', "\n"+content, options

alias 'textareaTag', 'textAreaTag'

helper 'authenticityTokenTag', (authenticity_token) ->
  @tag 'input', type: 'hidden', name: @_context.requestForgeryProtectionToken, value: authenticity_token

helper 'methodHiddenTag', (method) ->
  @tag 'input', type: 'hidden', name: '_method', value: method

helper 'utf8EnforcerTag', () ->
  @tag 'input', type: 'hidden', name: 'utf8', value: "&#x2713;"
