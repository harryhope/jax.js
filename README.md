jax.js ![build status](https://travis-ci.org/harryhope/jax.js.svg?branch=master)
===

Jax is a tiny library for making ajax requests with an interface similar to angular's $http service.

## Usage

As a function, jax takes a single argument and exposes success and fail methods for handling the response. The response as well as the raw XMLHttpRequest are available to use in the callbacks.

```
jax({type:'GET', url:'sample.json'})
    .success(function(response, fullRequest) {
      // Asynchronously called when a successful response is recieved.
    })
    .fail(function(response, fullRequest) {
      // Called if there's an error making the request.
    });
```

There is also a third method, 'then', which takes a success handler as it's first parameter and (optionally) a failure handler as its second.

```
jax({type:'GET', url:'sample.json'}).then(doSomething, doSomethingElseOnFailure);
```

Shorthand http verbs for `get`, `post`, `put`, and `delete` are also available

```
// GET
jax.get('sample.json').then(callback);

// POST
jax.post('sample.json', data).then(callback);
```
