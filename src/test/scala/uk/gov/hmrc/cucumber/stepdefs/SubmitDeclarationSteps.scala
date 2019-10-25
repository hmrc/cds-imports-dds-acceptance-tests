package uk.gov.hmrc.cucumber.stepdefs

import java.util

import cucumber.api.DataTable
import org.scalatest.AppendedClues
import play.api.libs.ws.StandaloneWSRequest
import uk.gov.hmrc.pages._
import uk.gov.hmrc.utils.WSClient

import scala.collection.JavaConverters._
import scala.concurrent.Await
import scala.concurrent.duration._
import scala.xml.{NodeSeq, XML}


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

  When("""^I enter the following data$""".stripMargin) { dataTable: DataTable =>
    dataTable.asScalaListOfMaps.foreach { field =>
      val inputField = inputFieldLabelled(field.get("Field Name"))
      inputField.clear()
      inputField.sendKeys(field.get("Value"))
    }
  }

  When("""^I click on Submit""") { () =>
    SimpleDeclarationPage.submit()
  }

  Then("""^the submitted XML should include the following data elements$""") { dataTable: DataTable =>
    val eventualResponse = WSClient.httpGet("http://localhost:6790/last-submission")
    val response = Await.result(eventualResponse, 5 seconds)

    val submittedXML: NodeSeq = XML.loadString(response.body)

    dataTable.asScalaListOfMaps.groupBy(_.get("Path")).foreach {
      case (path: String, expectedElements: List[util.Map[String, String]] ) =>
        val expectedValues = expectedElements.map(_.get("Value"))

        val nodes = path.split("/")
        val actualElements = nodes.foldLeft(submittedXML) { case (node, pathFragment) => node \ pathFragment }
        val actualValues = actualElements.map(_.text)

        actualValues should be (expectedValues) withClue(s"for XML path $path")
    }
  }

}
