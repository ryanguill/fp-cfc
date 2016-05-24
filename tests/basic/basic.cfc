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

				expect(fp.canBeCalledAsFunction(mapDouble)).toBeTrue();

				expect(mapDouble([1,2,3])).toBe([2,4,6]);
			});

			it("map takes objects", function() {
				var mock = new mockObject();

				writedump(fp.map(function(){}, mock));

				expect(fp.map(function(){}, mock)).toBe("I am map!");


			});

		});
	}


}