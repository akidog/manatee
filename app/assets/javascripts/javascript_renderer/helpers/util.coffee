helper '_content_or_options', (content_or_options = null, options_or_content = {}) ->
  if options_or_content != null && typeof options_or_content == 'object'
    [ content_or_options, H._clone(options_or_content) ]
  else
    [ options_or_content, H._clone( content_or_options || {} ) ]

htmlEscapeMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;' }
escapeHTMLCallback = (key) ->
  htmlEscapeMap[key] || key;

helper 'htmlEscape', (string) ->
  string.replace(/[&<>]/g, escapeHTMLCallback);
