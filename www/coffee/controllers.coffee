categories = [
  {
    title: "Body Scan"
    id: "body-scan"
    icon: "ion-ios-body-outline" #ion-ios-body
    stages: 1
    description: "The body scan involves systematically <b>sweeping through the body with the mind</b>, bringing an affectionate, openhearted, interested attention to its various regions"
  }
  {
    title: "Mindfulness of Breathing"
    id: "mindfulness-of-breathing"
    icon: "ion-ios-loop" #ion-ios-bell, ion-ios-person-outline
    stages: 4
    description: "The ‘Mindfulness of Breathing’ uses the <b>breath as an object of concentration</b>. By focusing on the breath you become aware of the mind’s tendency to jump from one thing to another."
  }
  {
    title: "Metta Bhavana"
    id: "metta-bhavana"
    icon: "ion-ios-heart-outline" #ion-heart
    stages: 5
    description: "Metta means ‘love’ (in a non-romantic sense), friendliness, or kindness: hence <b>‘loving-kindness’</b>. It is an emotion, something you feel in your heart. Bhavana means development or cultivation."
  }
]

meditations = [
  {
    title: "Audio instructions"
    id: "body-scan-long-vidyamala"
    parentId: "body-scan"
    duration: 1978
    type: "led"
  }
  {
    title: "Audio instructions"
    id: "mindfulness-of-breathing-short-kamalashila"
    parentId: "mindfulness-of-breathing"
    duration: 1236
    type: "led"
  }
  {
    title: "Audio instructions"
    id: "mindfulness-of-breathing-long-jinananda"
    parentId: "mindfulness-of-breathing"
    duration: 2049
    type: "led"
  }
  {
    title: "Audio instructions"
    id: "metta-bhavana-short-kamalashila"
    parentId: "metta-bhavana"
    duration: 1135
    type: "led"
  }
  {
    title: "Audio instructions"
    id: "metta-bhavana-long-kamalashila"
    parentId: "metta-bhavana"
    duration: 2517
    type: "led"
  }
  {
    title: "Timer with bells"
    id: "body-scan-bells-20min"
    parentId: "body-scan"
    duration: 1200
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "body-scan-bells-30min"
    parentId: "body-scan"
    duration: 1800
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "body-scan-bells-40min"
    parentId: "body-scan"
    duration: 2400
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mob-bells-20min"
    parentId: "mindfulness-of-breathing"
    duration: 1200
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mob-bells-30min"
    parentId: "mindfulness-of-breathing"
    duration: 1800
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mob-bells-40min"
    parentId: "mindfulness-of-breathing"
    duration: 2400
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mb-bells-20min"
    parentId: "metta-bhavana"
    duration: 1200
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mb-bells-30min"
    parentId: "metta-bhavana"
    duration: 1800
    type: "bells-only"
  }
  {
    title: "Timer with bells"
    id: "mb-bells-40min"
    parentId: "metta-bhavana"
    duration: 2400
    type: "bells-only"
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
  
  $scope.pageTitle = getCategoryById($stateParams.categoryId).title
  $scope.meditations = getMeditationsByCategory $stateParams.categoryId
  
  $scope.getIconForMeditationType = (mt) ->
    if mt == "led"
      "icon ion-ios-volume-high"
    else
      "icon ion-ios-bell-outline"

mod.controller "LedMeditationCtrl", ($scope, $stateParams, $ionicLoading) ->
  media = null
  mediaTimer = null
  
  meditationObject = getMeditationById($stateParams.meditationId)  
  categoryObject = getCategoryById(meditationObject.parentId)
  $scope.pageTitle = meditationObject.title
  $scope.categoryTitle = categoryObject.title
  
  audioSrc = "resources/" + meditationObject.id + ".mp3"
  $scope.description = categoryObject.description
  
  #media defaults
  $scope.isPlaying = false
  $scope.duration = meditationObject.duration #media.getDuration() returns -1 even when media is ready!
  $scope.position = 0
  
  $scope.play = ->
    media.play() if media
  $scope.pause = ->
    media.pause() if media
  
  #clear up resources on leaving page
  $scope.$on "$ionicView.beforeLeave", ->
    console.log "$ionicView.beforeLeave"
    if media
      media.stop()
      media.release()
    clearInterval mediaTimer if mediaTimer
  
  if ionic.Platform.isWebView()
    ionic.Platform.ready ->
      
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
      
      media = new Media getMediaURL(audioSrc), null, mediaError, changeMediaStatus
      
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
    #todo: brower html5 audio version

mod.controller "BellsOnlyMeditationCtrl", ($scope, $stateParams) ->
  mediaTimer = null
  bell = null
  bellSrc = "resources/bell.mp3"
  
  meditationObject = getMeditationById($stateParams.meditationId)  
  categoryObject = getCategoryById(meditationObject.parentId)
  $scope.pageTitle = meditationObject.title
  $scope.categoryTitle = categoryObject.title
  $scope.stages = categoryObject.stages
  $scope.currentStage = 1
  
  #timer defaults
  $scope.isPlaying = false
  $scope.position = 0
  $scope.stagePosition = 0
  $scope.duration = meditationObject.duration #media.getDuration() returns -1 even when media is ready!
  $scope.stageDuration = $scope.duration / $scope.stages
  
  #todo: do not allow play and pause until $scope.ready
  $scope.play = ->
    if $scope.position == 0
      if bell then bell.play() else console.log "bell.play" #debug only
    
    $scope.isPlaying = true
    mediaTimer = setInterval timerFunction, 1000
    
  $scope.pause = ->
    $scope.isPlaying = false
    clearInterval mediaTimer
  
  timerFunction = ->    
    $scope.position++
    $scope.stagePosition++
    
    if $scope.stagePosition == $scope.stageDuration #stage ended
      if bell then bell.play() else console.log "bell.play" #debug only
      
      if $scope.currentStage == $scope.stages #meditation ended
        $scope.position = $scope.stagePosition = 0
        $scope.currentStage = 1
        $scope.pause()
      else
        $scope.currentStage++
      
      #new stage
      $scope.stagePosition = 0
    
    $scope.$apply()
      
  #clear up resources on leaving page
  $scope.$on "$ionicView.beforeLeave", ->
    console.log "$ionicView.beforeLeave"
    clearInterval mediaTimer
    if bell
      bell.stop()
      bell.release()
  
  if ionic.Platform.isWebView()
    ionic.Platform.ready ->
      
      getMediaURL = (s) ->
        if ionic.Platform.isAndroid() then return "/android_asset/www/" + s
        else return s
      
      mediaError = (e) ->
        console.log "Media Error!"
        console.log JSON.stringify e
      
      bell = new Media getMediaURL(bellSrc), null, mediaError, null
      
      $scope.mediaReady = true
      
  
#todo: round option in filter https://www.npmjs.com/package/moment-round
mod.filter "formatTime", ($moment) ->
  filter = (seconds, format, trim) ->
  
    time = $moment.duration {seconds: seconds}
    return time.format format, { trim: trim } #false = full padded outputs
  
  return filter