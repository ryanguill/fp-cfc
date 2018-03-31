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