jax.js
===

Jax is a tiny (~ 200 line) library for making ajax requests with an api like angular's $http library and built-in promises.

## Usage

- As a function, jax takes a single argument and exposes 2 methods for handling the response.

```
jax({type:'GET', url:'sample.json'})
    .success(function(response, fullRequest) {
      // Asynchronously called when a successful response is recieved.
    })
    .fail(function(response, fullRequest) {
      // Called if there's an error making the request.
    });
```

- There is also a third method, 'then', which takes a success handler as it's first parameter and (optionally) a failure handler as its second.

```
jax({type:'GET', url:'sample.json'}).then(doSomething, doSomethingElseOnFailure);
```

- Requests can be stored as a variable.

```
var req = jax({type:'GET', url:'sample.json'});

req.success(doSomething);
```

- Shorthand get and post methods are also provided:

```
// GET
jax.get('sample.json').then(callback);

// POST
jax.post('sample.json', data).then(callback);
```
