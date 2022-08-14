
# fp.cfc

The goal of this project is to provide many of the higher order functions from newer versions of CFML back to CF 10 (which I happen to still be using), but to also provide different versions of those functions and some new ones as well.  Think lodash or ramda for CMFL.  No dependencies. Adobe ColdFusion 10+, Lucee 4.5+

## Documentation

There are two basic parts to this library at the moment - collection functions that focus on providing a better api for common operations, and utility type functions.  A new addition to the latter is Option() and Result() which are documented below.

### collection operations

Implementations of `map`, `filter`, `each`, `some`, `every`, `find`, `findIndex`, `reduce` and `reduceRight`.

All are able to work on arrays, structs, queries and lists. You can also use them on an object that implements a function of the same name. All take the form `fn(callback, data)` which allows you to provide only the callback function and not the data, which will curry the result giving you a function that you can just pass the data to.  Example:

```
    var result = fp.map(function (x) {
        return x * 2;
    }, [1,2,3]); // [2,4,6]

    var double = fp.map(function (x) {
        return x * 2;
    });

    var result = double([1,2,3]); // [2,4,6]
    var secondResult = double([4,5,6]); // [8,10,12]
```

You can also access the underlying implementation of these functions for a specific data type, they are prefixed with an underscore and conform to the signature of cfml, eg: `_arrayMap(required array data, callbackFn)`  These arent really intended to be used and in the future different versions of this library may omit them in favor of built in, or it may detect the built in functions.

The signature for the callback function for the different data types are:

Array: `fn(item, index)` - because this library supports ACF10 and in that version arrays are always passed by value not reference, the entire collection is not passed into the callback for performance reasons.

Struct: `fn(key, value, collection)`

Query: `fn(row, index, collection)`

List: `fn(item, index)` - same as arrays, the collection is not passed into the callback.


#### all collection operations

**Map:** `fp.map(fn [, data])`

Transform values of the collection using the callback function.  Callback can return any value.

**Each:** `fp.each(fn [, data])`

Intended to be used for side effects, callback function will be called once for each item.  Returns void, callback function results will be ignored.

**Filter:** `fp.filter(fn [,data])`

Callback function expected to return a boolean value, false means the item will not be in the resulting collection.

**Some:** `fp.some(fn [,data])`

Returns a boolean. Callback function expected to return a boolean value.  If at least one item returns true, the result is true.  If no items return true, the result is false.

**Every:** `fp.every(fn [,data])`

Returns a boolean. Callback function expected to return a boolean value.  If all items return true the result is true.  If at least one item returns false the result is false.

**Find:** `fp.find(fn [,data])`

Returns the first item from the collection for which the callback returns true.  Will return null if no item found.

**FindIndex:** `fp.findIndex(fn [,data])`

Returns the index of the first item from the collection for which the callback returns true.  Returns 0 if no item found.

**Reduce:** `fp.reduce(fn, initialValue [,data])`

Reduce the collection into another value.

**ReduceRight:** `fp.reduceRight(fn, initialValue [,data])`

Reduce that goes through the collection in the opposite order.

**GroupBy** `fp.groupBy(column [,data])`

Take a query or array of structs and group by a certain column - output will be a struct with the key as the value of the grouped by column and the value will be an array of rows that match that key.

## Option

`Option` is useful when you have a variable that may or may not contain a value and you want to a) be able to safely operate on this variable without worrying about if it actually contains a value or not, and b) force the consumer of the variable to handle the case of the value being null.  `Option`s are immutable, no operation on them should change their data.

The terminology used here is `some` and `none`, the variable is a `some` if it contains a value, it is a `none` if it does not contain a value.

You have three ways to create an `Option`, think of it as three different constructors. 

`var mySome = fp.Option().some(1)` - this will create an `Option` that is a `some` containing the value `1`.

`var myNone = fp.Option().none()` - this will create an `Option` that is a `none`.

`var myOption = fp.Option().of(value)` - if `value` is null, this will create a `none`, otherwise this will create a `some` with its `value`.

You can use the functions `isSome()` and `isNone()` to test if your `Option` has a value or not.

```
fp.Option().some(1).isSome(); //true
fp.Option().none().isSome(); //false
fp.Option().some(1).isNone(); //false
fp.Option().none().isNone(); //true
fp.Option().of(1).isSome(); //true
fp.Option().of(javacast("null", 0)).isSome(); //false
fp.Option().of(function () {
    //returns void;
}).isSome(); //false
```

