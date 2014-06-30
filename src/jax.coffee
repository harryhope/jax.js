# jax.js
# A simple wrapper library for xmlhttp and jsonp requests.
# Freely distributable under the MIT License.
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Harry Hope
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

'use strict'

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
    @request.send(@options.data)


  then: (successCallback, failCallback) ->
    @successful.setHandler(successCallback)
    @failure.setHandler(failCallback) if failCallback?

  success: (callback) ->
    @successful.setHandler(callback)

  fail: (callback) ->
    @failure.setHandler(callback)

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
    @

  setData: (data, obj) ->
    if @handler isnt null
      @handler(data, obj)
    else
      @data = data
      @obj = obj
      @done = yes
    @

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
  response

# Helper function that merges properties of one object
# into another (a shallow copy).
#
# @param [Object] object
# @param [Object] properties
# @return [Object] object
merge = (object, properties) ->
  for key, value of properties
    object[key] = value
  object

# Primary jax function.
#
# @param [Object] options
# @return [Request]
jax = (options) ->
  new Request options

# Get request shorthand method.
#
# @param [String] url
# @return [Request]
jax.get = (url) ->

  options =
    type: 'GET'
    url : url

  new Request options

# Post request shorthand method.
#
# @param [String] url
# @return [Request]
jax.post = (url, data) ->

  options =
    type: 'POST'
    url: url
    data: data

  new Request options

# Export as a CommonJS module, an AMD module, or
# otherwise add it to the global (window) scope.
if module? and module.exports?
  module.exports = jax

else if define? and define.amd?
  define(() -> jax)

else
  window.jax = jax
