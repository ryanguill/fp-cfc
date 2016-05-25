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
				var data = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}]);
				var double = function (row) {
					row.a *= 2;
					row.b = row.b & row.b;
					return row;
				};
				var result = fp._queryMap(data, double);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"foofoo"}, {a:4, b:"barbar"}]));

				result = fp._queryMap(queryNew("a,b", "integer,varchar"), double);

				expect(result).toBe(queryNew("a,b", "integer,varchar"), "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return row;
				};

				result = fp._queryMap(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]), argCheck);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));
			});

			it("provides queryMap through map", function() {
				var data = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}]);
				var double = function (row) {
					row.a *= 2;
					row.b = row.b & row.b;
					return row;
				};
				var result = fp.map(double, data);

				expect(result).toBe(queryNew("a,b", "integer,varchar", [{a:2, b:"foofoo"}, {a:4, b:"barbar"}]));

				result = fp.map(double, queryNew("a,b", "integer,varchar"));

				expect(result).toBe(queryNew("a,b", "integer,varchar"), "empty in, empty out");

				var argCheck = function(row, index, wholeQuery) {
					expect(row).toBeStruct();
					expect(row).toBe({a:1, b:"foo"});
					expect(index).toBe(1);
					expect(wholeQuery).toBeQuery();
					return row;
				};

				result = fp.map(argCheck, queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]));

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
				var threeRows = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}, {a:3, b:"baz"}]);
				var oneRow = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]);
				var noRows = queryNew("a,b", "integer,varchar");

				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp._queryEach(threeRows, f);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp._queryEach(noRows, f);
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

				result = fp._queryEach(oneRow, argCheck);

				expect(isNull(result)).toBeTrue();
				expect(loopCounter).toBe(1);
			});

			it("provides queryEach through each", function() {
				var threeRows = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}, {a:3, b:"baz"}]);
				var oneRow = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]);
				var noRows = queryNew("a,b", "integer,varchar");

				var loopCounter = 0;
				var f = function(x) {
					loopCounter++;
				};
				fp.each(f, threeRows);
				expect(loopCounter).toBe(3);

				//empty check
				loopCounter = 0;
				fp.each(f, noRows);
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

				result = fp.each(argCheck, oneRow);

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
			
			it("provies a curried version of each", function() {
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

		});
	}



}