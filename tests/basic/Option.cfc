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

		describe("Option", function () {

			it("should be able to create a Some()", function() {
				var s = fp.Option().some(1);
				expectASome(s, 1);
			});

			it("should be able to create a None()", function() {
				var n = fp.Option().none();
				expectANone(n);
			});

			it("should be able to create an option.some using of", function() {
				var of = fp.Option().of(1);
				expectASome(of, 1);
			});

			it("should be able to create an option.none using of", function() {
				var of = fp.Option().of(javacast("null", 0));
				expectANone(of);
			});

			it("should be able to respond to isSome/isNone properly", function() {
				expect(fp.Option().some(1).isSome()).toBe(true);
				expect(fp.Option().none().isSome()).toBe(false);
				expect(fp.Option().some(1).isNone()).toBe(false);
				expect(fp.Option().none().isNone()).toBe(true);
				expect(fp.Option().of(1).isSome()).toBe(true);
				expect(fp.Option().of(javacast("null", 0)).isSome()).toBe(false);
				
				var fn = function () {
					//returns void;
				};

				expect(fp.Option().of(fn()).isSome()).toBe(false);
			});

			it("unwrap/unwrapOr/unwrapOrElse", function () {
				var some1 = fp.Option().some(1);
				expect(some1.unwrap()).toBe(1);
				expect(some1.unwrapOr(2)).toBe(1);
				expect(some1.unwrapOrElse(function () {
					return 3;
				})).toBe(1);

				var none = fp.Option().none();
				expect(function() {
					none.unwrap();
				}).toThrow("Application", ".*", "Cannot unwrap a none.");
				expect(none.unwrapOr(2)).toBe(2);
				expect(none.unwrapOrElse(function () {
					return 3;
				})).toBe(3);
			});

			it("get/getOr/getOrElse", function () {
				var some1 = fp.Option().some(1);
				expect(some1.get()).toBe(1);
				expect(some1.getOr(2)).toBe(1);
				expect(some1.getOrElse(function () {
					return 3;
				})).toBe(1);

				var none = fp.Option().none();
				expect(function() {
					none.get();
				}).toThrow("Application", ".*", "Cannot unwrap a none.");
				expect(none.getOr(2)).toBe(2);
				expect(none.getOrElse(function () {
					return 3;
				})).toBe(3);
			});

			it("map", function () {
				var opt1 = fp.Option().some(1);
				expect(opt1.map(function (x) {
					return x * 2;
				}).unwrap()).toBe(2);

				var opt2 = fp.Option().none();
				expect(opt2.map(function (x) {
					return x * 2;
				}).isNone()).toBeTrue();

				var opt3 = fp.Option().some("foo");
				expect(opt3.map(function (x) {
					return ucase(x);
				}).map(function (x) {
					// pretend this is a call to some other service, looking up the value and
					// that service returns null because the value wasnt found
					if (x == "BAR") {
						return x;
					}
				}).isNone()).toBeTrue();
			});

			it("filter", function() {
				var optNumber = fp.Option().some(1);
				expect(optNumber.isSome()).toBeTrue(); //true
				expect(optNumber.filter(function (x) {
					return x % 2 == 0;
				}).isNone()).toBeTrue(); // None()
			});

			it("forEach", function() {
				var opt = fp.Option().some(1);

				var result = [];

				opt.forEach(function (x) {
					arrayAppend(result, x);
				});

				expect(result[1]).toBe(1);

				result = [];

				var opt2 = fp.Option().none();
				opt2.forEach(function (x) {
					arrayAppend(result, x);
				});

				expect(arrayLen(result)).toBe(0);
			});

			it("match", function () {
				var mySome = fp.Option().some(1);
				var result = mySome.match({
					some: function (x) {
						return x * 2;
					},
					none: function () {
						return 0;
					}
				}); // result == 2;
				expect(result).toBe(2);

				var myNone = fp.Option().none();
				var result = myNone.match({
					some: function (x) {
						return x * 2;
					},
					none: function () {
						return 0;
					}
				}); // result == 0;
				expect(result).toBe(0);
			});

		});
	}

	private function expectASome (option, expectedValue) {
		expect(option.isSome()).toBeTrue("isSome() on a some is true");
		expect(option.isNone()).toBeFalse("isNone() on a none is false");
		expect(option.unwrap()).toBe(expectedValue, "unwrap() on a some gives the value");
		expect(option.unwrapOr(2)).toBe(expectedValue, "unwrapOr() on a some gives the value");
		expect(option.unwrapOrElse(function() {
			return 3;
		})).toBe(expectedValue, "unwrapOrElse() on a some gives the value");
		expect(option.get()).toBe(expectedValue, "get() on a some gives the value");
		expect(option.getOr(2)).toBe(expectedValue, "getOr() on a some gives the value");
		expect(option.getOrElse(function() {
			return 3;
		})).toBe(expectedValue, "getOrElse() on a some gives the value");
		expect(option.toString()).toBe('Some( ' & expectedValue & ' )', "toString on a some gives the value wrapped in a Some() label");
		expect(option.match({
			some: function (value) {
				return 'was a some';
			}, none: function () {
				return 'was a none';
			}
		})).toBe('was a some', "match on a some returns the value of the some: function");
		expect(option.match()).toBe(option.toString(), "match on a some without a some function returns the same as toString()");
		
		if (isNull(arguments.secondPass)) {
			var mapped = option.map(function (value) {
				return 100;
			});
			expectASome(option=mapped, expectedValue=100, secondPass=true);

			var filtered = option.filter(function (value) {
				return true;
			});
			expectASome(option=filtered, expectedValue=expectedValue, secondPass=true);

			var filtered = option.filter(function (value) {
				return false;
			});
			expectANone(option=filtered, secondPass=true);

			var sideEffect = "";
			option.forEach(function (value) {
				sideEffect = value;
			});
			expect(sideEffect, expectedValue, "forEach on a some should execute the function.");
		}
		
	}

	private function expectANone(option) {
		expect(option.isSome()).toBe(false, "isSome() on a none is true");
		expect(option.isNone()).toBe(true, "isNone() on a none is false");
		var didThrow = false;
		try {
			option.unwrap();
		} catch (any e) {
			didThrow = true;
		}	
		expect(didThrow).toBe(true, "unwrap() on a none throws an error");
		expect(option.unwrapOr(2)).toBe(2, "unwrapOr() on a none gives the passed value");
		expect(option.unwrapOrElse(function() {
			return 3;
		})).toBe(3, "unwrapOrElse() on a none gives the value of the passed function");
		var didThrow = false;
		try {
			option.get();
		} catch (any e) {
			didThrow = true;
		}	
		expect(didThrow).toBe(true, "get() on a none throws an error");
		expect(option.getOr(2)).toBe(2, "getOr() on a none gives the passed value");
		expect(option.getOrElse(function() {
			return 3;
		})).toBe(3, "getOrElse() on a none gives the value of the passed function");
		expect(option.toString()).toBe('None()', "toString on a none returns `None()`");
		expect(option.match({
			some: function (value) {
				return 'was a some';
			}, none: function () {
				return 'was a none';
			}
		})).toBe('was a none', "match on a none returns the value of the none: function");
		expect(option.match()).toBe(option.toString(), "match on a none without a none function returns the same as toString()");

		if (isNull(arguments.secondPass)) {
			var mapped = option.map(function (value) {
				return 100;
			});
			expectaNone(option=mapped, secondPass=true);

			var filtered = option.filter(function (value) {
				return true;
			});
			expectANone(option=filtered, secondPass=true);

			var filtered = option.filter(function (value) {
				return false;
			});
			expectANone(option=filtered, secondPass=true);

			var sideEffect = "";
			option.forEach(function (value) {
				sideEffect = value;
			});
			expect(sideEffect, "", "forEach on a none should _not_ execute the function.");
		}	
	}
}	