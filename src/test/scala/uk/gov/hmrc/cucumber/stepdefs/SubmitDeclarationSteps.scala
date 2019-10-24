package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.DataTable
import org.scalatest.AppendedClues
import uk.gov.hmrc.pages.{CustomsImportsWebPage, DeclarationConfirmationPage, NotificationsPage, SubmitDeclarationPage}

import scala.collection.JavaConverters._

class SubmitDeclarationSteps extends CustomsImportsWebPage with AppendedClues {

  private val DEC_API_STUB_GOOD_DECLARATION_PREFIX = "G"
  private val DEC_API_STUB_BAD_DECLARATION_PREFIX = "B"

  When("""^I submit the declaration with (.*)$""") { dataType: String =>
    val xmlFromPage = SubmitDeclarationPage.declarationXmlInput.getText
    val declarationData = dataType match {
      case "valid data" => xmlFromPage
      case "correct data" => modifyFunctionalReferenceId(DEC_API_STUB_GOOD_DECLARATION_PREFIX, xmlFromPage)
      case "incorrect data" => modifyFunctionalReferenceId(DEC_API_STUB_BAD_DECLARATION_PREFIX, xmlFromPage)
      case "malformed xml" => "malformed xml"
      case "invalid xml" => """<a>this is a test</a>"""
      case _ => throw new IllegalArgumentException("Invalid input xml type")
    }

    SubmitDeclarationPage.declarationXmlInput.clear()
    SubmitDeclarationPage.declarationXmlInput.sendKeys(declarationData)
    SubmitDeclarationPage.submit()
  }

  def modifyFunctionalReferenceId(prefix: String, xml: String): String = {
    val FUNCTIONAL_REFERENCE_ID_TAG = "<ns3:FunctionalReferenceID>"
    xml.replace(FUNCTIONAL_REFERENCE_ID_TAG, s"$FUNCTIONAL_REFERENCE_ID_TAG$prefix")
  }

  Then("""^I should see malformed xml error with following details$""") { dataTable: DataTable =>

    val data: java.util.Map[String, String] = dataTable.asMaps(classOf[String], classOf[String]).get(0)
    val expectedErrorHeading = data.get("errorHeading")
    val expectedErrorMessage = data.get("errorMessage")
    val expectedErrorLinkText = data.get("errorLinkText")

    SubmitDeclarationPage.errorSummary.isDisplayed should be(true) withClue "Error Summary is not present"
    SubmitDeclarationPage.errorHeading.getText should be(expectedErrorHeading)
    SubmitDeclarationPage.errorMessage.getText should be(expectedErrorMessage)
    SubmitDeclarationPage.errorLink.getAttribute("href") should be("http://localhost:9760/customs/imports/submit-declaration#declaration-data")
    SubmitDeclarationPage.errorLink.getText should be(expectedErrorLinkText)
  }

  Then("""^I should see submitted page with the following response details for (.*)$""") {(dataType: String, dataTable: DataTable) =>
    val expectedData = dataTable.asMaps(classOf[String], classOf[String]).get(0).asScala.toMap.get("Status")
    DeclarationConfirmationPage.ResponseRows.get("Status") should be(expectedData)
    dataType match {
      case "valid data" => DeclarationConfirmationPage.ResponseRows("ConversationId").length should not be(0)
      case "invalid xml" => DeclarationConfirmationPage.ResponseRows("ConversationId").length should be(0)
    }
  }

  Then("""^the declaration status should be (.*)$""") { (statusText: String) =>
    NotificationsPage.status should be(statusText)
  }

  Then("""^I should see the following errors$""".stripMargin) { dataTable: DataTable =>
    dataTable.asScalaListOfStrings.foreach { error =>
      assertElementInPageWithText("td", exists = true, error) // TODO check for something more specific than td
    }
  }
}
