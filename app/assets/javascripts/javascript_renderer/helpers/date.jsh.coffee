helper 'strftime', (date, pattern) ->
  I18n.strftime date, pattern

helper 'distanceOfTimeInWords', (from_time, to_time, withSeconds = false) ->
  distance_in_minutes = Math.abs((to_time - from_time) / 60000)
  [key, options] = switch
    when distance_in_minutes < 1
     if withSeconds
       distance_in_seconds = Math.abs((to_time - from_time) / 1000)
       switch
         when distance_in_seconds < 5  then [ 'less_than_x_seconds', { count: 5  } ]
         when distance_in_seconds < 10 then [ 'less_than_x_seconds', { count: 10 } ]
         when distance_in_seconds < 20 then [ 'less_than_x_seconds', { count: 20 } ]
         when distance_in_seconds < 40 then [ 'half_a_minute',       {           } ]
         when distance_in_seconds < 60 then [ 'less_than_x_minutes', { count: 1  } ]
         else ['x_minutes', { count: 1 }]
     else
       ['less_than_x_minutes', { count: 1 }]
    when distance_in_minutes < 45     then [ 'x_minutes',      { count: Math.floor(distance_in_minutes)           } ]
    when distance_in_minutes < 90     then [ 'about_x_hours',  { count: 1                                         } ]
    when distance_in_minutes < 1440   then [ 'about_x_hours',  { count: Math.floor(distance_in_minutes / 60.0)    } ]
    when distance_in_minutes < 2520   then [ 'x_days',         { count: 1                                         } ]
    when distance_in_minutes < 43200  then [ 'x_days',         { count: Math.floor(distance_in_minutes / 1440.0)  } ]
    when distance_in_minutes < 86400  then [ 'about_x_months', { count: Math.floor(distance_in_minutes / 43200.0) } ]
    when distance_in_minutes < 525600 then [ 'x_months',       { count: Math.floor(distance_in_minutes / 43200.0) } ]
    else
      remainder         = distance_in_minutes % 525600
      distance_in_years = Math.floor( distance_in_minutes / 525600 )
      if remainder < 131400
        ['about_x_years',  { count: distance_in_years     } ]
      else if remainder < 394200
        ['over_x_years',   { count: distance_in_years     } ]
      else
        ['almost_x_years', { count: distance_in_years + 1 } ]
  location_key = 'datetime.distance_in_words.' + key
  @translate location_key, options

helper 'distanceOfTimeInWordsToNow', (from_time, withSeconds = false) ->
  @distanceOfTimeInWords from_time, new Date(), withSeconds
alias 'timeAgoInWords', 'distanceOfTimeInWordsToNow'

# date_select
# datetime_select
# select_date
# select_datetime
# select_day
# select_hour
# select_minute
# select_month
# select_second
# select_time
# select_year
# time_select
# time_tag
