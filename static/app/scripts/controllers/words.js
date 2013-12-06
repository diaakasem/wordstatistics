// Generated by CoffeeScript 1.6.3
(function() {
  var controller;

  if (!String.prototype.trim) {
    String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/gm, '');
    };
  }

  controller = function(scope, Service, http, timeout) {
    var success;
    scope.model = {
      words: [],
      text: ''
    };
    scope.success = '';
    scope.error = '';
    scope.word = '';
    scope.addWord = function() {
      if (scope.word && scope.word.trim()) {
        scope.model.words.push(scope.word);
        scope.model.words = _.uniq(scope.model.words);
        return scope.word = '';
      }
    };
    scope.removeWord = function(word) {
      return scope.model.words = _.filter(scope.model.words, function(w) {
        return w !== word;
      });
    };
    success = function(res) {
      return scope.$apply(function() {
        scope.success = 'Document was saved successfully';
        scope.error = '';
        return timeout(function() {
          return scope.go('files', 2000);
        });
      });
    };
    return scope.analyze = function(form) {
      var h;
      h = http({
        method: 'POST',
        url: '/analyze',
        data: scope.model
      });
      h.success(function(d) {
        var obj;
        obj = {
          excerpt: scope.model.text.substring(0, 100),
          filename: d.filename,
          results: d.result,
          words: scope.model.words
        };
        return Service.save(obj, success);
      });
      return h.error(function(e) {
        scope.success = '';
        return scope.error = e;
      });
    };
  };

  angular.module('wordsApp').controller('WordsCtrl', ['$scope', 'Texts', '$http', '$timeout', controller]);

}).call(this);

/*
//@ sourceMappingURL=words.map
*/
