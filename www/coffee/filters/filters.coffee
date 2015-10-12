mod = angular.module "starter.controllers"
  
#todo: round option in filter https://www.npmjs.com/package/moment-round
mod.filter "formatTime", ($moment) ->
  filter = (seconds, format, trim) ->
  
    time = $moment.duration {seconds: seconds}
    return time.format format, { trim: trim } #false = full padded outputs
  
  return filter