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
        tag += " " + key + "=" + '"' + options[key] + '"'
  tag

helper 'tag', (name, options = {}) ->
  options = H._clone options
  tag = "<" + name
  if arguments.length > 1
    tag += writeTagAttributes(options)
  tag + '/>'

helper 'contentTag', (name, content_or_options = '', options_or_content = {}) ->
  [content, options] = if typeof options_or_content == 'function'
    [ options_or_content, H._clone(content_or_options) ]
  else
    [ content_or_options, H._clone(options_or_content) ]

  tag = "<" + name
  if arguments.length > 2
    tag += writeTagAttributes(options)
  tag += '>'
  if arguments.length > 1
    if typeof content == 'function'
      tag += content()
    else
      tag += content
  tag + '</' + name + '>'

helper 'CDATA', (content) ->
  if typeof content == 'function'
    content = content()
  "<![CDATA[" + content + "]]>"
