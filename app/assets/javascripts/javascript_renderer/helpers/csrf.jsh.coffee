helper 'csrfMetaTags', () ->
  if @csrfToken
    @contentTag('meta', name: 'csrf-param', content: 'authenticity_token') + @contentTag('meta', name: 'csrf-token', content: @csrfToken)
  else
    ''
