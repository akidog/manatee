writeTagAttributes = (options) ->
  tag = ''
  if options['data']
    for key, value of options['data']
      options['data-' + key] = value
    options['data'] = undefined
  for key, value of options
    unless typeof value == 'undefined'
      if value == true
        tag += " " + key + "=" + '"' + key + '"'
      else
        value = if typeof options[key] == 'string'
          options[key].replace(/\'/g, '\\\'').replace(/\"/g, '\\"')
        else
          options[key]
        tag += " " + key + "=" + '"' + value + '"'
  tag

helper 'tag', (name, options = {}) ->
  options = H._clone options
  tag = "<" + name
  if arguments.length > 1
    tag += writeTagAttributes(options)
  tag + '/>'

helper 'contentTag', (name, content_or_options = '', options_or_content = '') ->
  [content, options] = if arguments.length == 1
    ['', {}]
  else if arguments.length == 2
    if content_or_options != null && typeof content_or_options == 'object'
      [ options_or_content || '', H._clone(content_or_options) ]
    else
      [ content_or_options || '', {} ]
  else
    if content_or_options != null && typeof content_or_options == 'object'
      [ options_or_content || '', H._clone(content_or_options) ]
    else
      [ content_or_options || '', H._clone(options_or_content) ]

  tag = "<" + name
  tag += writeTagAttributes(options)
  tag += '>'

  if typeof content == 'function'
    tag += content()
  else
    tag += content

  tag + '</' + name + '>'

helper 'CDATA', (content) ->
  if typeof content == 'function'
    content = content()
  "<![CDATA[" + content + "]]>"
