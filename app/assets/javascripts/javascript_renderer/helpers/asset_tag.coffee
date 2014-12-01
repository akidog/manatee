helper 'audioTag', (paths...) ->
  options = paths[paths.length - 1]
  if typeof options == 'object'
    paths.pop()
  else
    options = {}
  path_options = {}
  path_options['format'] = options['format']
  options['format'] = undefined
  if paths.length == 1
    options['src'] = H.audioPath paths[0], path_options
    H.tag 'audio', options
  else
    content = ''
    source_options
    if options['source']
      source_options = options['source']
      options['source'] = undefined
    else
      source_options = {}
    for i, path of paths
      source_options['src'] = H.audioPath path, path_options
      content += H.tag 'source', source_options
    H.contentTag 'audio', content, options

helper 'autoDiscoveryLinkTag', (type = 'rss', url = H.domain(), options = {}) ->
  options = H._clone options
  options['href']   = H.assetUrl(url || H.domain())
  options['rel']  ||= 'alternate'
  unless options['type']
    if type == 'rss'
      options['type']    = 'application/rss+xml'
      options['title'] ||= 'RSS'
    if type == 'atom'
      options['type']    = 'application/atom+xml'
      options['title'] ||= 'ATOM'
  options['title'] ||= ''
  H.tag 'link', options

helper 'faviconLinkTag', (path = 'favicon.ico', options = {}) ->
  options['rel']  ||= 'shortcut icon'
  options['type'] ||= 'image/x-icon'
  options['href']   = path
  H.tag 'link', options

helper 'imageAlt', (source) ->
  basename = new String(source).substring(source.lastIndexOf('/') + 1);
  basename = basename.substring(0, basename.lastIndexOf(".")) if basename.lastIndexOf(".") != -1
  basename = basename[0..-34] if (/\-[0-9a-z]{32}/ig).test(basename[-33..-1])
  basename = basename.replace(/[-_\s]+/g, ' ')
  basename[0].toUpperCase() + basename.slice(1);

handleSizeAttribute = (options) ->
  if typeof options['size'] == 'string'
    size = options['size'].toLowerCase()
    options['size'] = undefined
    if (/\d+X\d+/i).test(size)
      xIndex = size.lastIndexOf('x');
      options['width']  ||= size.substring 0, xIndex
      options['height'] ||= size.substring xIndex+1
    if (new RegExp("\\d{" + size.length + "}")).test(size)
      options['width']  ||= size
      options['height'] ||= size

helper 'imageTag', (source, options = {}) ->
  options = H._clone options
  handleSizeAttribute options

  if source == '' || source[0..4] == 'data:'
    options['src'] = source
    options['alt'] = undefined if options['alt'] == null
  else
    options['src'] = H.imagePath source
    if options['alt'] == null
      options['alt'] = undefined
    else
      options['alt'] = H.imageAlt(source) if options['alt'] == undefined
  H.tag 'img', options

helper 'javascriptIncludeTag', (sources...) ->
  path_options = if typeof sources[sources.length-1] == 'object'
    sources.pop()
  else
    {}

  result = ''
  for index, source of sources
    options = { src: H.javascriptPath(source, path_options) }
    result += H.contentTag 'script', '', options
  result

helper 'stylesheetLinkTag', (sources...) ->
  path_options = {}
  options = if typeof sources[sources.length - 1] == 'object'
    opts = sources.pop()
    path_options['format'] = opts['format']
    path_options['type']   = opts['type']
    opts['format']         = undefined
    opts['type']           = undefined
    opts['rel']   ||= 'stylesheet'
    opts['media'] ||= 'screen'
    opts
  else
    { rel: 'stylesheet', media: 'screen' }

  result = ''
  for index, source of sources
    options['href'] = H.stylesheetPath source, path_options
    result += H.tag 'link', options
  result

helper 'videoTag', (paths...) ->
  options = if typeof paths[paths.length - 1] == 'object'
    H._clone paths.pop()
  else
    {}

  handleSizeAttribute options
  options['poster'] = H.imagePath(options['poster']) if options['poster']

  path_options = {}
  path_options['format'] = options['format']
  options['format'] = undefined
  if paths.length == 1
    options['src'] = H.videoPath paths[0], path_options
    H.tag 'video', options
  else
    content = ''
    source_options
    if options['source']
      source_options = options['source']
      options['source'] = undefined
    else
      source_options = {}
    for i, path of paths
      source_options['src'] = H.videoPath path, path_options
      content += H.tag 'source', source_options
    H.contentTag 'video', content, options