To get the value out of your `Option` you can use the functions `unwrap()`, `unwrapOr(defaultValue)` and `unwrapOrElse(fn)`.  Be careful with `unwrap()`, you need to test first to make sure you have a `some`, if it is a `none` it will throw an error.

```
var some1 = fp.Option().some(1);
some1.unwrap(); // 1
some1.unwrapOr(2); // 1
some1.unwrapOrElse(function () {
    return 3;
}); //1

var none = fp.Option().none();
none.unwrap(); // Error!  Cannot unwrap a none.
none.unwrapOr(2); //2
none.unwrapOrElse(function () {
    return 3;
}); //3
```

For Option, `unwrap`, `unwrapOr` and `unwrapOrElse` have aliases of `get`, `getOr` and `getOrElse` respectively.

If you want to operate on your value without worrying if you have a value or not, you can use `map`.  It returns an `Option`, so you can keep chaining map calls.  If any of your map calls return null or void, the `Option` will change into a `none`, but that will be safe to do.

```
var opt1 = fp.Option().some(1);
opt1.map(function (x) {
    return x * 2;
}); // Some(2);

var opt2 = fp.Option().none();
opt2.map(function (x) {
    return x * 2;
}); // None()

var opt3 = fp.Option().some("foo");
opt3.map(function (x) {
    return ucase(x);
}).map(function (x) {
    // pretend this is a call to some other service, looking up the value and
    // that service returns null because the value wasnt found
    if (x == "BAR") {
        return x;
    }
}); // None()
```

You can use `filter` to transform your `Option` into a `none` if it doesn't meet a condition.

```
var optNumber = fp.Option().some(1);
optNumber.isSome(); //true
optNumber.filter(function (x) {
    return x % 2 == 0;
}); // None()
```

You can use `forEach` to call a function only if you have a `some`.  If it is a `none` the function will not be called.  The result of the callback function is not returned though.

```
var opt = fp.Option().some(1);
opt.forEach(function (x) {
    writeoutput(x);
}); // 1 was written to the output

var opt2 = fp.Option().none();
opt2.forEach(function (x) {
    writeoutput(x);
}); // no output, function was not called.
```

If you want to handle both cases and return a value depending on the value your `Option` contains, you can use `match`.  

```
var mySome = fp.Option().some(1);
var result = mySome.match({
    some: function (x) {
        return x * 2;
    },
    none: function () {
        return 0;
    }
}); // result == 2;

var myNone = fp.Option().none();
var result = myNone.match({
    some: function (x) {
        return x * 2;
    },
    none: function () {
        return 0;
    }
}); // result == 0;
``` 



## Result

If you have an operation that might succeed or fail, and you a) need a type that both represents the success or failure but also might contain the value of either the result or the error message, `Result` is a good fit. `Result`s are immutable, no operations on them should change the data they contain.

The terminology used here is `Ok` and `Err`, the variable is an `Ok` if the result represents a success, it is an `Err` if the result represents a failure.  Both can contain data.

You have two ways to create a `Result`.

`var myOk = fp.Result().Ok("my success value"); // Ok`

`var myErr = fp.Result().Err("my error message"); // Err`

You can use the functions `isOk()` and `isErr()` to figure out what kind of `Result` you have.

```
var myResult = fp.Result().Ok(1);
myResult.isOk(); //true
myResult.isErr(); //false

var myOtherResult = fp.Result().Err("something broke");
myOtherResult.isOk(); //false
myOtherResult.isErr(); //true
```

To get the values out of your `Result`, you have a few different ways to go about it.  First is `getOk()` and `getErr()`.  These return `Option`s of values, depending on if your `Result` is an `Ok` or `Err`.

```
var success = fp.Result().ok("success!");
success.getOk(); // Some("success!");
success.getOk().isSome(); // true
success.getOk().unwrap(); // "success!"

success.getErr(); // None()
success.getErr().isSome(); // false
success.getErr().unwrapOr("default"); // "default"

var failure = fp.Result().err("failure!");
failure.getOk(); // None()
failure.getOk().isSome(); // true
failure.getOk().unwrapOr("default"); // "default"

failure.getErr(); // Some("failure!");
failure.getErr().isSome(); // true
failure.getErr().unwrap(); // "failure!"
```

The other option is to use `unwrap` or `unwrapErr`.  

