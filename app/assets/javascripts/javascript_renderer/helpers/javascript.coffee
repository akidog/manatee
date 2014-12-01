javascriptCDATA = (content) ->
  if typeof content == 'function'
    content = content()
  "\n//#{H.CDATA( "\n" + content + "\n//" )}\n"

helper 'javascriptTag', (content_or_options, options_or_content = {}) ->
  [content, options] = H._content_or_options content_or_options, options_or_content
  H.contentTag 'script', javascriptCDATA(content), options

helper 'escapeJavascript', (content) ->
  if content
    content.replace(/\\/g, '\\\\').replace(/<\//g, '<\\\/').replace(/\r\n/g, '\\n').replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\"/g, '\\"').replace(/\'/g, "\\'").replace(/\u2028/g, "&#x2028;").replace(/\u2029/g, "&#x2029;")
  else
    ''
alias 'j', 'escapeJavascript'
