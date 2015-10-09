categories = [
  {
    title: "Body Scan"
    id: "body-scan"
    description: "The body scan involves systematically <b>sweeping through the body with the mind</b>, bringing an affectionate, openhearted, interested attention to its various regions"
  }
  {
    title: "Mindfulness of Breathing"
    id: "mindfulness-of-breathing"
    description: "The ‘Mindfulness of Breathing’ uses the <b>breath as an object of concentration</b>. By focusing on the breath you become aware of the mind’s tendency to jump from one thing to another."
  }
  {
    title: "Metta Bhavana"
    id: "metta-bhavana"
    description: "Metta means ‘love’ (in a non-romantic sense), friendliness, or kindness: hence <b>‘loving-kindness’</b>. It is an emotion, something you feel in your heart. Bhavana means development or cultivation."
  }
]

meditations = [
  {
    title: "Body Scan"
    id: "body-scan-long-vidyamala"
    parentId: "body-scan"
    duration: 1978
  }
  {
    title: "Short Mindfulness of Breathing"
    id: "mindfulness-of-breathing-short-kamalashila"
    parentId: "mindfulness-of-breathing"
    duration: 1236
  }
  {
    title: "Long Mindfulness of Breathing"
    id: "mindfulness-of-breathing-long-jinananda"
    parentId: "mindfulness-of-breathing"
    duration: 2049
  }
  {
    title: "Short Metta Bhavana"
    id: "metta-bhavana-short-kamalashila"
    parentId: "metta-bhavana"
    duration: 1135
  }
  {
    title: "Long Metta Bhavana"
    id: "metta-bhavana-long-kamalashila"
    parentId: "metta-bhavana"
    duration: 2517
  }
]

getCategoryById = (categoryId) ->
  _.find(categories, (c) ->
    categoryId == c.id
  )
  
getMeditationById = (meditationId) ->
  _.find(meditations, (m) ->
    meditationId == m.id
  )

getMeditationsByCategory = (categoryId) ->
  _.filter meditations, (meditation) ->
    return categoryId == meditation.parentId

mod = angular.module("starter.controllers", ["angular-momentjs"])

#controllers
mod.controller "AppCtrl", ($scope) ->

mod.controller "CategoriesCtrl", ($scope) ->
  $scope.categories = categories

mod.controller "CategoryCtrl", ($scope, $stateParams, _) ->
  
  #get the title of the category
  $scope.pageTitle = getCategoryById($stateParams.categoryId).title
  
  #get meditations in the category
  $scope.meditations = getMeditationsByCategory $stateParams.categoryId

mod.controller "MeditationCtrl", ($scope, $stateParams, $ionicLoading) ->
  #get the title of the meditation
  meditationObject = getMeditationById($stateParams.meditationId)
  
  #get category description and stages
  categoryObject = getCategoryById(meditationObject.parentId)
  $scope.description = categoryObject.description
  $scope.stages = categoryObject.stages
  
  $scope.pageTitle = meditationObject.title
  #media defaults
  $scope.isPlaying = false
  $scope.duration = meditationObject.duration #media.getDuration() returns -1 even when media is ready!
  $scope.position = 0
  
  if ionic.Platform.isWebView()
    ionic.Platform.ready ->
  
      src = "resources/" + meditationObject.id + ".mp3"
      
      getMediaURL = (s) ->
        if ionic.Platform.isAndroid() then return "/android_asset/www/" + s
        else return s
      
      mediaError = (e) ->
        console.log "Media Error!"
        console.log JSON.stringify e
      
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
        if media
          media.stop()
          media.release()
      
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

mod.filter "formatTime", ($moment) ->
  filter = (seconds, format, trim) ->
  
    time = $moment.duration {seconds: seconds}
    return time.format format, { trim: trim } #false = full padded outputs
  
  return filter