```
var success = fp.Result().ok("success!");
success.unwrap(); // "success!"
success.unwrapErr(); // throws -> Called unwrapErr on Result.Ok
success.unwrapOr("default value"); // "success!"
success.unwrapOrElse(function (err) {
    return "Something went wrong: " & err;
}); // "success!"

var failure = fp.Result().err("failure!");
failure.unwrap(); // throws -> Called unwrap on a Result.Err
failure.unwrapErr(); // "failure!"
failure.unwrapOr("default value"); // "default value"
failure.unwrapOrElse(function (err) {
    return "Something went wrong: " & err;
}); // "Something went wrong: failure!"
```

You can use `map` and `mapErr` to transform your values without having to worry about if you have a value or not.

```
var success = fp.Result().ok(1);
var mappedSuccess = success.map(function (okVal) {
    return okVal * 2;
}); // Ok(2)

var failure = fp.Result().err("Error Code: 3");
var mappedFailure = failure.map(function (okVal) {
    return okVal * 2;
}); // Err("Error Code: 3")

var success = fp.Result().ok(1);
var mappedSuccess = success.mapErr(function (errVal) {
    return trim(listLast(errVal, ":"));
}); // Ok(1)

var failure = fp.Result().err("Error Code: 3");
var mappedFailure = failure.mapErr(function (errVal) {
    return trim(listLast(errVal, ":"));
}); // Err("3")
```

You can use `match` to handle both cases at the same time.

```
var myResult = fp.Result().ok(1);
var handledResult = myResult.match({
    ok: function (okVal) {
        return "ok";
    }, errVal: function (errVal) {
        return "error";
    }
}); // "ok"

var myResult = fp.Result().err(1);
var handledResult = myResult.match({
    ok: function (okVal) {
        return "ok";
    }, errVal: function (errVal) {
        return "error";
    }
}); // "error"
```

### Misc functions

`isCallable(fn)` - returns true if the input is a custom function or anonymous function.

`times(fn, numberOfIterations)` - will call the callback numberOfIterations times.  Callback will receive the index of the current iteration.

`queryToStruct(string keyBy, query data)` - will transform the query into a struct with a key of the value of the `keyBy` column and a value which is a struct of that row.  It is expected that the value of the `keyBy` column is unique in the query, ie that only one row per `keyBy` value.

`head(data)` - you can pass an array, query, list or object that implements a `head` method, will give you the first item in the collection.  Returns null for an empty collection.

`tail(data)` - you can pass an array, query, list or object that implements a `tail` method, will give you all but the first item in the collection.  Returns an empty collection for an empty collection.

`defaults(value, defaultValue)` - if value is null, return the default value.  Note: the value passed as the defaultValue will be evaluated, even if it is not used.  If you dont want that to happen, you can wrap your call in an anonymous function which will only be evaluated if necessary.  `defaults(value, function() { return someCallYouOnlyWantToHappenIfNecessary(); })`;

`identity(value)` returns the same value you pass in.

`pluck(key, data)` a shortcut for mapping an array of structs to pull out just a single key. 



#### methods not currently provided

These are things that are not currently provided by this library but are things I intend to eventually implement.  If you would like to use these, please feel free to reach out and/or send a PR.

`collect` - Like `map` plus `filter`, if the callback returns void the item is omitted from the resulting collection.

`flatMap` - If multiple items are returned, result will be flattened.

`distinct` - look through a collection and return only distinct items.  (This may be an array only method?)


## How to run the tests

1. Download testbox from: http://www.ortussolutions.com/products/testbox
2. Unzip the testbox/ folder into the root of the application (as a peer to tests)
3. The tests expect a redis instance to be running on localhost:6379, edit the top of /tests/basicTest.cfc if your instance is different
3. run /tests/index.cfm - will run the individual tests under basic remotely to be able to set the cookie headers

Or, if you use docker / docker-compose, you can use the included docker-compose file.

1. Clone the project.
2. `docker-compose up -d`
3. Hit the docker ip address on port 80.

You could swap out the `app` service with lucee or other coldfusion version if you would rather use that.

Or, if you use coldbox, you can use `box server start` to test on lucee 5 and then hit `http://localhost:8090`

For other versions to test with, use:

`box server start lucee5` which runs on  `http://localhost:8090`

`box server start lucee45` which runs on  `http://localhost:8091`

`box server start acf10` which runs on  `http://localhost:8092`

`box server start acf11` which runs on  `http://localhost:8093`

`box server start acf2016` which runs on  `http://localhost:8094`

To stop, use `box server stop [name]` with whichever name you used, and you can use `box server list` to see all servers you have.

## Contributions

All contributions welcome! Issues, code, ideas, bug reports, whatever.

## License

This software is licensed under the Apache 2 license, quoted below.

Copyright 2016 Ryan Guill <ryanguill@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.
