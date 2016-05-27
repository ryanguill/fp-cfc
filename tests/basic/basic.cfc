component extends="testbox.system.BaseSpec" {


	private numeric function unixtime () {
		return createObject("java", "java.lang.System").currentTimeMillis();
	}


	function beforeAll () {
		variables.fp = new com.fp();
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
				var result = fp._arrayFind(data, isThree);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._arrayFind(data, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._arrayFind([], isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayFind(["a"], argCheck)).toBe("a");
			});

			it("provides arrayFind as find", function() {
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
				var result = fp.find(isThree, data);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.find(isSix, data);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.find(isSix, []);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.find(argCheck, ["a"])).toBe("a");
			});

			it("provides _structFind", function() {
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
				var result = fp._structFind(data, isThree);
				expect(result).toBe({c:3});
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var result = fp._structFind(data, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var result = fp._structFind({}, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structFind({a:1}, argCheck)).toBe({a:1});
			});

			it("provides structFind as find", function() {
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
				var result = fp.find(isThree, data);
				expect(result).toBe({c:3});
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var result = fp.find(isSix, data);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var result = fp.find(isSix, {});
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.find(argCheck, {a:1})).toBe({a:1});
			});

			it("provides _queryFind", function() {
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
				var result = fp._queryFind(qFiveRows, isThree);
				expect(result).toBe({a:3,b:"baz"});
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._queryFind(qFiveRows, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._queryFind(qNoRows, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._queryFind(qOneRow, argCheck)).toBe({a:1, b:"foo"});
			});

			it("provides queryFind as find", function() {
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
				var result = fp.find(isThree, qFiveRows);
				expect(result).toBe({a:3,b:"baz"});
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.find(isSix, qFiveRows);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.find(isSix, qNoRows);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.find(argCheck, qOneRow)).toBe({a:1, b:"foo"});
			});

			it("provides _listFind", function() {
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
				var result = fp._listFind(data, isThree);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._listFind(data, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._listFind("", isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listFind("a", argCheck)).toBe("a");
			});

			it("provides listFind as find", function() {
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
				var result = fp.find(isThree, data);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.find(isSix, data);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.find(isSix, "");
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.find(argCheck, "a")).toBe("a");
			});

			it("provides a curried version of find", function() {
				var loopCounter = 0;
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var findThree = fp.find(isThree);
				expect(fp.isCallable(findThree)).toBeTrue();
				expect(findThree([1,2,3,4,5])).toBe("3");
				expect(loopCounter).toBe(3);
			});

			it("find takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.find(function(){}, mock)).toBe("I am find!");
			});

			it("find throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.find(function(){}, mock);
				}).toThrow("", "this object does not provide a `find` method");
			});

		});//find

		describe("FINDINDEX", function() {

			it("provides _arrayFindIndex", function() {
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
				var result = fp._arrayFindIndex(data, isThree);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._arrayFindIndex(data, isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._arrayFindIndex([], isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayFindIndex(["a"], argCheck)).toBe(1);
			});

			it("provides arrayFindIndex as findIndex", function() {
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
				var result = fp.findIndex(isThree, data);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.findIndex(isSix, data);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.findIndex(isSix, []);
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.findIndex(argCheck, ["a"])).toBe(1);
			});

			it("provides _structFindIndex", function() {
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
				var result = fp._structFindIndex(data, isThree);
				expect(result).toBe("c");
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var result = fp._structFindIndex(data, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var result = fp._structFindIndex({}, isSix);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structFindIndex({a:1}, argCheck)).toBe("a");
			});

			it("provides structFindIndex as findIndex", function() {
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
				var result = fp.findIndex(isThree, data);
				expect(result).toBe("c");
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				var loopCounter = 0;
				var result = fp.findIndex(isSix, data);
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBeLTE(5); //cant be guaranteed of order

				//empty
				var loopCounter = 0;
				var result = fp.findIndex(isSix, {});
				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(key, value, wholeStruct) {
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.findIndex(argCheck, {a:1})).toBe("a");
			});

			it("provides _queryFindIndex", function() {
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
				var result = fp._queryFindIndex(qFiveRows, isThree);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._queryFindIndex(qFiveRows, isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._queryFindIndex(qNoRows, isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._queryFindIndex(qOneRow, argCheck)).toBe(1);
			});

			it("provides queryFindIndex as findIndex", function() {
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
				var result = fp.findIndex(isThree, qFiveRows);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.findIndex(isSix, qFiveRows);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.findIndex(isSix, qNoRows);
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.findIndex(argCheck, qOneRow)).toBe(1);
			});

			it("provides _listFindIndex", function() {
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
				var result = fp._listFindIndex(data, isThree);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp._listFindIndex(data, isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp._listFindIndex("", isSix);
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listFindIndex("a", argCheck)).toBe(1);
			});

			it("provides listFindIndex as findIndex", function() {
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
				var result = fp.findIndex(isThree, data);
				expect(result).toBe(3);
				expect(loopCounter).toBe(3);

				var loopCounter = 0;
				var result = fp.findIndex(isSix, data);
				expect(result).toBe(0);
				expect(loopCounter).toBe(5);

				//empty
				var loopCounter = 0;
				var result = fp.findIndex(isSix, "");
				expect(result).toBe(0);
				expect(loopCounter).toBe(0);

				//argCheck
				var argCheck = function(value, index, wholeArray) {
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.findIndex(argCheck, "a")).toBe(1);
			});

			it("provides a curried version of findIndex", function() {
				var loopCounter = 0;
				var isThree = function(x) {
					loopCounter++;
					return x == 3;
				};
				var findIndexThree = fp.findIndex(isThree);
				expect(fp.isCallable(findIndexThree)).toBeTrue();
				expect(findIndexThree([1,2,3,4,5])).toBe(3);
				expect(loopCounter).toBe(3);
			});

			it("findIndex takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.findIndex(function(){}, mock)).toBe("I am findIndex!");
			});

			it("findIndex throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.findIndex(function(){}, mock);
				}).toThrow("", "this object does not provide a `findIndex` method");
			});

		});//findindex

		describe("REDUCE", function() {

			it("provides _arrayReduce", function() {
				var data = [1,2,3,4,5];
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp._arrayReduce(data, join)).toBe("12345");

				//empty
				expect(fp._arrayReduce([], join, "")).toBe("");

				expect(function(){
					fp._arrayReduce([], join);
				}).toThrow("", "Reduce of empty collection with no initial value");


				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayReduce(["a"], argCheck, "initialValue")).toBeTrue();
			});

			it("provides arrayReduce as reduce", function() {
				var data = [1,2,3,4,5];
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp.reduce(join, 0, data)).toBe("12345");

				//empty
				expect(fp.reduce(join, "", [])).toBe("");

				//cant leave off initial value when calling .reduce()

				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.reduce(argCheck, "initialValue", ["a"])).toBeTrue();
			});

			it("provides _structReduce", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var sumValues = function(agg, k, v) {
					return agg + v;
				};
				expect(lcase(fp._structReduce(data, sumValues, 0))).toBe(15);

				//empty
				expect(fp._structReduce({}, sumValues, 0)).toBe(0);

				expect(function(){
					fp._structReduce({}, sumValues);
				}).toThrow("", "Reduce of empty collection with no initial value");


				var argCheck = function(acc, key, value, wholeStruct) {
					expect(acc).toBe("initialValue");
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structReduce({a:1}, argCheck, "initialValue")).toBeTrue();
			});

			it("provides structReduce as reduce", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var sumValues = function(agg, k, v) {
					return agg + v;
				};
				expect(lcase(fp.reduce(sumValues, 0, data))).toBe(15);

				//empty
				expect(fp.reduce(sumValues, 0, {})).toBe(0);

				//cant leave off initial value when calling .reduce()

				var argCheck = function(acc, key, value, wholeStruct) {
					expect(acc).toBe("initialValue");
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.reduce(argCheck, "initialValue", {a:1})).toBeTrue();
			});

			it("provides _queryReduce", function() {
				var join = function(agg, row) {
					return agg & row.b;
				};
				expect(fp._queryReduce(qThreeRows, join, "")).toBe("foobarbaz");

				//empty
				expect(fp._queryReduce(qNoRows, join, "")).toBe("");

				expect(function(){
					fp._queryReduce(qNoRows, join);
				}).toThrow("", "Reduce of empty collection with no initial value");

				var argCheck = function(acc, row, index, wholeQuery) {
					expect(acc).toBe("initialValue");
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._queryReduce(qOneRow, argCheck, "initialValue")).toBeTrue();
			});

			it("provides queryReduce as reduce", function() {
				var join = function(agg, row) {
					return agg & row.b;
				};
				expect(fp.reduce(join, "", qThreeRows)).toBe("foobarbaz");

				//empty
				expect(fp.reduce(join, "", qNoRows)).toBe("");

				//cant leave off initial value when calling .reduce()

				var argCheck = function(acc, row, index, wholeQuery) {
					expect(acc).toBe("initialValue");
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.reduce(argCheck, "initialValue", qOneRow)).toBeTrue();
			});

			it("provides _listReduce", function() {
				var data = "1,2,3,4,5";
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp._listReduce(data, join)).toBe("12345");

				//empty
				expect(fp._listReduce("", join, "")).toBe("");

				expect(function(){
					fp._listReduce("", join);
				}).toThrow("", "Reduce of empty collection with no initial value");


				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listReduce("a", argCheck, "initialValue")).toBeTrue();
			});

			it("provides listReduce as reduce", function() {
				var data = "1,2,3,4,5";
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp.reduce(join, "", data)).toBe("12345");

				//empty
				expect(fp.reduce(join, "", "")).toBe("");

				//cant leave off initial value when calling .reduce()

				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.reduce(argCheck, "initialValue", "a")).toBeTrue();
			});

			it("provides a curried version of reduce", function() {
				var join = function(agg, x) {
					return agg & x;
				};
				var concat = fp.reduce(join, "");
				expect(fp.isCallable(concat)).toBeTrue();
				expect(concat([1,2,3,4,5])).toBe("12345");
			});

			it("reduce takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.reduce(function(){}, "", mock)).toBe("I am reduce!");
			});

			it("reduce throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.reduce(function(){}, "", mock);
				}).toThrow("", "this object does not provide a `reduce` method");
			});

		});//reduce

		describe("REDUCERIGHT", function() {

			it("provides _arrayReduceRight", function() {
				var data = [1,2,3,4,5];
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp._arrayReduceRight(data, join)).toBe("54321");

				//empty
				expect(fp._arrayReduceRight([], join, "")).toBe("");

				expect(function(){
					fp._arrayReduceRight([], join);
				}).toThrow("", "ReduceRight of empty collection with no initial value");


				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._arrayReduceRight(["a"], argCheck, "initialValue")).toBeTrue();
			});

			it("provides arrayReduceRight as reduceRight", function() {
				var data = [1,2,3,4,5];
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp.reduceRight(join, 0, data)).toBe("54321");

				//empty
				expect(fp.reduceRight(join, "", [])).toBe("");

				//cant leave off initial value when calling .reduceRight()

				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.reduceRight(argCheck, "initialValue", ["a"])).toBeTrue();
			});

			it("provides _structReduceRight", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var sumValues = function(agg, k, v) {
					return agg + v;
				};
				expect(lcase(fp._structReduceRight(data, sumValues, 0))).toBe(15);

				//empty
				expect(fp._structReduceRight({}, sumValues, 0)).toBe(0);

				expect(function(){
					fp._structReduceRight({}, sumValues);
				}).toThrow("", "ReduceRight of empty collection with no initial value");


				var argCheck = function(acc, key, value, wholeStruct) {
					expect(acc).toBe("initialValue");
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp._structReduceRight({a:1}, argCheck, "initialValue")).toBeTrue();
			});

			it("provides structReduceRight as reduceRight", function() {
				var data = {a:1, b:2, c:3, d:4, e:5};
				var sumValues = function(agg, k, v) {
					return agg + v;
				};
				expect(lcase(fp.reduceRight(sumValues, 0, data))).toBe(15);

				//empty
				expect(fp.reduceRight(sumValues, 0, {})).toBe(0);

				//cant leave off initial value when calling .reduceRight()

				var argCheck = function(acc, key, value, wholeStruct) {
					expect(acc).toBe("initialValue");
					expect(key).toBe("a");
					expect(value).toBe(1);
					expect(wholeStruct).toBe({a:1});
					return true;
				};

				expect(fp.reduceRight(argCheck, "initialValue", {a:1})).toBeTrue();
			});

			it("provides _queryReduceRight", function() {
				var join = function(agg, row) {
					return agg & row.b;
				};
				expect(fp._queryReduceRight(qThreeRows, join, "")).toBe("bazbarfoo");

				//empty
				expect(fp._queryReduceRight(qNoRows, join, "")).toBe("");

				expect(function(){
					fp._queryReduceRight(qNoRows, join);
				}).toThrow("", "ReduceRight of empty collection with no initial value");

				var argCheck = function(acc, row, index, wholeQuery) {
					expect(acc).toBe("initialValue");
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp._queryReduceRight(qOneRow, argCheck, "initialValue")).toBeTrue();
			});

			it("provides queryReduceRight as reduceRight", function() {
				var join = function(agg, row) {
					return agg & row.b;
				};
				expect(fp.reduceRight(join, "", qThreeRows)).toBe("bazbarfoo");

				//empty
				expect(fp.reduceRight(join, "", qNoRows)).toBe("");

				//cant leave off initial value when calling .reduceRight()

				var argCheck = function(acc, row, index, wholeQuery) {
					expect(acc).toBe("initialValue");
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return true;
				};

				expect(fp.reduceRight(argCheck, "initialValue", qOneRow)).toBeTrue();
			});

			it("provides _listReduceRight", function() {
				var data = "1,2,3,4,5";
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp._listReduceRight(data, join)).toBe("54321");

				//empty
				expect(fp._listReduceRight("", join, "")).toBe("");

				expect(function(){
					fp._listReduceRight("", join);
				}).toThrow("", "ReduceRight of empty collection with no initial value");


				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp._listReduceRight("a", argCheck, "initialValue")).toBeTrue();
			});

			it("provides listReduceRight as reduceRight", function() {
				var data = "1,2,3,4,5";
				var join = function(agg, x) {
					return agg & x;
				};
				expect(fp.reduceRight(join, "", data)).toBe("54321");

				//empty
				expect(fp.reduceRight(join, "", "")).toBe("");

				//cant leave off initial value when calling .reduceRight()

				var argCheck = function(acc, value, index, wholeArray) {
					expect(acc).toBe("initialValue");
					expect(value).toBe("a");
					expect(index).toBe(1);
					expect(wholeArray).toBe(["a"]);
					return true;
				};

				expect(fp.reduceRight(argCheck, "initialValue", "a")).toBeTrue();
			});

			it("provides a curried version of reduceRight", function() {
				var join = function(agg, x) {
					return agg & x;
				};
				var concat = fp.reduceRight(join, "");
				expect(fp.isCallable(concat)).toBeTrue();
				expect(concat([1,2,3,4,5])).toBe("54321");
			});

			it("reduceRight takes objects", function() {
				var mock = new tests.com.mockObject();
				expect(fp.reduceRight(function(){}, "", mock)).toBe("I am reduceRight!");
			});

			it("reduceRight throws appropriate errors", function() {
				var mock = new tests.com.emptyMockObject();
				expect(function() {
					fp.reduceRight(function(){}, "", mock);
				}).toThrow("", "this object does not provide a `reduceRight` method");
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

			it("provides _arrayTail", function() {
				var data = [1,2,3];
				var tail = fp._arrayTail(data);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe([2,3]);

				tail = fp._arrayTail([]);
				expect(tail).toBeEmpty();

				tail = fp._arrayTail([1]);
				expect(tail).toBeEmpty();
			});

			it("provides _queryTail", function() {
				var tail = fp._queryTail(qThreeRows);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"bar"}, {a:3, b:"baz"}]));

				tail = fp._queryTail(qNoRows);
				expect(tail).toBe(qNoRows);

				tail = fp._queryTail(qOneRow);
				expect(tail).toBe(qNoRows);
			});

			it("provides _listTail", function() {
				var data = "1,2,3";
				var tail = fp._listTail(data);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe("2,3");

				tail = fp._listTail("");
				expect(tail).toBeEmpty();

				tail = fp._listTail("1");
				expect(tail).toBeEmpty();
			});

			it("provides arrayTail through tail", function() {
				var data = [1,2,3];
				var tail = fp.tail(data);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe([2,3]);

				tail = fp.tail([]);
				expect(tail).toBeArray().toBeEmpty();

				tail = fp.tail([1]);
				expect(tail).toBeArray().toBeEmpty();
			});

			it("provides queryTail through tail", function() {
				var tail = fp.tail(qThreeRows);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"bar"}, {a:3, b:"baz"}]));

				tail = fp.tail(qNoRows);
				expect(tail).toBe(qNoRows);

				tail = fp.tail(qOneRow);
				expect(tail).toBe(qNoRows);
			});

			it("provides listTail through tail", function() {
				var data = "1,2,3";
				var tail = fp.tail(data);
				expect(isNull(tail)).toBeFalse();
				expect(tail).toBe("2,3");

				tail = fp.tail("");
				expect(tail).toBeEmpty();

				tail = fp.tail("1");
				expect(tail).toBeEmpty();
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

			it("provides identity", function() {
				expect(fp.identity(1)).toBe(1);
				expect(fp.identity("1")).toBe("1");
				expect(fp.identity("foobar")).toBe("foobar");
				expect(fp.identity([])).toBe([]);
				expect(fp.identity({a:1})).toBe({a:1});
				expect(fp.identity(javacast("null", 0))).toBeNull();
				expect(fp.identity(fp.noOp)).toBe(fp.noOp);
			});

			it("provides noOp", function() {
				expect(fp.noOp()).toBeNull();
				expect(fp.isCallable(fp.noOp)).toBeTrue();
			});

		});//misc


	}



}