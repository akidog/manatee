helper 'translate', (key, options) ->
  I18n.t key, options
alias 't', 'translate'

helper 'localize', (key, options) ->
  I18n.l key, options
alias 'l', 'localize'
