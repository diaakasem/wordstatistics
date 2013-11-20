'use strict';

describe('Directive: signup', function () {

  // load the directive's module
  beforeEach(module('wordstatisticsApp'));

  var element,
    scope;

  beforeEach(inject(function ($rootScope) {
    scope = $rootScope.$new();
  }));

  it('should make hidden element visible', inject(function ($compile) {
    element = angular.element('<signup></signup>');
    element = $compile(element)(scope);
    expect(element.text()).toBe('this is the signup directive');
  }));
});
