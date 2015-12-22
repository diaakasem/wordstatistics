// Generated by CoffeeScript 1.7.1
(function() {
  'use strict';
  var controller;

  controller = function(scope, ParseCrud, http, ngTableParams, Alert) {
    var DocumentUpload, Documents, Processes, onError, removeSuccess, saveSuccess;
    scope.text = '';
    scope.entity = {};
    scope.data = [];
    scope.selected = 'new';
    DocumentUpload = new ParseCrud('DocumentUpload');
    DocumentUpload.list(function(d) {
      return scope.uploads = d;
    });
    Documents = new ParseCrud('Documents');
    Documents.list(function(d) {
      scope.data = d;
      return scope.tableParams.reload();
    });
    Processes = new ParseCrud('Processes');
    scope.save = function() {
      return Documents.save(scope.entity, saveSuccess, onError);
    };
    removeSuccess = function(e) {
      return scope.$apply(function() {
        scope.data = _.filter(scope.data, function(d) {
          return d.id !== e.id;
        });
        scope.tableParams.reload();
        return Alert.success('Document was removed successfully.');
      });
    };
    scope.remove = function(e) {
      var q;
      q = Processes.query();
      q.equalTo("documents", e);
      return q.find({
        success: function(p) {
          if (p.length > 0) {
            return scope.$apply(function() {
              return Alert.error("This document is needed for process named " + (p[0].get('name')) + ". Please, remove that process first.");
            });
          } else {
            return Documents.remove(e, removeSuccess, onError);
          }
        },
        error: function(err) {
          return scope.errors.push(err);
        }
      });
    };
    scope.tableParams = new ngTableParams({
      page: 1,
      count: 10
    }, {
      total: function() {
        return scope.data.length;
      },
      getData: function($defer, params) {
        var end, start;
        start = (params.page() - 1) * params.count();
        end = params.page() * params.count();
        return $defer.resolve(scope.data.slice(start, end));
      }
    });
    saveSuccess = function(e) {
      return scope.$apply(function() {
        scope.data.push(e);
        scope.tableParams.reload();
        scope.selected = 'list';
        return Alert.success('Document was saved successfully.');
      });
    };
    return onError = function(e) {
      return scope.$apply(function() {
        console.log(e);
        return Alert.error('Error occured while saving changes');
      });
    };
  };

  angular.module('wordsApp').controller('UploadDocumentsCtrl', ['$scope', 'ParseCrud', '$http', 'ngTableParams', 'Alert', controller]);

}).call(this);
