component skip="true" {
	this.name = "cf-fputil-" & "basic-" & hash(getCurrentTemplatePath());

	this.mappings["/lib"] = expandPath("../../lib");
	this.mappings["/com"] = expandPath("../../com");

	variables.system = createObject("java", "java.lang.System");

	this.sessionmanagement = false;
	this.setclientcookies = false;
	//this.setDomainCookies = false;

	function appInit () {

	}

	boolean function onApplicationStart () {
		//you do not have to lock the application scope
		//you CANNOT access the variables scope
		//uncaught exceptions or returning false will keep the application from starting
			//and CF will not process any pages, onApplicationStart() will be called on next request

		appInit();

		return true;
	}

/*
	void function onError (any exception, string eventName) {
		//You CAN display a message to the user if an error occurs during an
			//onApplicationStart, onSessionStart, onRequestStart, onRequest,
			//or onRequestEnd event method, or while processing a request.
		//You CANNOT display output to the user if the error occurs during an
			//onApplicationEnd or onSessionEnd event method, because there is
			//no available page context; however, it can log an error message.

		writedump(arguments);
		abort;
	}
*/

	boolean function onRequestStart (targetPage) {
		//you cannot access the variables scope
		//you CAN access the request scope

		//include "globalFunctions.cfm";

		if (!isNull(url.reinit) && url.reinit == true) {
			appInit();
		}

		//returning false would stop processing the request
		return true;
	}

	void function onRequestEnd (targetPage) {
		//you can access page context
		//you can generate output
		//you cannot access the variables scope
		//you CAN access the request scope
	}




}