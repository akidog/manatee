helper 'csrfMetaTags', () ->
  if H.csrfToken
    H.contentTag('meta', name: 'csrf-param', content: 'authenticity_token') + H.contentTag('meta', name: 'csrf-token', content: H.csrfToken)
  else
    ''
