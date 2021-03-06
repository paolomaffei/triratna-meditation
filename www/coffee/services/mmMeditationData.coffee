mod = angular.module "starter.controllers"

mod.factory "mmMeditationData", ($q) ->
  
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
      id: "body-scan-bells-5min"
      parentId: "body-scan"
      duration: 300
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "body-scan-bells-10min"
      parentId: "body-scan"
      duration: 600
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "body-scan-bells-15min"
      parentId: "body-scan"
      duration: 900
      type: "bells-only"
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
      id: "mob-bells-5min"
      parentId: "mindfulness-of-breathing"
      duration: 300
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "mob-bells-10min"
      parentId: "mindfulness-of-breathing"
      duration: 600
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "mob-bells-15min"
      parentId: "mindfulness-of-breathing"
      duration: 900
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
      id: "mb-bells-5min"
      parentId: "metta-bhavana"
      duration: 300
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "mb-bells-10min"
      parentId: "metta-bhavana"
      duration: 600
      type: "bells-only"
    }
    {
      title: "Timer with bells"
      id: "mb-bells-15min"
      parentId: "metta-bhavana"
      duration: 900
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
  
  factory =

    getMediaURL: (fileID) ->
      defer = $q.defer()
      
      s = fileID + ".mp3"
      if ionic.Platform.isAndroid()
        defer.resolve "/android_asset/www/resources/tm-mp3s/" + s
      else
        defer.resolve "resources/tm-mp3s/" + s
      
      return defer.promise
      
    getCategories: ->
      categories
    
    getMeditations: ->
      meditations
    
    getCategoryById: (categoryId) ->
      _.find(categories, (c) ->
        categoryId == c.id
      )
      
    getMeditationById: (meditationId) ->
      _.find(meditations, (m) ->
        meditationId == m.id
      )
    
    getMeditationsByCategory: (categoryId) ->
      _.filter meditations, (meditation) ->
        return categoryId == meditation.parentId
    
  return factory
