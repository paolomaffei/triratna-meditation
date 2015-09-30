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
    id: "body-scan1"
    parentId: "body-scan"
    duration: "33.22"
  }
  {
    title: "Body Scan by yyyy"
    id: "body-scan2"
    parentId: "body-scan"
    duration: "24.22"
  }
  {
    title: "Short Body Scan"
    id: "body-scan3"
    parentId: "body-scan"
    duration: "2.00"
  }
  {
    title: "Short Mindfulness of Breathing"
    id: "mob1"
    parentId: "mindfulness-of-breathing"
    duration: "20.00"
  }
]

mod = angular.module('starter.controllers', [])

mod.controller "AppCtrl", ($scope) ->

mod.controller "CategoriesCtrl", ($scope) ->
  $scope.categories = categories

mod.controller "CategoryCtrl", ($scope, $stateParams, _) ->
  
  #get the title of the category
  $scope.pageTitle = _.find(categories, (category) ->
    $stateParams.categoryId == category.id
  ).title
  
  #get meditations in the category
  $scope.meditations = _.filter meditations, (meditation) ->
    return $stateParams.categoryId == meditation.parentId

mod.controller "MeditationCtrl", ($scope, $stateParams) ->
