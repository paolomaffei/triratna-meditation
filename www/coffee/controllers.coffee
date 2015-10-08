categories = [
  {
    title: "Body Scan"
    id: "body-scan"
  }
  {
    title: "Mindfulness of Breathing"
    id: "mindfulness-of-breathing"
  }
  {
    title: "Metta Bhavana"
    id: "metta-bhavana"
  }
]

meditations = [
  {
    title: "Body Scan by Vidyamala"
    id: "body-scan-long-vidyamala"
    parentId: "body-scan"
    duration: "32.58"
  }
  {
    title: "Short Mindfulness of Breathing"
    id: "mindfulness-of-breathing-short-kamalashila"
    parentId: "mindfulness-of-breathing"
    duration: "20.36"
  }
  {
    title: "Long Mindfulness of Breathing"
    id: "mindfulness-of-breathing-long-jinananda"
    parentId: "mindfulness-of-breathing"
    duration: "34.09"
  }
  {
    title: "Short Metta Bhavana"
    id: "metta-bhavana-short-kamalashila"
    parentId: "metta-bhavana"
    duration: "18.55"
  }
  {
    title: "Long Metta Bhavana"
    id: "metta-bhavana-long-kamalashila"
    parentId: "metta-bhavana"
    duration: "41.57"
  }
]

mod = angular.module("starter.controllers", ["angular-momentjs"])

#controllers
mod.controller "AppCtrl", ($scope) ->

mod.controller "CategoriesCtrl", ($scope) ->
  $scope.categories = categories

mod.controller "CategoryCtrl", ($scope, $stateParams, _) ->
  
  #get the title of the category
  $scope.pageTitle = _.find(categories, (c) ->
    $stateParams.categoryId == c.id
  ).title
  
  #get meditations in the category
  $scope.meditations = _.filter meditations, (meditation) ->
    return $stateParams.categoryId == meditation.parentId

mod.controller "MeditationCtrl", ($scope, $stateParams, $ionicLoading) ->
  #get the title of the meditation
  meditationObject = _.find(meditations, (m) ->
    $stateParams.meditationId == m.id
  )
  
  $scope.pageTitle = meditationObject.title
  
  if ionic.Platform.isWebView()
    ionic.Platform.ready ->
  
      src = "resources/" + meditationObject.id + ".mp3"
      
      getMediaURL = (s) ->
        if ionic.Platform.isAndroid() then return "/android_asset/www/" + s
        else return s
      
      mediaError = (e) ->
        alert('Media Error!');
        alert(JSON.stringify(e));
      
      changeMediaStatus = (s) ->        
        if s == Media.MEDIA_RUNNING
          $scope.isPlaying = true
        else
          $scope.isPlaying = false
        if s == Media.MEDIA_STARTING
          $ionicLoading.show {template: 'Loading...'}
        else
          $ionicLoading.hide()
        
        console.log "media status change", s, $scope.isPlaying, media.getDuration()
      
      $scope.play = ->
        media.play()
        
      $scope.pause = ->
        media.pause()
        
      media = new Media getMediaURL(src), null, mediaError, changeMediaStatus
      
      #clear up resources on leaving page
      $scope.$on "$ionicView.beforeLeave", ->
        console.log "$ionicView.beforeLeave"
        media.stop()
        media.release()
        
      #defaults
      $scope.isPlaying = false
      $scope.duration = meditationObject.duration #.getDuration() returns -1 even when media is ready!
      $scope.position = 0
      
      #getCurrentPosition timer
      successCb = (position) ->
        if position > -1
          $scope.position = parseInt(position)
          $scope.$apply()
      errorCb = (e) ->
        console.log "Error getting position", e
      
      intervalFunction = ->
        media.getCurrentPosition successCb, errorCb
      
      mediaTimer = setInterval intervalFunction, 500
      
  else
    console.log "running in web browser"

#filters
#alternatively use time.format "h [hour], m [minutes], s [seconds]":false
mod.filter "secondsToHoursMinutesAndSeconds", ->
  filter = (seconds) ->
    s = seconds%60
    m = parseInt(seconds/60)
    
    h = 0
    if m > 60
      h = parseInt(m/60)
      m - h*60
    
    if h
      if m > 0
        return h + " hour and " + m + " minutes"
      else
        return h + " hour"
    else
      if s > 0
        return m + " minutes and " + s + " seconds"
      else
        return m + " minutes"
  
  return filter

mod.filter "formatTime", ($moment) ->
  filter = (seconds, format, trim) ->
  
    time = $moment.duration {seconds: seconds}
    return time.format format, { trim: trim } #false = full padded outputs
  
  return filter