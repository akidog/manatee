helper 'truncate', (str, options = { length: 30 }) ->
  if str.length > options['length']
    "#{str[0..(options['length']-3)]}..."
  else
    str

# concat
# current_cycle
# cycle
# excerpt
# highlight
# pluralize
# reset_cycle
# safe_concat
# simple_format
# truncate
# word_wrap
