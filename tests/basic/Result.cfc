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

		describe("Result", function () {

			it("should be able to create an Ok()", function() {
				var ok = fp.Result().ok(1);
				expectAnOk(ok, 1);
			});

			it("should be able to create a Err()", function() {
				var err = fp.Result().err(2);
				expectAnErr(err, 2);
			});
		});
	}

	private function expectAnOk (result, expectedOkValue) {
		expect(result.isOk()).toBe(true, "isOk on an ok should be true");
		expect(result.isErr()).toBe(false, "isErr on an ok should be false");
		expect(result.toString()).toBe("Ok( " & expectedOkValue & " )", "toString() on an ok should return the value wrapped in an Ok() label");
		
		expect(result.getOk().isSome()).toBe(true, "getOk() on an ok should return a Maybe.some");
		expect(result.getOk().unwrap()).toBe(expectedOkValue, "getOk() should return a Maybe that when upwrapped returns the expected value");

		expect(result.getErr().isSome()).toBe(false, "getErr() on an ok should return a Maybe.none");
		
		expect(result.unwrap()).toBe(expectedOkValue, "unwrap on an Ok should return the wrapped value");
		var didThrow = false;
		try {
			result.unwrapErr();
		} catch (any e) {
			didThrow = true;
		}
		expect(didThrow).toBe(true, "unwrapErr() on an Ok should throw an error");

		expect(result.unwrapOrElse(function (err) {
			return err;
		})).toBe(expectedOkValue, "unwrapOrElse() on an Ok should return the ok value");

		if (isNull(arguments.secondPass)) {

			var mapped = result.map(function (x) {
				return "mappedOkValue";
			});
			expect(mapped.unwrap()).toBe("mappedOkValue", "mapping an Ok should apply the function");
			expectAnOk(result=mapped, expectedOkValue="mappedOkValue", secondPass=true);

			var mappedErr = result.mapErr(function(x) {
				return "mappedErrValue";
			});
			expect(mappedErr.unwrap()).toBe(expectedOkValue, "mapErr an Ok should not apply the function");
			expectAnOk(result=mappedErr, expectedOkValue=expectedOkValue, secondPass=true);
		}	
		expect(result.match({
			ok: function (okVal) {
				return 'was an ok';
			}, 
			err: function (errVal) {
				return 'was an err';
			}
		})).toBe('was an ok', "match on a ok returns the value of the ok: function");
		expect(result.match()).toBe(result.toString(), "match on a ok without a ok function returns the same as toString()");
	}

	private function expectAnErr (result, expectedErrValue) {
		expect(result.isOk()).toBe(false, "isOk on an err should be false");
		expect(result.isErr()).toBe(true, "isErr on an err should be true");
		expect(result.toString()).toBe("Err( " & expectedErrValue & " )", "toString() on an err should return the value wrapped in an Err() label");
		
		expect(result.getOk().isSome()).toBe(false, "getOk() on an err should return a Maybe.none");
		expect(result.getErr().isSome()).toBe(true, "getErr() on an err should return a Maybe.some");
		expect(result.getErr().unwrap()).toBe(expectedErrValue, "getErr() should return a Maybe that when upwrapped returns the expected value");
		
		expect(result.unwrapErr()).toBe(expectedErrValue, "unwrap on an Err should return the wrapped value");
		var didThrow = false;
		try {
			result.unwrap();
		} catch (any e) {
			didThrow = true;
		}
		expect(didThrow).toBe(true, "unwrap() on an Err should throw an error");

		expect(result.unwrapOrElse(function (err) {
			return "foo";
		})).toBe("foo", "unwrapOrElse() on an Err should return the mapped Err value");

		if (isNull(arguments.secondPass)) {

			var mapped = result.map(function (x) {
				return "mappedOkValue";
			});
			expect(mapped.unwrapErr()).toBe(expectedErrValue, "mapping an Err should not apply the function");
			expectAnErr(result=mapped, expectedErrValue=expectedErrValue, secondPass=true);

			var mappedErr = result.mapErr(function(x) {
				return "mappedErrValue";
			});
			expect(mappedErr.unwrapErr()).toBe("mappedErrValue", "mapErr on an Err should apply the function");
			expectAnErr(result=mappedErr, expectedErrValue="mappedErrValue", secondPass=true);
		}	
		expect(result.match({
			ok: function (okVal) {
				return 'was an ok';
			}, 
			err: function (errVal) {
				return 'was an err';
			}
		})).toBe('was an err', "match on a err returns the value of the err: function");
		expect(result.match()).toBe(result.toString(), "match on a err without a err function returns the same as toString()");
	}
}	