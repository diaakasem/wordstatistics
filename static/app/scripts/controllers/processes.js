// Generated by CoffeeScript 1.6.3
(function() {
  var controller;

  controller = function(scope, ParseCrud, ngTableParams, http, Alert) {
    var Documents, Processes, Uploads, WordsLists, onError, removeFile, saveSuccess;
    scope.data = [];
    scope.selected = 'new';
    scope.entity = {};
    scope.files = {};
    Documents = new ParseCrud('Documents');
    Documents.list(function(d) {
      return scope.documents = d;
    });
    WordsLists = new ParseCrud('WordsLists');
    WordsLists.list(function(d) {
      return scope.wordslists = d;
    });
    Processes = new ParseCrud('Processes');
    Processes.listWith(['wordslist', 'documents'], function(d) {
      scope.data = d;
      return scope.tableParams.reload();
    });
    Uploads = new ParseCrud('DocumentUpload');
    scope.save = function() {
      var doProcess;
      Processes.save(scope.entity, saveSuccess, onError);
      doProcess = _.after(2, function() {
        var h, params;
        scope.warn = 'Processing is in progress, please, be patient.';
        params = {
          method: 'POST',
          url: '/analyzefiles',
          data: scope.files
        };
        h = http(params);
        h.success(function(d) {
          return scope.$apply(function() {
            scope.entity.result = d.result;
            Processes.save(scope.entity, saveSuccess, onError);
            scope.tableParams.reload();
            return Alert.success('Processed successfully.');
          });
        });
        return h.error(function(e) {
          return scope.$apply(function() {
            return Alert.error(e);
          });
        });
      });
      scope.entity.documents.get('uploadedDocument').fetch({
        success: function(documentFile) {
          return scope.$apply(function() {
            scope.files.document = documentFile.get('uploadname');
            return doProcess();
          });
        }
      });
      return scope.entity.wordslist.get('uploadedDocument').fetch({
        success: function(wordsFile) {
          return scope.$apply(function() {
            scope.files.words = wordsFile.get('uploadname');
            return doProcess();
          });
        }
      });
    };
    scope.get = function(parseObj, attr) {
      if (attr == null) {
        attr = 'name';
      }
      return parseObj.fetch({
        success: function(obj) {
          return obj.get(attr);
        }
      });
    };
    saveSuccess = function(e) {
      scope.data.push(e);
      scope.tableParams.reload();
      return scope.selected = 'list';
    };
    onError = function() {
      debugger;
    };
    removeFile = function(name) {
      var h, params;
      params = {
        method: 'POST',
        url: '/remove',
        data: {
          filename: name
        }
      };
      h = http(params);
      h.success(function(d) {
        return scope.$apply(function() {
          Alert.success('Removed successfully.');
          return scope.tableParams.reload();
        });
      });
      return h.error(function(e) {
        return scope.$apply(function() {
          return Alert.error(e);
        });
      });
    };
    scope.remove = function(entity) {
      return entity.destroy({
        success: function() {
          return scope.$apply(function() {
            Alert.success('Removed successfully.');
            scope.data = _.filter(scope.data, function(d) {
              return d.id !== entity.id;
            });
            return scope.tableParams.reload();
          });
        },
        error: function(e) {
          console.log(e);
          return scope.$apply(function() {
            return Alert.error('Error occurred while removing.');
          });
        }
      });
    };
    return scope.tableParams = new ngTableParams({
      page: 1,
      count: 10
    }, {
      total: function() {
        return scope.data.length;
      },
      getData: function($defer, params) {
        return $defer.resolve(scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count()));
      }
    });
  };

  angular.module('wordsApp').controller('ProcessesCtrl', ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', controller]);

}).call(this);

/*
//@ sourceMappingURL=processes.map
*/
