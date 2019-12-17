package uk.gov.hmrc.cucumber.stepdefs
import org.scalatest.AppendedClues
import uk.gov.hmrc.pages.CustomsImportsWebPage

class YourImportDeclarationsSteps extends CustomsImportsWebPage with AppendedClues {

  Then("""^I should see a message telling me that '(.*)'$""") { msg:String =>
    elementText(".govuk-hint") should be(msg) withClue s"Expected Text $msg is not found"
  }

}
