app = angular.module 'TriratnaMeditation', [
  'ionic'
  'starter.controllers'
  'underscore'
  'ngCordova'
]

app.run ($ionicPlatform) ->
  $ionicPlatform.ready ->

    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar true

    # org.apache.cordova.statusbar required
    StatusBar.styleDefault() if window.StatusBar

app.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state('app',
      url: '/app'
      abstract: true
      templateUrl: 'templates/menu.html'
      controller: 'tmAppController'
    )
    
    .state('app.about',
      url: '/about',
      views:
        menuContent:
          templateUrl: 'templates/about.html'
    )
    
    .state('app.categories',
      url: '/categories',
      views:
        menuContent:
          templateUrl: 'templates/categories.html'
          controller: 'tmCategoriesController'
    )

    .state('app.category',
      url: '/category/:categoryId'
      views:
        menuContent:
          templateUrl: 'templates/category.html'
          controller: 'tmCategoryController'
    )
    
     .state('app.ledmeditation',
      url: '/led-meditation/:meditationId'
      views:
        menuContent:
          templateUrl: 'templates/ledmeditation.html'
          controller: 'tmLedMeditationController'
    )
    
    .state('app.bellsonlymeditation',
      url: '/bells-only-meditation/:meditationId'
      views:
        menuContent:
          templateUrl: 'templates/bellsonlymeditation.html'
          controller: 'tmBellsOnlyMeditationController'
    )

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise '/app/categories'
