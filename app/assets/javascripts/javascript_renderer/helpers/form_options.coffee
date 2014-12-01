helper 'options_for_select', (container, selected = nil) ->
  select_options = ''
  for value, index of container
    if value instanceof Array
      if a.length == 3
        html_options = H._clone value[2]
        html_options['value'] = value[1]
        select_options += H.contentTag 'option', value[0], html_options
      else if a.length == 2
        # Check if last is a hash
        html_options = H._clone options
        select_options += H.contentTag 'option', value[0]
      else
        select_options += H.contentTag 'option', value
    else
      select_options += H.contentTag 'option', value
  select_options

# collection_check_boxes
# collection_radio_buttons
# collection_select
# grouped_collection_select
# grouped_options_for_select
# option_groups_from_collection_for_select
# options_from_collection_for_select
# select
# time_zone_options_for_select
# time_zone_select
