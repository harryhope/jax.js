describe 'Jax', ->

  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'should send a GET request to the correct URL.', ->
    jax.get('/test/url').then ->
      console.log('nothing')

    expect(jasmine.Ajax.requests.mostRecent().url).toBe('/test/url')

  it 'should retrieve data from the server properly.', ->
    done = jasmine.createSpy('success')

    jasmine.Ajax.stubRequest('/test/url').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.get('/test/url').success (data) ->
       done(data)

    expect(done).toHaveBeenCalledWith('mock server response.')

  it 'should handle errors correctly', ->
    fail = jasmine.createSpy('fail')
    succeed = jasmine.createSpy('success')

    jasmine.Ajax.stubRequest('/test/url/2').andReturn
      'status' : 500,
      'responseText': 'error!'

    jax.get('/test/url/2').then (data) ->
       succeed(data)

    jax.get('/test/url/2').fail (data) ->
       fail(data)

    expect(succeed).not.toHaveBeenCalledWith('error!')
    expect(fail).toHaveBeenCalledWith('error!')
