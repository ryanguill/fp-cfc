component {

	/* NOTE: some of these methods will need to be replaced with native versions if we upgrade CF past 10 */

	/*========================================================
	MAP
	========================================================*/

	/* takes a callback of f(value, index, array) */
	function _arrayMap (required array data, required any f) {
		var output = [];
		var dataLen = arrayLen(data);
		for (var i = 1; i <= dataLen; i++) {
			arrayAppend(output, f(data[i], i, data));
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
		var output = _queryMapToArray(data, f);
		var md = getMetaData(data);
		var columns = arrayToList(_arrayMap(md, function(column) {
			return column.name;
		}), ",");
		var types = arrayToList(_arrayMap(md, function(column) {
			return column.typeName;
		}), ",");
		return queryNew(columns, types, output);
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
			} else if (isStruct(data)) {
				return _structMap(data, f);
			} else if (isQuery(data)) {
				return _queryMap(data, f);
			} else if (isSimpleValue(data)) {
				return _listMap(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "map")) {
					return data.map(f);
				} else {
					throw("this object does not provide a `map` method");
				}
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

	function queryToStruct (required string keyBy, required query data) {
		var output = {};
		for (var row in data) {
			output[row[keyBy]] = row;
		}
		return output;
	}


	/*========================================================
	FILTER
	========================================================*/

	function _arrayFilter (required array data, required any f) {

	}

	function _structFilter (required struct data, required any f) {

	}

	function _queryFilterToArray (required query data, required any f) {

	}

	function _queryFilter (required query data, required any f) {

	}

	function _listFilter (required string data, required any f, string delimiter = ",", boolean includeEmptyFields = false) {

	}

	function filter (required any f, any data) {
		if (!isNull(data)) {
			if (isArray(data)) {
				return _arrayFilter(data, f);
			} else if (isStruct(data)) {
				return _structFilter(data, f);
			} else if (isQuery(data)) {
				return _queryFilter(data, f);
			} else if (isSimpleValue(data)) {
				return _listFilter(data, f);
			} else if (isObject(data)) {
				if (structKeyExists(data, "map")) {
					return data.map(f);
				} else {
					throw("this object does not provide a `map` method");
				}
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
	SOME / ANY
	========================================================*/


	/*========================================================
	EVERY
	========================================================*/


	/*========================================================
	REDUCE
	========================================================*/


	/*========================================================
	MISC
	========================================================*/

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



}