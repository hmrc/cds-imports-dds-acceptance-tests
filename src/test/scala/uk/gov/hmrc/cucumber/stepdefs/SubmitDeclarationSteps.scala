package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.DataTable
import org.scalatest.AppendedClues
import uk.gov.hmrc.pages.{CustomsImportsWebPage, DeclarationConfirmationPage, NotificationsPage, SubmitDeclarationPage}

import scala.collection.JavaConverters._

class SubmitDeclarationSteps extends CustomsImportsWebPage with AppendedClues {

  When("""^I submit the declaration with (.*)$""") { dataType: String =>
    val declarationData = dataType match {
      case "valid data" => SubmitDeclarationPage.declarationXmlInput.getText
      case "invalid xml" => "invalid xml"
      case "invalid data" => """<a>this is a test</a>"""
      case _ => throw new IllegalArgumentException("Invalid input xml type")
    }

    SubmitDeclarationPage.declarationXmlInput.clear()
    SubmitDeclarationPage.declarationXmlInput.sendKeys(declarationData)
    SubmitDeclarationPage.submit()
  }

  Then("""^I should see invalid xml error with following details$""") { dataTable: DataTable =>

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
      case "invalid data" => DeclarationConfirmationPage.ResponseRows("ConversationId").length should be(0)
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
