describe 'Jax', ->

  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'should send a GET request to the correct URL.', ->
    jax.get('/test/url').then ->
      console.log('nothing')

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/test/url')
    expect(request.method).toBe('GET')

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

  it 'should be chainable', ->
    fail = jasmine.createSpy('fail')
    succeed = jasmine.createSpy('success')

    jasmine.Ajax.stubRequest('/test/url').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.get('/test/url').success (data) ->
        succeed(data)
      .fail (data) ->
        fail(data)

    expect(succeed).toHaveBeenCalledWith('mock server response.')
    expect(fail).not.toHaveBeenCalled()

  it 'should POST to the correct URL & with the right data', ->
    done = jasmine.createSpy('done')
    data = {name: 'lemon', type: 'fruit'}

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})

  it 'should POST arrays with the indices as keys', ->
    done = jasmine.createSpy('done')
    data = ['lemon', 'fruit']

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({0:[ 'lemon' ], 1:[ 'fruit' ]})

  it 'should handle functions as parameters', ->
    done = jasmine.createSpy('done')
    data = ->
      return {name: 'lemon', type: 'fruit'}

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})

  it 'should handle functions inside objects', ->
    done = jasmine.createSpy('done')
    data =
      name: 'lemon'
      type: -> 'fruit'

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})
