component extends="testbox.system.BaseSpec" {


	private numeric function unixtime () {
		return createObject("java", "java.lang.System").currentTimeMillis();
	}


	function beforeAll () {
		variables.fp = new com.FPUtil();
	}

	function afterAll () {

	}

	function run () {

		var qNoRows = queryNew("a,b", "integer,varchar");
		var qOneRow = queryNew("a,b", "integer,varchar",
				[{a:1, b:"foo"}]);
		var qTwoRows = queryNew("a,b", "integer,varchar",
				[{a:1, b:"foo"}, {a:2, b:"bar"}]);
		var qThreeRows = queryNew("a,b", "integer,varchar",
				[{a:1, b:"foo"}, {a:2, b:"bar"}, {a:3, b:"baz"}]);
		var qFiveRows = queryNew("a,b", "integer,varchar",[
				{a:1, b:"foo"},
				{a:2, b:"bar"},
				{a:3, b:"baz"},
				{a:4, b:"lorem"},
				{a:5, b:"ipsum"}
				]);

		describe("baseline environment", function () {

			it("should have created the fp object", function() {
				expect(fp).toBeTypeOf("component");
			});

		});

		describe("MAP", function() {

			it("provides _arrayMap", function() {
				var data = [1,2,3,4,5];
				var double = function (x) { return x * 2; };
				var result = fp._arrayMap(data, double);

				expect(result).toBe([2,4,6,8,10]);

				result = fp._arrayMap([], double);

				expect(result).toBe([], "empty in, empty out");

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return "b";
				};

				result = fp._arrayMap(["a"], argCheck);

				expect(result).toBe(["b"]);
			});

			it("provides arrayMap through map", function() {
				var data = [1,2,3,4,5];
				var double = function (x) { return x * 2; };
				var result = fp.map(double, data);

				expect(result).toBe([2,4,6,8,10]);

				result = fp.map(double, []);

				expect(result).toBe([], "empty in, empty out");

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return "b";
				};

				result = fp.map(argCheck, ["a"]);

				expect(result).toBe(["b"]);
			});

			it("provides _structMap", function() {
				var data = {a:1, b:2, c:3};
				var double = function (k, x) { return x * 2; };
				var result = fp._structMap(data, double);

				expect(result).toBe({a:2, b:4, c:6});

				result = fp._structMap({}, double);

				expect(result).toBe({}, "empty in, empty out");

				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return 2;
				};

				result = fp._structMap({a:1}, argCheck);

				expect(result).toBe({a:2});
			});

			it("provides structMap through map", function() {
				var data = {a:1, b:2, c:3};
				var double = function (k, x) { return x * 2; };
				var result = fp.map(double, data);

				expect(result).toBe({a:2, b:4, c:6});

				result = fp.map(double, {});

				expect(result).toBe({}, "empty in, empty out");

				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return 2;
				};

				result = fp.map(argCheck, {a:1});

				expect(result).toBe({a:2});
			});

			it("provides _queryMap", function() {
				var double = function (row) {
					row.a *= 2;
					row.b = row.b & row.b;
					return row;
				};
				var result = fp._queryMap(qTwoRows, double);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"foofoo"}, {a:4, b:"barbar"}]));

				result = fp._queryMap(qNoRows, double);

				expect(result).toBe(qNoRows, "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return row;
				};

				result = fp._queryMap(qOneRow, argCheck);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));
			});

			it("provides queryMap through map", function() {
				var double = function (row) {
					row.a *= 2;
					row.b = row.b & row.b;
					return row;
				};
				var result = fp.map(double, qTwoRows);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"foofoo"}, {a:4, b:"barbar"}]));

				result = fp.map(double, qNoRows);

				expect(result).toBe(qNoRows, "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return row;
				};

				result = fp.map(argCheck, qOneRow);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));
			});

			it("provides _listMap", function() {
				var data = "1,2,3,4,5";
				var double = function (x) { return x * 2; };
				var result = fp._listMap(data, double);

				expect(result).toBe("2,4,6,8,10");

				result = fp._listMap("", double);

				expect(result).toBe("", "empty in, empty out");

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return "b";
				};

				result = fp._listMap("a", argCheck);

				expect(result).toBe("b");
			});

			it("provides listMap through map", function() {
				var data = "1,2,3,4,5";
				var double = function (x) { return x * 2; };
				var result = fp.map(double, data);

				expect(result).toBe("2,4,6,8,10");

				result = fp.map(double, "");

				expect(result).toBe("", "empty in, empty out");

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return "b";
				};

				result = fp.map(argCheck, "a");

				expect(result).toBe("b");
			});

			it("provides a curried version of map", function() {

				var double = function (x) { return x * 2; };
				var mapDouble = fp.map(double);

				expect(fp.isCallable(mapDouble)).toBeTrue();

				expect(mapDouble([1,2,3])).toBe([2,4,6]);
			});

			it("map takes objects", function() {
				var mock = new tests.com.mockObject();

				expect(fp.map(function(){}, mock)).toBe("I am map!");
			});

			it("map throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.map(function(){}, mock);
				}).toThrow("", "this object does not provide a `map` method");
			});

		});

		describe("EACH", function() {

			it("provides _arrayEach", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp._arrayEach([1,2,3], f);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp._arrayEach([], f);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					loopCounter++;
				};

				result = fp._arrayEach(["a"], argCheck);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);

			});

			it("provides arrayEach through each", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp.each(f, [1,2,3]);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp.each(f, []);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					loopCounter++;
				};

				result = fp.each(argCheck, ["a"]);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);

			});

			it("provides _structEach", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp._structEach({a:1, b:2, c:3}, f);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp._structEach({}, f);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					loopCounter++;
				};

				result = fp._structEach({a:1}, argCheck);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);
			});

			it("provides structEach through each", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp.each(f, {a:1, b:2, c:3});
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp.each(f, {});
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					loopCounter++;
				};

				result = fp.each(argCheck, {a:1});

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);
			});

			it("provides _queryEach", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp._queryEach(qThreeRows, f);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp._queryEach(qNoRows, f);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					loopCounter++;
				};

				result = fp._queryEach(qOneRow, argCheck);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);
			});

			it("provides queryEach through each", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp.each(f, qThreeRows);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp.each(f, qNoRows);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					loopCounter++;
				};

				result = fp.each(argCheck, qOneRow);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);
			});

			it("provides _listEach", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp._listEach("1,2,3", f);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp._listEach("", f);
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					loopCounter++;
				};

				result = fp._listEach("a", argCheck);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);

			});

			it("provides listEach through each", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp.each(f, "1,2,3");
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp.each(f, "");
				expect(loopCounter).toBe(0);

				//arg check
				loopCounter = 0;
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					loopCounter++;
				};

				result = fp.each(argCheck, "a");

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);

			});
			
			it("provides a curried version of each", function() {
				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				var eachf = fp.each(f);
				expect(fp.isCallable(eachf)).toBeTrue();

				var result = eachf([1,2,3]);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(3);
			});

			it("each takes objects", function() {
				var mock = new tests.com.mockObject();

				expect(fp.each(function(){}, mock)).toBe("I am each!");
			});

			it("each throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.each(function(){}, mock);
				}).toThrow("", "this object does not provide an `each` method");
			});

		});//each

		describe("FILTER", function() {

			it("provides _arrayFilter", function() {
				var data = [1,2,3,4,5,6,7,8,9,10];
				var isOdd = function(x) {
					return x MOD 2 != 0;
				};
				expect(fp._arrayFilter(data, isOdd)).toBe([1,3,5,7,9]);

				expect(fp._arrayFilter([], isOdd)).toBeArray().toHaveLength(0);

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayFilter(["a"], argCheck)).toBeArray().toHaveLength(1);
			});

			it("provides arrayFilter as filter", function() {
				var data = [1,2,3,4,5,6,7,8,9,10];
				var isOdd = function(x) {
					return x MOD 2 != 0;
				};
				expect(fp.filter(isOdd, data)).toBe([1,3,5,7,9]);

				expect(fp.filter(isOdd, [])).toBeArray().toHaveLength(0);

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.filter(argCheck, ["a"])).toBeArray().toHaveLength(1);
			});

			it("provides _structFilter", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var isOdd = function (k, v) { return v MOD 2 == 1; };
				var result = fp._structFilter(data, isOdd);

				expect(result).toBe({a:1, c:3, e:5});

				result = fp._structFilter({}, isOdd);

				expect(result).toBe({}, "empty in, empty out");

				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				result = fp._structFilter({a:1}, argCheck);

				expect(result).toBe({a:1});
			});

			it("provides structFilter as filter", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var isOdd = function (k, v) { return v MOD 2 == 1; };
				var result = fp.filter(isOdd, data);

				expect(result).toBe({a:1, c:3, e:5});

				result = fp.filter(isOdd, {});

				expect(result).toBe({}, "empty in, empty out");

				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				result = fp.filter(argCheck, {a:1});

				expect(result).toBe({a:1});
			});

			it("provides _queryFilter", function() {
				var isOdd = function (row) {
					return row.a MOD 2 == 1;
				};
				var result = fp._queryFilter(qTwoRows, isOdd);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));

				result = fp._queryFilter(qNoRows, isOdd);

				expect(result).toBe(qNoRows, "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				result = fp._queryFilter(qOneRow, argCheck);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));
			});

			it("provides queryFilter as filter", function() {
				var isOdd = function (row) {
					return row.a MOD 2 == 1;
				};
				var result = fp.filter(isOdd, qTwoRows);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));

				result = fp.filter(isOdd, qNoRows);

				expect(result).toBe(qNoRows, "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				result = fp.filter(argCheck, qOneRow);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));
			});

			it("provides _listFilter", function() {
				var data = "1,2,3,4,5,6,7,8,9,10";
				var isOdd = function(x) {
					return x MOD 2 != 0;
				};
				expect(fp._listFilter(data, isOdd)).toBe("1,3,5,7,9");

				expect(fp._listFilter("", isOdd)).toBeString().toHaveLength(0);

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listFilter("a", argCheck)).toBeString().toHaveLength(1);
			});

			it("provides listFilter as filter", function() {
				var data = "1,2,3,4,5,6,7,8,9,10";
				var isOdd = function(x) {
					return x MOD 2 != 0;
				};
				expect(fp.filter(isOdd, data)).toBe("1,3,5,7,9");

				expect(fp.filter(isOdd, "")).toBeString().toHaveLength(0);

				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.filter(argCheck, "a")).toBeString().toHaveLength(1);
			});
			
			it("provides a curried version of filter", function() {
				var isOdd = function (x) { return x MOD 2 != 0;};
				var filterOdd = fp.filter(isOdd);

				expect(fp.isCallable(filterOdd)).toBeTrue();
				expect(filterOdd([1,2,3,4,5])).toBe([1,3,5]);
			});

			it("filter takes objects", function() {
				var mock = new tests.com.mockObject();

				expect(fp.filter(function(){}, mock)).toBe("I am filter!");
			});

			it("filter throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.filter(function(){}, mock);
				}).toThrow("", "this object does not provide a `filter` method");
			});


		});//filter

		describe("SOME", function() {

			it("provides _arraySome", function() {
				var loopCounter = 0;
				var data = [1,2,3,4,5];
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var isSix = function(x) {
					loopCounter++;
					return x == 6;
				};

				var loopCounter = 0;
				var hasThree = fp._arraySome(data, isThree);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp._arraySome(data, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp._arraySome([], isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arraySome(["a"], argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides arraySome as some", function() {
				var loopCounter = 0;
				var data = [1,2,3,4,5];
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var isSix = function(x) {
					loopCounter++;
					return x == 6;
				};

				var loopCounter = 0;
				var hasThree = fp.some(isThree, data);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp.some(isSix, data);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp.some(isSix, []);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.some(argCheck, ["a"])).toBeBoolean().toBeTrue();
			});

			it("provides _structSome", function() {
				var loopCounter = 0;
				var data = {a:1, b:2, c:3, d:4, e:5};
				var isThree = function(k, v) {
					loopCounter++;
					return v == 3;
				};
				var isSix = function(k, v) {
					loopCounter++;
					return v == 6;
				};

				var loopCounter = 0;
				var hasThree = fp._structSome(data, isThree);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var hasSix = fp._structSome(data, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var hasSix = fp._structSome({}, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structSome({a:1}, argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides structSome as some", function() {
				var loopCounter = 0;
				var data = {a:1, b:2, c:3, d:4, e:5};
				var isThree = function(k, v) {
					loopCounter++;
					return v == 3;
				};
				var isSix = function(k, v) {
					loopCounter++;
					return v == 6;
				};

				var loopCounter = 0;
				var hasThree = fp.some(isThree, data);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var hasSix = fp.some(isSix, data);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var hasSix = fp.some(isSix, {});
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.some(argCheck, {a:1})).toBeBoolean().toBeTrue();
			});

			it("provides _querySome", function() {
				var loopCounter = 0;
				var isThree = function(row) {
					loopCounter++;
					return row.a == 3;
				};
				var isSix = function(row) {
					loopCounter++;
					return row.a == 6;
				};

				var loopCounter = 0;
				var hasThree = fp._querySome(qFiveRows, isThree);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp._querySome(qFiveRows, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp._querySome(qNoRows, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._querySome(qOneRow, argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides querySome as some", function() {
				var loopCounter = 0;
				var isThree = function(row) {
					loopCounter++;
					return row.a == 3;
				};
				var isSix = function(row) {
					loopCounter++;
					return row.a == 6;
				};

				var loopCounter = 0;
				var hasThree = fp.some(isThree, qFiveRows);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp.some(isSix, qFiveRows);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp.some(isSix, qNoRows);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.some(argCheck, qOneRow)).toBeBoolean().toBeTrue();
			});

			it("provides _listSome", function() {
				var loopCounter = 0;
				var data = "1,2,3,4,5";
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var isSix = function(x) {
					loopCounter++;
					return x == 6;
				};

				var loopCounter = 0;
				var hasThree = fp._listSome(data, isThree);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp._listSome(data, isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp._listSome("", isSix);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listSome("a", argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides listSome as some", function() {
				var loopCounter = 0;
				var data = "1,2,3,4,5";
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var isSix = function(x) {
					loopCounter++;
					return x == 6;
				};

				var loopCounter = 0;
				var hasThree = fp.some(isThree, data);
				expect(hasThree).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var hasSix = fp.some(isSix, data);
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var hasSix = fp.some(isSix, "");
				expect(hasSix).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.some(argCheck, "a")).toBeBoolean().toBeTrue();
			});

			it("provides a curried version of some", function() {
				var loopCounter = 0;
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var hasThree = fp.some(isThree);
				expect(fp.isCallable(hasThree)).toBeTrue();
				expect(hasThree([1,2,3,4,5])).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(3);
			});

			it("some takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.some(function(){}, mock)).toBe("I am some!");
			});

			it("some throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.some(function(){}, mock);
				}).toThrow("", "this object does not provide a `some` method");
			});

		});//some

		describe("EVERY", function() {

			it("provides _arrayEvery", function() {
				var loopCounter = 0;
				var data = [1,2,3,4,5];
				var willPass = function(x) {
					loopCounter++;
					return x < 10;
				};
				var willFail = function(x) {
					loopCounter++;
					return x < 0;
				};

				var loopCounter = 0;
				var didPass = fp._arrayEvery(data, willPass);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp._arrayEvery(data, willFail);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp._arrayEvery([], fp.noOp);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayEvery(["a"], argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides arrayEvery as every", function() {
				var loopCounter = 0;
				var data = [1,2,3,4,5];
				var willPass = function(x) {
					loopCounter++;
					return x < 10;
				};
				var willFail = function(x) {
					loopCounter++;
					return x < 0;
				};

				var loopCounter = 0;
				var didPass = fp.every(willPass, data);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp.every(willFail, data);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp.every(fp.noOp, []);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.every(argCheck, ["a"])).toBeBoolean().toBeTrue();
			});

			it("provides _structEvery", function() {
				var loopCounter = 0;
				var data = {a:1, b:2, c:3, d:4, e:5};
				var willPass = function(k, v) {
					loopCounter++;
					return v < 10;
				};
				var willFail = function(k, v) {
					loopCounter++;
					return v < 0;
				};

				var loopCounter = 0;
				var didPass = fp._structEvery(data, willPass);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var didFail = fp._structEvery(data, willFail);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp._structEvery({}, fp.noOp);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structEvery({a:1}, argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides structEvery as every", function() {
				var loopCounter = 0;
				var data = {a:1, b:2, c:3, d:4, e:5};
				var willPass = function(k, v) {
					loopCounter++;
					return v < 10;
				};
				var willFail = function(k, v) {
					loopCounter++;
					return v < 0;
				};

				var loopCounter = 0;
				var didPass = fp.every(willPass, data);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var didFail = fp.every(willFail, data);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp.every(fp.noOp, {});
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.every(argCheck, {a:1})).toBeBoolean().toBeTrue();
			});

			it("provides _queryEvery", function() {
				var loopCounter = 0;
				var willPass = function(row) {
					loopCounter++;
					return row.a < 10;
				};
				var willFail = function(row) {
					loopCounter++;
					return row.a < 0;
				};

				var loopCounter = 0;
				var didPass = fp._queryEvery(qFiveRows, willPass);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp._queryEvery(qFiveRows, willFail);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp._queryEvery(qNoRows, fp.noOp);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._queryEvery(qOneRow, argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides queryEvery as every", function() {
				var loopCounter = 0;
				var willPass = function(row) {
					loopCounter++;
					return row.a < 10;
				};
				var willFail = function(row) {
					loopCounter++;
					return row.a < 0;
				};

				var loopCounter = 0;
				var didPass = fp.every(willPass, qFiveRows);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp.every(willFail, qFiveRows);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp.every(fp.noOp, qNoRows);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.every(argCheck, qOneRow)).toBeBoolean().toBeTrue();
			});

			it("provides _listEvery", function() {
				var loopCounter = 0;
				var data = "1,2,3,4,5";
				var willPass = function(x) {
					loopCounter++;
					return x < 10;
				};
				var willFail = function(x) {
					loopCounter++;
					return x < 1;
				};

				var loopCounter = 0;
				var didPass = fp._listEvery(data, willPass);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp._listEvery(data, willFail);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp._listEvery("", fp.noOp);
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listEvery("a", argCheck)).toBeBoolean().toBeTrue();
			});

			it("provides listEvery as every", function() {
				var loopCounter = 0;
				var data = "1,2,3,4,5";
				var willPass = function(x) {
					loopCounter++;
					return x < 10;
				};
				var willFail = function(x) {
					loopCounter++;
					return x < 1;
				};

				var loopCounter = 0;
				var didPass = fp.every(willPass, data);
				expect(didPass).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);

				var loopCounter = 0;
				var didFail = fp.every(willFail, data);
				expect(didFail).toBeBoolean().toBeFalse();
				expect(loopCounter).toBe(1);

				//empty
				var loopCounter = 0;
				var emptyCollectionResult = fp.every(fp.noOp, "");
				expect(emptyCollectionResult).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.every(argCheck, "a")).toBeBoolean().toBeTrue();
			});

			it("provides a curried version of every", function() {
				var loopCounter = 0;
				var willPass = function(x) {
					loopCounter++;
					return x < 10;
				};
				var doesAllPass = fp.every(willPass);
				expect(fp.isCallable(doesAllPass)).toBeTrue();
				expect(doesAllPass([1,2,3,4,5])).toBeBoolean().toBeTrue();
				expect(loopCounter).toBe(5);
			});

			it("every takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.every(function(){}, mock)).toBe("I am every!");
			});

			it("every throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.every(function(){}, mock);
				}).toThrow("", "this object does not provide an `every` method");
			});

		});//every

		describe("FIND", function() {

			it("provides _arrayFind", function() {
				fail("NotYetImplemented");
			});

			it("provides arrayFind as find", function() {
				fail("NotYetImplemented");
			});

			it("provides _structFind", function() {
				fail("NotYetImplemented");
			});

			it("provides structFind as find", function() {
				fail("NotYetImplemented");
			});

			it("provides _queryFind", function() {
				fail("NotYetImplemented");
			});

			it("provides queryFind as find", function() {
				fail("NotYetImplemented");
			});

			it("provides _listFind", function() {
				fail("NotYetImplemented");
			});

			it("provides listFind as find", function() {
				fail("NotYetImplemented");
			});

			it("provides a curried version of find", function() {
				fail("NotYetImplemented");
			});

			it("find takes objects", function() {
				fail("NotYetImplemented");
			});

			it("find throws appropriate errors", function() {
				fail("NotYetImplemented");
			});

		});//find

		describe("FINDINDEX", function() {

			it("provides _arrayFindIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides arrayFindIndex as findIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides _structFindIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides structFindIndex as findIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides _queryFindIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides queryFindIndex as findIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides _listFindIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides listFindIndex as findIndex", function() {
				fail("NotYetImplemented");
			});

			it("provides a curried version of findIndex", function() {
				fail("NotYetImplemented");
			});

			it("findIndex takes objects", function() {
				fail("NotYetImplemented");
			});

			it("findIndex throws appropriate errors", function() {
				fail("NotYetImplemented");
			});

		});//findindex

		describe("REDUCE", function() {

			it("provides _arrayReduce", function() {
				fail("NotYetImplemented");
			});

			it("provides arrayReduce as reduce", function() {
				fail("NotYetImplemented");
			});

			it("provides _structReduce", function() {
				fail("NotYetImplemented");
			});

			it("provides structReduce as reduce", function() {
				fail("NotYetImplemented");
			});

			it("provides _queryReduce", function() {
				fail("NotYetImplemented");
			});

			it("provides queryReduce as reduce", function() {
				fail("NotYetImplemented");
			});

			it("provides _listReduce", function() {
				fail("NotYetImplemented");
			});

			it("provides listReduce as reduce", function() {
				fail("NotYetImplemented");
			});

			it("provides a curried version of reduce", function() {
				fail("NotYetImplemented");
			});

			it("reduce takes objects", function() {
				fail("NotYetImplemented");
			});

			it("reduce throws appropriate errors", function() {
				fail("NotYetImplemented");
			});

		});//reduce

		describe("REDUCERIGHT", function() {
			
			it("provides _arrayReduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides arrayReduceRight as reduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides _structReduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides structReduceRight as reduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides _queryReduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides queryReduceRight as reduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides _listReduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides listReduceRight as reduceRight", function() {
				fail("NotYetImplemented");
			});

			it("provides a curried version of reduceRight", function() {
				fail("NotYetImplemented");
			});

			it("reduceRight takes objects", function() {
				fail("NotYetImplemented");
			});

			it("reduceRight throws appropriate errors", function() {
				fail("NotYetImplemented");
			});
			
		});//reduceright

		describe("MISC", function() {

			it("provides _arrayHead", function() {
				var data = [1,2,3];
				var head = fp._arrayHead(data);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(1);

				head = fp._arrayHead([]);
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp._arrayHead([]), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides _queryHead", function() {
				var head = fp._queryHead(qThreeRows);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe({a:1, b:"foo"});

				head = fp._queryHead(qNoRows);
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp._queryHead(qNoRows), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides _listHead", function() {
				var data = "1,2,3";
				var head = fp._listHead(data);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(1);

				head = fp._listHead("");
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp._listHead(""), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides arrayHead through head", function() {
				var data = [1,2,3];
				var head = fp.head(data);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(1);

				head = fp.head([]);
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp.head([]), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides queryHead through head", function() {
				var head = fp.head(qThreeRows);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe({a:1, b:"foo"});

				head = fp.head(qNoRows);
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp.head(qNoRows), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides listHead through head", function() {
				var data = "1,2,3";
				var head = fp.head(data);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(1);

				head = fp.head("");
				expect(isNull(head)).toBeTrue();

				head = fp.defaults(fp.head(""), 0);
				expect(isNull(head)).toBeFalse();
				expect(head).toBe(0);
			});

			it("provides defaults()", function() {
				var f = function() {
					//no return;
				};
				expect(fp.defaults(javacast("null", 0), 0)).toBe(0);
				expect(fp.defaults(f(), 0)).toBe(0);
				expect(fp.defaults(1, 0)).toBe(1);
			});

			it("provides times", function() {
				var loopCount = 0;
				var sum = 0;
				var f = function(x) {
					loopCount++;
					sum += x;
				};

				fp.times(f, 5);

				expect(loopCount).toBe(5);
				expect(sum).toBe(15);

				loopCount = sum = 0;

				var t = fp.times(f);
				t(3);

				expect(loopCount).toBe(3);
				expect(sum).toBe(6);
			});

			it("provides queryToStruct", function() {
				var x = fp.queryToStruct("a", qThreeRows);
				expect(x).toBeStruct().toHaveLength(3);
				expect(x["1"]).toBeStruct().toHaveLength(2).toBe({a:1, b:"foo"});
				expect(x["2"]).toBeStruct().toHaveLength(2).toBe({a:2, b:"bar"});
				expect(x["3"]).toBeStruct().toHaveLength(2).toBe({a:3, b:"baz"});

				x = fp.queryToStruct("b", qThreeRows);
				expect(x).toBeStruct().toHaveLength(3);
				expect(x["foo"]).toBeStruct().toHaveLength(2).toBe({a:1, b:"foo"});
				expect(x["bar"]).toBeStruct().toHaveLength(2).toBe({a:2, b:"bar"});
				expect(x["baz"]).toBeStruct().toHaveLength(2).toBe({a:3, b:"baz"});
			});

		});//misc


	}



}