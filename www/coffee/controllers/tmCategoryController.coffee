mod = angular.module "starter.controllers"

mod.controller "tmCategoryController", ($scope, $stateParams, _, tmMeditationData) ->
  
  $scope.pageTitle = tmMeditationData.getCategoryById($stateParams.categoryId).title
  $scope.meditations = tmMeditationData.getMeditationsByCategory $stateParams.categoryId
  
  $scope.getIconForMeditationType = (mt) ->
    if mt == "led"
      "icon ion-ios-volume-high"
    else
      "icon ion-ios-bell-outline"