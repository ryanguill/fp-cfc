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
		var qOneRow = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}]);
		var qTwoRows = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}]);
		var qThreeRows = queryNew("a,b", "integer,varchar", [{a:1, b:"foo"}, {a:2, b:"bar"}, {a:3, b:"baz"}]);

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

		describe("FILTER", function() {});//filter

		describe("FILTER", function() {});//filter

		describe("SOME", function() {});//some

		describe("EVERY", function() {});//every

		describe("FIND", function() {});//find

		describe("FINDINDEX", function() {});//findindex

		describe("REDUCE", function() {});//reduce

		describe("REDUCERIGHT", function() {});//reduceright

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