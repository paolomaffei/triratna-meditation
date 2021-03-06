mod = angular.module "starter.controllers"

mod.controller "tmBellsOnlyMeditationController", ($scope, $stateParams, mmMeditationData) ->
  mediaTimer = null
  bell = null
  bellSrc = "resources/bell.mp3"
  
  meditationObject = mmMeditationData.getMeditationById($stateParams.meditationId)  
  categoryObject = mmMeditationData.getCategoryById(meditationObject.parentId)
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
  
  insomniaSucc = ->
    console.log 'insomnia success'
  insomniaError = (e) ->
    alert 'insomnia error', e
  
  #todo: do not allow play and pause until $scope.ready
  $scope.play = ->
    if $scope.position == 0
      if bell then bell.play()
    
    $scope.isPlaying = true
    mediaTimer = setInterval timerFunction, 1000
    window.plugins?.insomnia?.keepAwake insomniaSucc insomniaError
    
  $scope.pause = ->
    $scope.isPlaying = false
    clearInterval mediaTimer
    window.plugins?.insomnia?.allowSleepAgain insomniaSucc insomniaError
  
  timerFunction = ->    
    $scope.position++
    $scope.stagePosition++
    
    if $scope.stagePosition == $scope.stageDuration #stage ended
      if bell then bell.play()
      
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
    window.plugins?.insomnia?.allowSleepAgain insomniaSucc insomniaError
  
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
