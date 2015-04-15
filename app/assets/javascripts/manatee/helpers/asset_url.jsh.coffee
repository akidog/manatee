# TODO: Think about digests
helper 'computeAssetPath', (source, options = {}) ->
  options['type'] ||= 'asset'

  if @_context.forceAssetDomain
    options['domain'] ||= @_context.domain[ options['type'] ]

  format = if options['format'] == undefined
    @_context.defaultFormat[ options['type'] ]
  else
    options['format']

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
    prefix = source
    sufix  = ''
  else
    prefix = source.slice 0, index
    sufix  = source.slice index

  formated_path = if format
    if prefix[(-format.length-1)..-1] == ('.' + format)
      prefix
    else
      prefix + '.' + format
  else
    prefix

  source = if @_digest_map && @_digest_map[formated_path]
    @_digest_map[formated_path] + sufix
  else
    formated_path + sufix

  source = if source[0] == '/'
    source
  else
    prefix_path = @_context.defaultPath[options['type']]
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
  options = @_clone options

  fullDoaminPath = /[\w\d]+\:\/\//i
  return source if fullDoaminPath.test(source) || source[0..1] == '//'

  @computeAssetPath source, options

helper 'assetUrl', (source, options = {}) ->
  source  = source.toString()
  options = @_clone options

  options['domain'] ||= if options['type']
    @_context.domain[options['type']] || @_context.domain.asset
  else
    @_context.domain.asset

  @assetPath source, options

assetPathBuilder = (_type) ->
  type_built = _type
  (source, options = {}) ->
    options = @_clone options
    options['type'] = type_built if options['type'] == undefined
    @assetPath source, options

assetUrlBuilder = (_type) ->
  type_built = _type
  (source, options = {}) ->
    options = @_clone options
    options['type'] = type_built if options['type'] == undefined
    @assetUrl source, options

for index, type of ['audio', 'font', 'image', 'video', 'javascript', 'stylesheet']
  helper (type+'Path'), assetPathBuilder.call(this,type)
  helper (type+'Url'),  assetUrlBuilder.call(this,type)
