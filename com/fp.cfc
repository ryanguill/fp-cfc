component {

	/* NOTE: some of these methods will need to be replaced with native versions if we upgrade CF past 10 */

	/*========================================================
	Helpers
	========================================================*/

	private function queryFunctionHelper (data, f, f2) {
		var output = f2(data, f);
		var md = getMetaData(data);
		var columns = arrayToList(_arrayMap(md, function(column) {
			return column.name;
		}), ",");
		var types = arrayToList(_arrayMap(md, function(column) {
			if (arrayFindNoCase(["text","uuid","json"], column.typeName)) {
				return "VarChar";
			}
			return column.typeName;
		}), ",");
		return queryNew(columns, types, output);
	}

	/*========================================================
	MAP
	========================================================*/

	/* takes a callback of f(value, index, array) */
	function _arrayMap (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			arrayAppend(output, f(data[i], i));
		}
		return output;
	}

	/* takes a callback of f(key, value, struct) */
	function _structMap (required struct data, required any f) {
		var output = {};
		for (var key in data) {
			output[key] = f(key, data[key], data);
		}
		return output;
	}

	/* takes a callback of f(row{struct}, rowNumber, query) */
	function _queryMapToArray (required query data, required any f) {
		var output = [];
		var i = 0;
		for (var row in data) {
			arrayAppend(output, f(row, ++i, data));
		}
		return output;
	}

	function _queryMap (required query data, required any f) {
		return queryFunctionHelper(data, f, _queryMapToArray);
	}

	/* takes a callback of f(value, index, list) */
	function _listMap (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return arrayToList(_arrayMap(dataArray, f), delimiter);
	}


	function map (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayMap(data, f);
			}  else if (isObject(data)) {
				if (structKeyExists(data, "map")) {
					return data.map(f);
				} else {
					throw("this object does not provide a `map` method");
				}
			} else if (isStruct(data)) {
				return _structMap(data, f);
			} else if (isQuery(data)) {
				return _queryMap(data, f);
			} else if (isSimpleValue(data)) {
				return _listMap(data, f);
			} else {
				throw("Invalid data type for `map` - please provide one of the following [array,struct,query,list or object that defines a map method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return map(fx, arguments.data);
			};
		}
	}

	/*========================================================
	EACH
	========================================================*/

	/* takes a callback of f(value, index, array) */
	function _arrayEach (required array data, required any f) {
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			f(data[i], i);
		}
	}

	/* takes a callback of f(key, value, struct) */
	function _structEach (required struct data, required any f) {
		for (var key in data) {
			f(key, data[key], data);
		}
	}

	/* takes a callback of f(row{struct}, rowNumber, query) */
	function _queryEach (required query data, required any f) {
		var i = 0;
		for (var row in data) {
			f(row, ++i, data);
		}
	}

	/* takes a callback of f(value, index, list) */
	function _listEach (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		_arrayMap(dataArray, f);
	}


	function each (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayEach(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "each")) {
					return data.each(f);
				} else {
					throw("this object does not provide an `each` method");
				}
			} else if (isStruct(data)) {
				return _structEach(data, f);
			} else if (isQuery(data)) {
				return _queryEach(data, f);
			} else if (isSimpleValue(data)) {
				return _listEach(data, f);
			} else {
				throw("Invalid data type for `each` - please provide one of the following [array,struct,query,list or object that defines an each method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return each(fx, arguments.data);
			};
		}
	}

	/*========================================================
	FILTER
	========================================================*/

	function _arrayFilter (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			if (f(data[i], i)) {
				arrayAppend(output, data[i]);
			}
		}
		return output;
	}

	function _structFilter (required struct data, required any f) {
		var output = {};
		for (var key in data) {
			if (f(key, data[key], data)) {
				output[key] = data[key];
			}
		}
		return output;
	}

	function _queryFilterToArray (required query data, required any f) {
		var output = [];
		var i = 0;
		for (var row in data) {
			if (f(row, ++i, data)) {
				arrayAppend(output, row);
			}
		}
		return output;
	}

	function _queryFilter (required query data, required any f) {
		return queryFunctionHelper(data, f, _queryFilterToArray);
	}

	function _listFilter (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return arrayToList(_arrayFilter(dataArray, f), delimiter);
	}

	function filter (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayFilter(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "filter")) {
					return data.filter(f);
				} else {
					throw("this object does not provide a `filter` method");
				}
			} else if (isStruct(data)) {
				return _structFilter(data, f);
			} else if (isQuery(data)) {
				return _queryFilter(data, f);
			} else if (isSimpleValue(data)) {
				return _listFilter(data, f);
			} else {
				throw("Invalid data type for `filter` - please provide one of the following [array,struct,query,list or object that defines a filter method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return filter(fx, arguments.data);
			};
		}
	}

	/*========================================================
	filterUntil
	========================================================*/

	//start at the beginning and include rows until you hit the first false (which isnt included)
	//requires input to be ordered
	function _arrayFilterUntil (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			if (f(data[i], i)) {
				arrayAppend(output, data[i]);
			} else {
				break;
			}
		}
		return output;
	}

	/*========================================================
	SOME / ANY
	========================================================*/

	function _arraySome (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			if (f(data[i], i)) {
				return true;
			}
		}
		return false;
	}

	function _structSome (required struct data, required any f) {
		var output = {};
		for (var key in data) {
			if (f(key, data[key], data)) {
				return true;
			}
		}
		return false;
	}

	function _querySome (required query data, required any f) {
		var output = [];
		var i = 0;
		for (var row in data) {
			if (f(row, ++i, data)) {
				return true;
			}
		}
		return false;
	}

	function _listSome (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return _arraySome(dataArray, f);
	}

	function some (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arraySome(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "some")) {
					return data.some(f);
				} else {
					throw("this object does not provide a `some` method");
				}
			} else if (isStruct(data)) {
				return _structSome(data, f);
			} else if (isQuery(data)) {
				return _querySome(data, f);
			} else if (isSimpleValue(data)) {
				return _listSome(data, f);
			} else {
				throw("Invalid data type for `some` - please provide one of the following [array,struct,query,list or object that defines a some method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return some(fx, arguments.data);
			};
		}
	}

	/*========================================================
	EVERY
	========================================================*/

	function _arrayEvery (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			if (!f(data[i], i)) {
				return false;
			}
		}
		return true;
	}

	function _structEvery (required struct data, required any f) {
		var output = {};
		for (var key in data) {
			if (!f(key, data[key], data)) {
				return false;
			}
		}
		return true;
	}

	function _queryEvery (required query data, required any f) {
		var output = [];
		var i = 0;
		for (var row in data) {
			if (!f(row, ++i, data)) {
				return false;
			}
		}
		return true;
	}

	function _listEvery (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return _arrayEvery(dataArray, f);
	}

	function every (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayEvery(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "every")) {
					return data.every(f);
				} else {
					throw("this object does not provide an `every` method");
				}
			} else if (isStruct(data)) {
				return _structEvery(data, f);
			} else if (isQuery(data)) {
				return _queryEvery(data, f);
			} else if (isSimpleValue(data)) {
				return _listEvery(data, f);
			} else {
				throw("Invalid data type for `every` - please provide one of the following [array,struct,query,list or object that defines a every method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return every(fx, arguments.data);
			};
		}
	}

	/*========================================================
	FIND
	========================================================*/

	function _arrayFind (required array data, required any f) {
		var dataLen = arrayLen(arguments.data);
		for (var i = 1; i <= dataLen; i++) {
			if (f(arguments.data[i], i)) {
				return arguments.data[i];
			}
		}
		return javacast("null", 0);
	}

	function _structFind (required struct data, required any f) {
		var output = {};
		for (var key in data) {
			if (f(key, data[key], data)) {
				output[key] = data[key];
				return output;
			}
		}
		return javacast("null", 0);
	}

	function _queryFind (required query data, required any f) {
		var i = 0;
		for (var row in data) {
			if (f(row, ++i, data)) {
				return row;
			}
		}
		return javacast("null", 0);
	}

	function _listFind (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return _arrayFind(dataArray, f);
	}

	function find (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayFind(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "find")) {
					return data.find(f);
				} else {
					throw("this object does not provide a `find` method");
				}
			} else if (isStruct(data)) {
				return _structFind(data, f);
			} else if (isQuery(data)) {
				return _queryFind(data, f);
			} else if (isSimpleValue(data)) {
				return _listFind(data, f);
			} else {
				throw("Invalid data type for `find` - please provide one of the following [array,struct,query,list or object that defines a find method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return variables.find(fx, arguments.data);
			};
		}
	}

	/*========================================================
	FINDINDEX
	========================================================*/

	function _arrayFindIndex (required array data, required any f) {
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			if (f(data[i], i)) {
				return i;
			}
		}
		return 0;
	}

	function _structFindIndex (required struct data, required any f) {
		for (var key in data) {
			if (f(key, data[key], data)) {
				return key;
			}
		}
		return javacast("null", 0);
	}

	function _structFindKey () {
		return _structFindIndex(argumentCollection=arguments);
	}

	function _queryFindIndex (required query data, required any f) {
		var i = 0;
		for (var row in data) {
			if (f(row, ++i, data)) {
				return i;
			}
		}
		return 0;
	}

	function _listFindIndex (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		return _arrayFindIndex(dataArray, f);
	}

	function findIndex (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayFindIndex(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "findIndex")) {
					return data.findIndex(f);
				} else {
					throw("this object does not provide a `findIndex` method");
				}
			} else if (isStruct(data)) {
				return _structFindIndex(data, f);
			} else if (isQuery(data)) {
				return _queryFindIndex(data, f);
			} else if (isSimpleValue(data)) {
				return _listFindIndex(data, f);
			} else {
				throw("Invalid data type for `findIndex` - please provide one of the following [array,struct,query,list or object that defines a findIndex method]");
			}
		} else {
			var fx = arguments.f;
			return function (data) {
				return findIndex(fx, arguments.data);
			};
		}
	}

	/*========================================================
	REDUCE
	========================================================*/

	function _arrayReduce (required array data, required any f, any initialValue) {

		var dataLen = arrayLen(data);
		var i = 1;

		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (dataLen > 0) {
			var acc = data[1];
			i++;
		} else {
			throw("Reduce of empty collection with no initial value");
		}

		for (; i <= dataLen; i++) {
			acc = f(acc, data[i], i);
		}
		return acc;
	}

	//note! there are no order guarentees when using this function!
	function _structReduce (required struct data, required any f, any initialValue) {

		//assume that structKeyArray will give us the results in the correct order, its all we can do
		var keys = structKeyArray(data);
		var dataLen = arrayLen(keys);
		var i = 1;

		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (dataLen > 0) {
			var acc = data[keys[1]];
			i++;
		}  else {
			throw("Reduce of empty collection with no initial value");
		}

		for (; i <= dataLen; i++) {
			acc = f(acc, keys[i], data[keys[i]], data);
		}
		return acc;
	}

	function _queryReduce (required query data, required any f, any initialValue) {

		var skipFirstRow = false;
		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (data.recordCount > 0) {
			var acc = javaCast("null", 0);
			var skipFirstRow = true;
		} else {
			throw("Reduce of empty collection with no initial value");
		}
		var i = 0;
		for (var row in data) {
			i++;
			if (isNull(acc)) {
				acc = row;
			}
			if (i == 1 && skipFirstRow) {
				continue;
			}
			acc = f(acc, row, i, data);
		}
		return acc;
	}

	function _listReduce (required string data, required any f, any initialValue, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		if (isNull(initialValue)) {
			return _arrayReduce(dataArray, f);
		}
		return _arrayReduce(dataArray, f, initialValue);
	}

	function reduce (required any f, required any initialValue, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayReduce(data, f, initialValue);
			} else if (isObject(data)) {
				if (structKeyExists(data, "reduce")) {
					return data.reduce(f, initialValue);
				} else {
					throw("this object does not provide a `reduce` method");
				}
			} else if (isStruct(data)) {
				return _structReduce(data, f, initialValue);
			} else if (isQuery(data)) {
				return _queryReduce(data, f, initialValue);
			} else if (isSimpleValue(data)) {
				return _listReduce(data, f, initialValue);
			} else {
				throw("Invalid data type for `reduce` - please provide one of the following [array,struct,query,list or object that defines a reduce method]");
			}
		} else {
			var fx = arguments.f;
			var iv = arguments.initialValue;
			return function (data) {
				return reduce(fx, iv, arguments.data);
			};
		}
	}



	/*========================================================
	REDUCERIGHT
	========================================================*/

	function _arrayReduceRight (required array data, required any f, any initialValue) {

		var dataLen = arrayLen(data);
		var i = dataLen;

		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (dataLen > 0) {
			var acc = data[dataLen];
			i--;
		} else {
			throw("ReduceRight of empty collection with no initial value");
		}

		for (; i >= 1; i--) {
			acc = f(acc, data[i], i);
		}
		return acc;
	}

	//note! there are no order guarentees when using this function!
	function _structReduceRight (required struct data, required any f, any initialValue) {

		//assume that structKeyArray will give us the results in the correct order, its all we can do
		var keys = structKeyArray(data);
		var dataLen = arrayLen(keys);
		var i = dataLen;

		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (dataLen > 0) {
			var acc = data[keys[dataLen]];
			i--;
		}  else {
			throw("ReduceRight of empty collection with no initial value");
		}

		for (; i >= 1; i--) {
			var key = keys[i];
			acc = f(acc, key, data[key], data);
		}
		return acc;
	}

	function _queryReduceRight (required query data, required any f, any initialValue) {

		if (!isNull(initialValue)) {
			var acc = duplicate(initialValue);
		} else if (data.recordCount > 0) {
			var acc = javaCast("null", 0);
		} else {
			throw("ReduceRight of empty collection with no initial value");
		}

		//convert to an array of structs and then iterate backwards
		var dataArray = _queryMapToArray(data, function(row) {return row;});
		var dataLen = data.recordCount;
		var i = dataLen;

		for (; i >= 1; i--) {
			acc = f(acc, dataArray[i], i, data);
		}
		return acc;
	}

	function _listReduceRight (required string data, required any f, any initialValue, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = listToArray(data, delimiter, includeEmptyFields);
		if (isNull(initialValue)) {
			return _arrayReduceRight(dataArray, f);
		}
		return _arrayReduceRight(dataArray, f, initialValue);
	}

	function reduceRight (required any f, required any initialValue, any data) {

		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayReduceRight(data, f, initialValue);
			} else if (isObject(data)) {
				if (structKeyExists(data, "reduceRight")) {
					return data.reduceRight(f, initialValue);
				} else {
					throw("this object does not provide a `reduceRight` method");
				}
			} else if (isStruct(data)) {
				return _structReduceRight(data, f, initialValue);
			} else if (isQuery(data)) {
				return _queryReduceRight(data, f, initialValue);
			} else if (isSimpleValue(data)) {
				return _listReduceRight(data, f, initialValue);
			} else {
				throw("Invalid data type for `reduceRight` - please provide one of the following [array,struct,query,list or object that defines a reduceRight method]");
			}
		} else {
			var fx = arguments.f;
			var iv = arguments.initialValue;
			return function (data) {
				return reduceRight(fx, iv, arguments.data);
			};
		}

	}

	/*========================================================
	Arrays
	========================================================*/

	//push

	//unshift

	//join



	/*========================================================
	MISC
	========================================================*/

	function isCallable (f) {
		return isCustomFunction(f) || isClosure(f);
	}

	//takes a callback of f(n); side effects
	function times (required any f, numeric n) {
		if (!isNull(n)) {
			for (var i = 1; i <= n; i++) {
				f(i);
			}
		} else {
			var fx = arguments.f;
			return function(numeric n) {
				return times(fx, arguments.n);
			};
		}
	}

	function queryToStruct (required string keyBy, required query data) {
		var output = {};
		for (var row in data) {
			output[row[keyBy]] = row;
		}
		return output;
	}

	//head

	function _arrayHead (required array data) {
		if (arrayLen(data)) {
			return data[1];
		}
		return javacast("null", 0);
	}

	function _queryHead (required query data) {
		if (data.recordCount) {
			for (var row in data) {
				return row; //only the first record
			}
		}
	}

	function _listHead (required string data, string delimiter = ",", boolean includeEmptyFields = false) {
		//listFirst doesnt support includeEmptyFields
		return _arrayHead(listToArray(data, delimiter, includeEmptyFields));
	}

	function head (required any data) {
		if (isArray(data)) {
			return _arrayHead(data);
		} else if (isQuery(data)) {
			return _queryHead(data);
		} else if (isSimpleValue(data)) {
			return _listHead(data);
		} else if (isObject(data)) {
			if (structKeyExists(data, "head")) {
				return data.head();
			} else {
				throw("this object does not provide a `head` method");
			}
		} else {
			throw("Invalid data type for `head` - please provide one of the following [array,struct,query,list or object that defines a head method]");
		}
	}

	//tail


	function _arrayTail (required array data) {
		var dataLen = arrayLen(data);
		if (dataLen > 1) {
			return arraySlice(data, 2, dataLen-1);
		}
		return [];
	}

	function _queryTailToArray (required query data) {
		var dataLen = data.recordCount;
		var dataArray = _queryMapToArray(data, function(row) { return row; });
		return _arrayTail(dataArray);
	}

	function _queryTail (required query data) {
		return queryFunctionHelper(data, '', _queryTailToArray);
	}

	function _listTail (required string data, string delimiter = ",", boolean includeEmptyFields = false) {
		var dataArray = _arrayTail(listToArray(data, delimiter, includeEmptyFields));
		return arrayToList(dataArray, delimiter);
	}

	function tail (required any data) {
		if (isArray(data)) {
			return _arrayTail(data);
		} else if (isQuery(data)) {
			return _queryTail(data);
		} else if (isSimpleValue(data)) {
			return _listTail(data);
		} else if (isObject(data)) {
			if (structKeyExists(data, "tail")) {
				return data.tail();
			} else {
				throw("this object does not provide a `tail` method");
			}
		} else {
			throw("Invalid data type for `tail` - please provide one of the following [array,struct,query,list or object that defines a tail method]");
		}
	}

	//last

	//nth

	//NOTE! the value passed to defaultValue will be evaluated, even if the default is not used!
	function defaults (any value, any defaultValue) {
		if (isNull(value)) {
			return defaultValue;
		}
		return value;
	}

	function identity (x) {
		if (isNull(x)) {
			return javacast("null", 0);
		}
		return x;
	}

	function noOp () {

	}

	function pluck (required string key, any data) {
		if (!isNull(data)) {
			return map(function (item) {
				return item[key];
			}, arguments.data);
		} else {
			var keyX = arguments.key;
			return function (required any data) {
				return pluck(keyX, arguments.data);
			};
		}
	}

	function Option () {
		var NIL = "__NIL__";

		var _isNil = function (input) {
			return (isNull(input) || (isSimpleValue(input) && input == Nil));
		};

		var _isSome = false;
		var _val = NIL;

		var m = {
			some: function (val) {
				if (_isNil(val)) {
					throw("value must be non-null");
				}
				_val = arguments.val;
				_isSome = true;
				return m;
			},
			none: function () {
				_isSome = false;
				_val = NIL;
				return m;
			},
			of: function (val) {
				//gotta love coldfusion, cant pass around null values too far
				if (isNull(val) || _isNil(val)) {
					return m.none();
				}
				return m.some(arguments.val);
			},
			isSome: function () {
				return _isSome;
			},
			isNone: function () {
				return !_isSome;
			},
			toString: function () {
				if (_isSome) {
					return 'Some( ' & _val & ' )';
				}
				return 'None()';
			},
			unwrap: function () {
				if (_isSome) {
					return _val;
				}
				throw("Cannot unwrap a none.")
			},
			unwrapOr: function (required other) {
				if (_isSome) {
					return _val;
				}
				return other;
			},
			unwrapOrElse: function (required fn) {
				if(_isSome) {
					return _val;
				}
				return fn();
			},
			map: function (required fn) hint="returns an option" { 
				if (_isSome) {
					return Option().of(fn(_val));
				}
				return Option().none();
			},
			filter: function (required conditionFn) hint="returns an option" {
				if (_isSome) {
					if (conditionFn(_val)) {
						return m;
					}
				}
				return Option().none();
			},
			forEach: function (required fn) hint="for side effects" {
				if (_isSome) {
					fn(_val);
				}
			},
			match: function (struct options = {}) hint="pass a struct with two keys with functions for values, `some` and `none`" {
				if (_isSome) {
					if (!structKeyExists(options, "some")) {
						return m.toString();
					}
					return options.some(_val);	
				} 
				if (!structKeyExists(options, "none")) {
					return m.toString();
				}
				return options.none();
			}
		};

		m.get = m.unwrap;
		m.getOr = m.unwrapOr;
		m.getOrElse = m.unwrapOrElse;
		return m;
    }

	function Result () {

		var _isOk = false;
		var _okVal = "";
		var _errVal = "";

		var r = {
			ok: function (okVal) {
				_isOk = true;
				_okVal = okVal;
				return r;
			},
			err: function (errVal) {
				_isOk = false;
				_errVal = errVal;
				return r;
			},
			isOk: function () {
				return _isOk;
			},
			isErr: function () {
				return !_isOk;
			},
			toString: function () {
				if (_isOk) {
					return "Ok( " & _okVal & " )";
				}
				return "Err( " & _errVal & " )";
			},
			getOk: function () {
				if (_isOk) {
					return Option().some(_okVal);
				}
				return Option().none();
			},
			getErr: function () {
				if (!_isOk) {
					return Option().some(_errVal);
				}
				return Option().none();
			},
			unwrap: function () {
				if (_isOk) {
					return _okVal;
				}
				throw("Called unwrap on a Result.Err");
			},
			unwrapErr: function () {
				if (_isOk) {
					throw("Called unwrapErr on a Result.Ok");
				}
				return _errVal;
			},
			unwrapOr: function (required other) {
				if (_isOk) {
					return _okVal;
				}
				return other;
			},
			unwrapOrElse: function (required fn) {
				if (_isOk) {
					return _okVal;
				}
				return fn(_errVal);
			},
			map: function (required fn) hint="returns a Result" {
				/*
					if isOk, transform the value, otherwise no-op
				*/
				if (_isOk) {
					return Result().ok(fn(_okVal));
				}
				return r;
			},
			mapErr: function (required fn) hint="returns a Result" {
				/*
					if isErr, transform the value, otherwise no-op
				*/
				if (_isOk) {
					return r;
				}
				return Result().err(fn(_errVal));
			},
			match: function (struct options = {}) hint="pass a struct with two keys with functions for values, `ok` and `err`" {
				if (_isOk) {
					if (!structKeyExists(options, "ok")) {
						return r.toString();
					}
					return options.ok(_okVal);
				}
				if (!structKeyExists(options, "err")) {
					return r.toString();
				}
				return options.err(_errVal);
			}
		};

		return r;
	}

}