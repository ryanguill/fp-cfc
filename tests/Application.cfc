component {

	this.name = "fp_cfc_unittests" & hash(getCurrentTemplatePath());

	this.mappings = {
		"/testbox" = expandPath("../testbox/")
	};

}