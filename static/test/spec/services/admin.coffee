'use strict'

describe 'Service: Admin', () ->

  # load the service's module
  beforeEach module 'wordsApp'

  # instantiate service
  Admin = {}
  beforeEach inject (_Admin_) ->
    Admin = _Admin_

  it 'should do something', () ->
    expect(!!Admin).toBe true
