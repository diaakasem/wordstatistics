module = angular.module('wordsApp', ['restangular', 'blueimp.fileupload'])

configs = ($routeProvider, fileUploadProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .when '/upload',
      templateUrl: 'views/upload.html',
      controller: 'UploadCtrl'
    .when '/files',
      templateUrl: 'views/files.html',
      controller: 'FilesCtrl'
    .when '/segments',
      templateUrl: 'views/segments.html',
      controller: 'SegmentsCtrl'
    .when '/words',
      templateUrl: 'views/words.html',
      controller: 'WordsCtrl'
    .otherwise
      redirectTo: '/'

      # Enable image resizing, except for Android and Opera,
      # which actually support image resizing, but fail to
      # send Blob objects via XHR requests:
      angular.extend fileUploadProvider.defaults,
        disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator.userAgent)
        maxFileSize: 5000000
        # Acceptable file extensions
        acceptFileTypes: /(\.|\/)(txt)$/i

      fileUploadProvider.defaults.redirect = '#/files'

module.config configs
