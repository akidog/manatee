# TODO: Think about digests
helper 'computeAssetPath', (source, options = {}) ->
  options['type'] ||= 'asset'

  if H.forceAssetDomain
    options['domain'] ||= H.domain[ options['type'] ]

  format = if options['format'] == undefined
    H.defaultFormat[ options['type'] ]
  else
    options['format']

  if format
    sharp_index = source.lastIndexOf '#'
    query_index = source.lastIndexOf '?'

    index = if sharp_index == -1
      query_index
    else
      if query_index == -1
        sharp_index
      else
        if query_index > sharp_index
          sharp_index
        else
          query_index

    if index == -1
      source += '.' + format unless source[(-format.length-1)..-1] == ('.' + format)
    else
      prefix = source.slice 0, index
      sufix  = source.slice index
      if prefix[(-format.length-1)..-1] == ('.' + format)
        source = prefix + sufix
      else
        source = prefix + '.' + format + sufix

  source = if source[0] == '/'
    source
  else
    prefix_path = H.defaultPath[options['type']]
    if prefix_path[prefix_path.length-1] == '/'
      prefix_path + source
    else
      prefix_path + '/' + source

  source = '/' + source if source[0] != '/'

  if options['domain']
    source = options['domain'] + source

  source

helper 'assetPath', (source, options = {}) ->
  source  = source.toString()
  options = H._clone options

  fullDoaminPath = /[\w\d]+\:\/\//i
  return source if fullDoaminPath.test(source) || source[0..1] == '//'

  H.computeAssetPath source, options

helper 'assetUrl', (source, options = {}) ->
  source  = source.toString()
  options = H._clone options

  options['domain'] ||= if options['type']
    H.domain[options['type']] || H.domain.asset
  else
    H.domain.asset

  H.assetPath source, options

assetPathBuilder = (_type) ->
  type_built = _type
  (source, options = {}) ->
    options = H._clone options
    options['type'] = type_built if options['type'] == undefined
    H.assetPath source, options

assetUrlBuilder = (_type) ->
  type_built = _type
  (source, options = {}) ->
    options = H._clone options
    options['type'] = type_built if options['type'] == undefined
    H.assetUrl source, options

for index, type of ['audio', 'font', 'image', 'video', 'javascript', 'stylesheet']
  helper (type+'Path'), assetPathBuilder(type)
  helper (type+'Url'),  assetUrlBuilder(type)

# helper 'audioPath', (source, options = {type: 'audio'}) ->
#   options['type'] ||= 'audio'
#   H.assetPath source, options
#
# helper 'audioUrl', (source, options = {type: 'audio'}) ->
#   options['type'] ||= 'audio'
#   H.assetUrl source, options
#
# helper 'fontPath', (source, options = {type: 'font'}) ->
#   options['type'] ||= 'font'
#   H.assetPath source, options
#
# helper 'fontUrl', (source, options = {type: 'font'}) ->
#   options['type'] ||= 'font'
#   H.assetUrl source, options
#
# helper 'imagePath', (source, options = {type: 'image'}) ->
#   options['type'] ||= 'image'
#   H.assetPath source, options
#
# helper 'imageUrl', (source, options = {type: 'image'}) ->
#   options['type'] ||= 'image'
#   H.assetUrl source, options
#
# helper 'videoPath', (source, options = {type: 'video'}) ->
#   options['type'] ||= 'video'
#   H.assetPath source, options
#
# helper 'videoUrl', (source, options = {type: 'video'}) ->
#   options['type'] ||= 'video'
#   H.assetUrl source, options
#
# helper 'javascriptPath', (source, options = {format: 'js', type: 'javascript'}) ->
#   options['format'] = 'js'         if options['format'] == undefined
#   options['type']   = 'javascript' if options['type']   == undefined
#   H.assetPath source, options
#
# helper 'javascriptUrl', (source, options = {type: 'javascript'}) ->
#   options['format'] = 'js'         if options['format'] == undefined
#   options['type']   = 'javascript' if options['type']   == undefined
#   H.assetUrl source, options
#
# helper 'stylesheetPath', (source, options = {format: 'css', type: 'stylesheet'}) ->
#   options['format'] = 'css'        if options['format'] == undefined
#   options['type']   = 'stylesheet' if options['type']   == undefined
#   H.assetPath source, options
#
# helper 'stylesheetUrl', (source, options = {type: 'stylesheet'}) ->
#   options['format'] = 'css'        if options['format'] == undefined
#   options['type']   = 'stylesheet' if options['type']   == undefined
#   H.assetUrl source, options
