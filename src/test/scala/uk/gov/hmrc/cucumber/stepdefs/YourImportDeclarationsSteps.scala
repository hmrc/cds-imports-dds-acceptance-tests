package uk.gov.hmrc.cucumber.stepdefs
import org.openqa.selenium.By
import org.scalatest.AppendedClues
import uk.gov.hmrc.pages.{CustomsImportsWebPage, SinglePageDeclarationPage}

class YourImportDeclarationsSteps extends CustomsImportsWebPage with AppendedClues {

  Then("""^I should see a message telling me that '(.*)'$""") { msg:String =>
    elementText(".govuk-hint") should be(msg) withClue s"Expected Text $msg is not found"
  }

  And("""^I should see a link 'Make a Declaration'$""") { () =>
    val actualHref = webDriver.findElement(By.className("govuk-button")).getAttribute("href")
    val expectedHref = SinglePageDeclarationPage.url

    actualHref should be(expectedHref) withClue s"Actual href $actualHref is not equals to expected $expectedHref "
  }
}
