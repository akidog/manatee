helper '_contentOrOptions', (content_or_options, options_or_content, default_content) ->
  if content_or_options != null && typeof content_or_options == 'object'
    [ options_or_content || default_content, H._clone(content_or_options) ]
  else
    [ content_or_options || default_content, H._clone( options_or_content || {} ) ]

htmlEscapeMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;' }
escapeHTMLCallback = (key) ->
  htmlEscapeMap[key] || key;

helper '_clone', (object) ->
  return object if object == null || typeof object != "object"
  cloned_object = object.constructor()
  for attr of object
    cloned_object[attr] = object[attr] if object.hasOwnProperty(attr)
  cloned_object

helper 'htmlEscape', (string) ->
  string.replace(/[&<>]/g, escapeHTMLCallback);
