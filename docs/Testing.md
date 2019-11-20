# Testing your templates
Because of the way Sporq creates ARM templates that are completely finished with no evaluation required on by the Azure ARM service, Sqorq created templates are completely test-able.  ARM templates that still include ARM template syntax, such as Variables and Parameters are only completely rendered when submitted for deployment to the ARM Api.

This is compatible with using somethink like Pester.

Sporq includes a strategy for requesting an exemption to a Pester test.