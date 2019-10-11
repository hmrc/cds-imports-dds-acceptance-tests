'use strict';

const pa11y = require('pa11y');
const puppeteer = require('puppeteer');

require("util").inspect.defaultOptions.depth = null; // log entire result structure


RunPa11y();

// Async function required for us to use await
async function RunPa11y() {

    const browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});

    function randomId() {
        return Math.random().toString(36).replace(/[^a-z]+/g, '').substr(2, 10);
    }

    function featureSwitchUrlFor(targetURL) {
        // Feature switch == first part of path after context path, or cds-imports-dds-home for root page
        let featureSwitch = targetURL
            .replace(/http:\/\/localhost:9760\/customs\/imports\/?/, "").replace(/\/.*/, "")
            .replace(/^$/, "cds-imports-dds-home");
        return 'http://localhost:9760/customs/imports/test-only/feature/' + featureSwitch + '/enable';
    }

    function screenshotPathFor(targetURL) {
        // sanitise the URL to make a unique screenshot filename
        return 'target/screenshots/' + targetURL.replace(/[^a-z0-9]/g, "-") + '.png';
    }

    function testPageWithLogin(targetURL, additionalActionsForPage = []) {

        // TODO get some ids added to the auth login stub form fields, so we can select them in a more robust manner...
        const authorityId = '#inputForm > div.form-field-group > div:nth-child(2) > input[type="text"]';
        const redirectionUrl = '#inputForm > div.form-field-group > div:nth-child(4) > input[type="text"]';
        const enrolment_0_name = '#js-enrolments-table > tbody > tr:nth-child(2) > td:nth-child(1) > input[type="text"]';
        const enrolment_0_taxIdentifier_0_name = '#input-0-0-name';
        const enrolment_0_taxIdentifier_0_value = '#input-0-0-value';
        const submitButton = '#inputForm > div.form-field-group > p > input';

        // Need to login via the auth login stub before we can test...
        let loginAndNavigateToPage = [
            'navigate to http://localhost:9949/auth-login-stub/gg-sign-in/',
            'set field ' + authorityId + ' to ' + randomId(),
            'set field ' + redirectionUrl + ' to ' + targetURL,
            'set field #affinityGroupSelect to Organisation',
            'set field ' + enrolment_0_name + ' to HMRC-CUS-ORG',
            'set field ' + enrolment_0_taxIdentifier_0_name + ' to EORINumber',
            'set field ' + enrolment_0_taxIdentifier_0_value + ' to GB987654321',
            'click element ' + submitButton,
            'wait for url to be ' + targetURL,
            'wait for element #footer to be visible', // from govuk-template - ensures page is rendered before testing
            'screen capture ' + screenshotPathFor(targetURL)
        ];

        return pa11y(featureSwitchUrlFor(targetURL), {

            browser: browser,

            // Run some actions before testing
            actions: loginAndNavigateToPage.concat(additionalActionsForPage),

            // Log what's happening to the console
            log: {
                debug: console.log,
                error: console.error,
                info: console.log
            }

        });
    }

    try {
        let doSomething = [
            'set field #this to blah',
            'set field #that to yada yada',
            'click element #submit',
            'wait for url to be http://localhost:9760/customs/imports/some-redirect-url'
        ];

	    // The pages we want to test
        const results = await Promise.all([
            testPageWithLogin('http://localhost:9760/customs/imports/hello-world'),
            // testPageWithLogin('http://localhost:9760/customs/imports') // no footer on this page yet :(
            ]);

        results.forEach(function (result) {
            console.log(result)
        });

	} catch (error) {

		// Output an error if it occurred
		console.error(error.message);

	}

    await browser.close();
}
