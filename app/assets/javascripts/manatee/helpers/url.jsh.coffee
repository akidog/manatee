helper 'urlFor', (source, options = {}) ->
  if @_context.forceDomain
    options['domain'] ||= @_context.domain.app
  if options['domain']
    source = options['domain'] + source
  if options['format']
    source += '.' + options['format']
  source

helper 'linkTo', (name, url, options = {}) ->
  options = @_clone options
  options['href'] ||= url
  if options['method']
    options['rel']         = 'nofollow'
    options['data-method'] = options['method']
  options['method'] = undefined
  if options['remote']
    options['data-remote'] = 'true'
  options['remote'] = undefined
  @contentTag 'a', name, options

helper 'linkToIf', (condition, name, url, options = {}) ->
  if condition then @linkTo(name, url, options) else ''

helper 'linkToUnless', (condition, name, url, options = {}) ->
  @linkToIf !condition, name, url, options

helper 'contentLinkTo', (url, options_or_content, content_or_options) ->
  [ content, options ] = @_contentOrOptions options_or_content, content_or_options
  @linkTo content, url, options


# button_to
# mail_to
# current_page?
# link_to_unless_current
