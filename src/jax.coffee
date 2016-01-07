# jax.js
# A simple wrapper library for xmlhttp and jsonp requests.
# Freely distributable under the MIT License.
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Harry Hope
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Wrapper class for an xmlhttp request.
#
# @param [Object] options
class Request

  constructor: (@options) ->
    defaults =
      type: 'GET'
      data: null
      url: no

    @successful = new Promise
    @failure = new Promise
    @request = new XMLHttpRequest
    @options = merge(defaults, @options)

    # Set handlers.
    @request.onreadystatechange = =>

      # Server responses that indicate success.
      successCodes = [200, 304]

      # Route our response to the appropriate callback.
      if @request.readyState is 4
        if @request.status in successCodes
          @successful.setData(parse(@request.responseText), @request)
        else
          @failure.setData(@request.responseText, @request)

    # Open a connection.
    @request.open(@options.type, @options.url, true)

    # Set headers if requested.
    if @options.headers?
      for key, value of @options.headers
        @request.setRequestHeader(key, value)

    # Send data if POST'ing.
    @request.send(parameterize(@options.data))

  then: (successCallback, failCallback) ->
    @successful.setHandler(successCallback)
    @failure.setHandler(failCallback) if failCallback?
    return this

  success: (callback) ->
    @successful.setHandler(callback)
    return this

  fail: (callback) ->
    @failure.setHandler(callback)
    return this

# A simple stand-alone promise implementation.
#
# @param [Object] options
class Promise

  constructor: ->
    @done = no
    @handler = null
    @data = null
    @obj = null

  setHandler: (callback) ->
    if @done
      callback(@data, @obj)
    else
      @handler = callback
    return this

  setData: (data, obj) ->
    if @handler isnt null
      @handler(data, obj)
    else
      @data = data
      @obj = obj
      @done = yes
    return this

# Helper function for parsing json.
#
# @param [String] input
# @return [String] response
parse = (input) ->
  safetyString = 'while(1);'

  # Remove a safety string to prevent a JSON vulnerability.
  if input.substring(0, safetyString.length) is safetyString
    input = input.slice(safetyString.length)

  # Attempt to parse a json string.
  try
    response = JSON.parse(input)
  catch error
    response = input
  return response

# Turn an object or array into a serialized string.
#
# @param input
# @return [String]
parameterize = (input) ->
  return input if typeof input is 'string'

  input = input() if typeof input is 'function'

  result = []
  spaceChars = /%20/g

  add = (key, value) ->
    value = value() if typeof value is 'function'
    value = '' if value is null
    key = encodeURIComponent(key)
    value = encodeURIComponent(value)
    result[result.length] = "#{key}=#{value}"

  if isArray(input)
    add(index, value) for value, index in input

  else if typeof input is 'object'
    add(key, value) for own key, value of input

  return result.join('&').replace(spaceChars, '+')

# Merge properties of one object into another.
#
# @param [Object] object
# @param [Object] properties
# @return [Object] object
merge = (object, properties) ->
  for key, value of properties
    object[key] = value

  return object

# Check if the item is an array.
#
# @param [Mixed] item
# @return [Boolean]
isArray = (item) ->
  return Object.prototype.toString.call(item) is '[object Array]'

# Primary jax function.
#
# @param [Object] options
# @return [Request]
jax = (options) ->
  return new Request options

# Get request shorthand method.
#
# @param [String] url
# @return [Request]
jax.get = (url) ->
  options =
    type: 'GET'
    url : url

  return new Request options

# Head request shorthand method.
#
# @param [String] url
# @return [Request]
jax.head = (url) ->
  options =
    type: 'HEAD'
    url : url

  return new Request options

# Post request shorthand method.
#
# @param [String] url
# @param [Object] data
# @return [Request]
jax.post = (url, data) ->
  options =
    type: 'POST'
    url: url
    data: data

  return new Request options

# Put request shorthand method.
#
# @param [String] url
# @param [Object] data
# @return [Request]
jax.put = (url, data) ->
  options =
    type: 'PUT'
    url: url
    data: data

  return new Request options

# Patch request shorthand method.
#
# @param [String] url
# @param [Object] data
# @return [Request]
jax.patch = (url, data) ->
  options =
    type: 'PATCH'
    url: url
    data: data

  return new Request options

# Delete request shorthand method.
#
# @param [String] url
# @return [Request]
jax.delete = (url) ->
  options =
    type: 'DELETE'
    url : url

  return new Request options

# Export as a CommonJS module, an AMD module, or
# otherwise add it to the global (window) scope.
if module? and module.exports?
  module.exports = jax

else if define? and define.amd?
  define -> jax

else
  window.jax = jax
