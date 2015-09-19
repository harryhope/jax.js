describe 'Jax', ->

  beforeEach ->
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  it 'should send a GET request to the correct URL.', ->
    done = jasmine.createSpy('success')

    jasmine.Ajax.stubRequest('/test/url').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.get('/test/url').then (response) ->
      done(response)

    request = jasmine.Ajax.requests.mostRecent()
    expect(done).toHaveBeenCalledWith('mock server response.')
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
    done = jasmine.createSpy('succeed')
    data = {name: 'lemon', type: 'fruit'}

    jasmine.Ajax.stubRequest('/test/url/3').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(done).toHaveBeenCalledWith('mock server response.')
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})

  it 'should POST arrays with the indices as keys', ->
    done = jasmine.createSpy('succeed')
    data = ['lemon', 'fruit']

    jasmine.Ajax.stubRequest('/test/url/3').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(done).toHaveBeenCalledWith('mock server response.')
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({0:[ 'lemon' ], 1:[ 'fruit' ]})

  it 'should handle functions as parameters', ->
    done = jasmine.createSpy('succeed')
    data = ->
      return {name: 'lemon', type: 'fruit'}

    jasmine.Ajax.stubRequest('/test/url/3').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(done).toHaveBeenCalledWith('mock server response.')
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})

  it 'should handle functions inside objects', ->
    done = jasmine.createSpy('succeed')
    data =
      name: 'lemon'
      type: -> 'fruit'

    jasmine.Ajax.stubRequest('/test/url/3').andReturn
      'status': 200,
      'responseText': 'mock server response.'

    jax.post('/test/url/3', data).then (data) ->
      done(data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(done).toHaveBeenCalledWith('mock server response.')
    expect(request.url).toBe('/test/url/3')
    expect(request.method).toBe('POST')
    expect(request.data()).toEqual({name:[ 'lemon' ], type:[ 'fruit' ]})

  it 'should use head correctly', ->
    jax.head('/test/url')

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.method).toBe('HEAD')

  it 'should use put correctly', ->
    data = {'test':'item'}
    jax.put('/test/url', data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.method).toBe('PUT')

  it 'should use patch correctly', ->
    data = {'test':'item'}
    jax.patch('/test/url', data)

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.method).toBe('PATCH')

  it 'should use delete correctly', ->
    jax.delete('/test/url')

    request = jasmine.Ajax.requests.mostRecent()
    expect(request.method).toBe('DELETE')
