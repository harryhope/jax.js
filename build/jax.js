(function() {
  var Promise, Request, isArray, jax, merge, parameterize, parse,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    __hasProp = {}.hasOwnProperty;

  Request = (function() {
    function Request(options) {
      var defaults, key, value, _ref;
      this.options = options;
      defaults = {
        type: 'GET',
        data: null,
        url: false
      };
      this.successful = new Promise;
      this.failure = new Promise;
      this.request = new XMLHttpRequest;
      this.options = merge(defaults, this.options);
      this.request.onreadystatechange = (function(_this) {
        return function() {
          var successCodes, _ref;
          successCodes = [200, 304];
          if (_this.request.readyState === 4) {
            if (_ref = _this.request.status, __indexOf.call(successCodes, _ref) >= 0) {
              return _this.successful.setData(parse(_this.request.responseText), _this.request);
            } else {
              return _this.failure.setData(_this.request.responseText, _this.request);
            }
          }
        };
      })(this);
      this.request.open(this.options.type, this.options.url, true);
      if (this.options.headers != null) {
        _ref = this.options.headers;
        for (key in _ref) {
          value = _ref[key];
          this.request.setRequestHeader(key, value);
        }
      }
      this.request.send(parameterize(this.options.data));
    }

    Request.prototype.then = function(successCallback, failCallback) {
      this.successful.setHandler(successCallback);
      if (failCallback != null) {
        this.failure.setHandler(failCallback);
      }
      return this;
    };

    Request.prototype.success = function(callback) {
      this.successful.setHandler(callback);
      return this;
    };

    Request.prototype.fail = function(callback) {
      this.failure.setHandler(callback);
      return this;
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
    var error, response, safetyString;
    safetyString = 'while(1);';
    if (input.substring(0, safetyString.length) === safetyString) {
      input = input.slice(safetyString.length);
    }
    try {
      response = JSON.parse(input);
    } catch (_error) {
      error = _error;
      response = input;
    }
    return response;
  };

  parameterize = function(input) {
    var add, index, key, result, spaceChars, value, _i, _len;
    if (typeof input === 'string') {
      return input;
    }
    if (typeof input === 'function') {
      input = input();
    }
    result = [];
    spaceChars = /%20/g;
    add = function(key, value) {
      if (typeof value === 'function') {
        value = value();
      }
      if (value === null) {
        value = '';
      }
      key = encodeURIComponent(key);
      value = encodeURIComponent(value);
      return result[result.length] = "" + key + "=" + value;
    };
    if (isArray(input)) {
      for (index = _i = 0, _len = input.length; _i < _len; index = ++_i) {
        value = input[index];
        add(index, value);
      }
    } else if (typeof input === 'object') {
      for (key in input) {
        if (!__hasProp.call(input, key)) continue;
        value = input[key];
        add(key, value);
      }
    }
    return result.join('&').replace(spaceChars, '+');
  };

  merge = function(object, properties) {
    var key, value;
    for (key in properties) {
      value = properties[key];
      object[key] = value;
    }
    return object;
  };

  isArray = function(item) {
    return Object.prototype.toString.call(item) === '[object Array]';
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

  jax.head = function(url) {
    var options;
    options = {
      type: 'HEAD',
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

  jax.put = function(url, data) {
    var options;
    options = {
      type: 'PUT',
      url: url,
      data: data
    };
    return new Request(options);
  };

  jax.patch = function(url, data) {
    var options;
    options = {
      type: 'PATCH',
      url: url,
      data: data
    };
    return new Request(options);
  };

  jax["delete"] = function(url) {
    var options;
    options = {
      type: 'DELETE',
      url: url
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
