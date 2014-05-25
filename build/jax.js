(function() {
  'use strict';
  var Promise, Request, jax, parse,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Request = (function() {
    function Request(options) {
      this.options = options;
      this.success = new Promise;
      this.failure = new Promise;
      this.request = new XMLHttpRequest;
      this.request.onreadystatechange = (function(_this) {
        return function() {
          var successCodes, _ref;
          successCodes = [200, 304, 0];
          if (_this.request.readyState === 4) {
            if (_ref = _this.request.status, __indexOf.call(successCodes, _ref) >= 0) {
              return _this.success.setData(parse(_this.request.responseText), _this.request);
            } else {
              return _this.failure.setData(_this.request.responseText, _this.request);
            }
          }
        };
      })(this);
      this.request.open(this.options.type, this.options.url, true);
      this.request.send(this.options.data);
    }

    Request.prototype.then = function(callback) {
      return this.success.setHandler(callback);
    };

    Request.prototype.fail = function(callback) {
      return this.failure.setHandler(callback);
    };

    return Request;

  })();

  Promise = (function() {
    function Promise() {
      this.done = false;
      this.handler = null;
      this.data = null;
      this.obj = null;
    }

    Promise.prototype.setHandler = function(callback) {
      if (this.done) {
        callback(this.data, this.obj);
      } else {
        this.handler = callback;
      }
      return this;
    };

    Promise.prototype.setData = function(data, obj) {
      if (this.handler !== null) {
        this.handler(data, obj);
      } else {
        this.data = data;
        this.obj = obj;
        this.done = true;
      }
      return this;
    };

    return Promise;

  })();

  parse = function(input) {
    var error, response;
    try {
      response = JSON.parse(input);
    } catch (_error) {
      error = _error;
      response = input;
    }
    return response;
  };

  jax = function(options) {
    return new Request(options);
  };

  jax.get = function(url) {
    var options;
    options = {
      type: 'GET',
      url: url
    };
    return new Request(options);
  };

  jax.post = function(url, data) {
    var options;
    options = {
      type: 'POST',
      url: url,
      data: data
    };
    return new Request(options);
  };

  if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
    module.exports = jax;
  } else if ((typeof define !== "undefined" && define !== null) && (define.amd != null)) {
    define(function() {
      return jax;
    });
  } else {
    window.jax = jax;
  }

}).call(this);