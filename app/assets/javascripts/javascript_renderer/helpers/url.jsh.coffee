helper 'urlFor', (source, options = {}) ->
  if @forceDomain
    options['domain'] ||= H.domain.app
  if options['domain']
    source = options['domain'] + source
  if options['format']
    source += '.' + options['format']
  source

# button_to
# current_page?
# link_to
# link_to_if
# link_to_unless
# link_to_unless_current
# mail_to
