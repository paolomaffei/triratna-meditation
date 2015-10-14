mod = angular.module "starter.controllers"

mod.controller "tmCategoriesController", ($scope, mmMeditationData) ->
  $scope.categories = mmMeditationData.getCategories()