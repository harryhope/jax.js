jax.js <a href="https://travis-ci.org/harryhope/jax.js"><img src="https://travis-ci.org/harryhope/jax.js.svg?branch=master" alt="Build status" /></a>
===

Jax is a tiny, dependency-free library for making ajax requests with an interface similar to Angular's $http service.

## Usage

As a function, jax takes a single argument and exposes success and fail methods for handling the response. The response as well as the raw XMLHttpRequest are available to use in the callbacks.

```javascript
jax({type:'GET', url:'sample.json'})
    .success(function(response, fullRequest) {
      // Asynchronously called when a successful response is recieved.
    })
    .fail(function(response, fullRequest) {
      // Called if there's an error making the request.
    });
```

There is also a third method, 'then', which takes a success handler as it's first parameter and (optionally) a failure handler as its second.

```javascript
jax({type:'GET', url:'sample.json'}).then(doSomething, doSomethingElseOnFailure);
```

Shorthand http verbs for `get`, `post`, `put`, `patch`, `head`, and `delete` are also available.

```javascript
// GET
jax.get('sample.json').then(callback);

// POST
jax.post('sample.json', data).then(callback);
```

## Developing
Use `grunt build` to compile and `grunt test` to run jasmine specs.
