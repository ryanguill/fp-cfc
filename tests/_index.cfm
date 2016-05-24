<cfparam name="url.format" default="html" />



<cfscript>

	if (!arrayFindNoCase(["html","travis"], url.format)) {
		url.format = "html";
	}

	reporter = "simple";

	switch (url.format) {
		case "travis" :
			reporter = "json";
			break;
		default :
			reporter = "simple";
			break;
	}

	steps = [
		{
			url:"/tests/basic/_index.cfm?opt_run=true&reporter=#reporter#&target=tests.basic.basic&reinit=true",
			before:	function(index) {
				//writeoutput("before step " & index);
			},
			after: function (index) {
				//writeoutput("after step " & index);
			}
		}
	];

	results = [];

	index = 0;

	for (step in steps) {
		index++;

		if (structKeyExists(step, "before")) {
			step.before(index);
		}

		httpService = new http(method="GET", charset="utf-8", url="http://" & cgi.server_name & step.url);
		httpResult = httpService.send().getPrefix();

		arrayAppend(results, httpResult.fileContent);

		if (structKeyExists(step, "after")) {
			step.after(index);
		}

	}

	switch (url.format) {
		case "travis" :

			overall = {
				totalSpecs: 0,
				totalPass: 0,
				totalFail: 0,
				totalError: 0
			};

			//writedump(results);

			for (result in results) {
				result = deserializeJSON(result);
				overall.totalSpecs += result.totalSpecs;
				overall.totalPass += result.totalPass;
				overall.totalFail += result.totalFail;
				overall.totalError += result.totalError;
			}

			if (overall.totalSpecs != overall.totalPass) {
				pc = getpagecontext().getresponse();
				pc.getresponse().setstatus(500);
			}

			writeoutput(serializeJSON(overall));
			abort;

			break;
		default :

			for (result in results) {
				writeOutput(result);
				writeOutput("<hr />");
			}

			break;
	}





</cfscript>

