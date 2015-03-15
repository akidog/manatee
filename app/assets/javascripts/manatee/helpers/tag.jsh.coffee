writeTagAttributes = (options) ->
  tag = ''
  if options['data']
    for key, value of options['data']
      options['data-' + key] = value
    options['data'] = undefined
  for key, value of options
    key = key.replace(/\_/g, '-')
    unless typeof value == 'undefined'
      if value == true
        tag += " " + key + "=" + '"' + key + '"'
      else
        value = if typeof value == 'string'
          value.replace(/\"/g, '&#34;').replace(/\'/g, '&#39;')
        else
          if value == null
            value = ''
          else
            value.toString()
        tag += " " + key + "=" + '"' + value + '"'
  tag

helper 'tag', (name, options = {}) ->
  options = @_clone options
  tag = "<" + name
  if arguments.length > 1
    tag += writeTagAttributes(options)
  tag + '/>'

helper 'contentTag', (name, content_or_options = '', options_or_content = '') ->
  [content, options] = if arguments.length == 1
    ['', {}]
  else if arguments.length == 2
    if content_or_options != null && typeof content_or_options == 'object'
      [ options_or_content || '', @_clone(content_or_options) ]
    else
      [ content_or_options || '', {} ]
  else
    if content_or_options != null && typeof content_or_options == 'object'
      [ options_or_content || '', @_clone(content_or_options) ]
    else
      [ content_or_options || '', @_clone(options_or_content) ]

  tag = "<" + name
  tag += writeTagAttributes(options)
  tag += '>'

  if typeof content == 'function'
    tag += content.call(this)
  else
    tag += content

  tag + '</' + name + '>'

helper 'CDATA', (content) ->
  if typeof content == 'function'
    content = content.call(this)
  "<![CDATA[" + content + "]]>"
