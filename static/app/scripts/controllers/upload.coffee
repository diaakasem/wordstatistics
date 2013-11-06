controller = ($scope, $http) ->
  $scope.options =
    # Upload url
    url: '/app/upload'

  $scope.loadingFiles = true
  $http.get('/app/upload').then (response)->
    $scope.loadingFiles = false
    $scope.queue = response.data.files or []

  , ->
    $scope.loadingFiles = false


angular.module('wordsApp')
  .controller 'UploadCtrl',
    ['$scope', '$http', '$filter', '$window', controller]
