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


	}


}