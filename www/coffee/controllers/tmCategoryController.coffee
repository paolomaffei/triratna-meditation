mod = angular.module "starter.controllers"

mod.controller "tmCategoryController", ($scope, $stateParams, _, mmMeditationData) ->
  
  $scope.pageTitle = mmMeditationData.getCategoryById($stateParams.categoryId).title
  $scope.meditations = mmMeditationData.getMeditationsByCategory $stateParams.categoryId
  
  $scope.getIconForMeditationType = (mt) ->
    if mt == "led"
      "icon ion-ios-volume-high"
    else
      "icon ion-ios-bell-outline"