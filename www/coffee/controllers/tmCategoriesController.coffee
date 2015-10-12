mod = angular.module "starter.controllers"

mod.controller "tmCategoriesController", ($scope, tmMeditationData) ->
  $scope.categories = tmMeditationData.getCategories()