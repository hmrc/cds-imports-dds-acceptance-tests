package uk.gov.hmrc.cucumber.stepdefs

import java.util

import cucumber.api.DataTable
import org.scalatest.AppendedClues
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
    val FUNCTIONAL_REFERENCE_ID_TAG = "<FunctionalReferenceID>"
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
    refreshUntilElementVisible(".govuk-link")
    DeclarationConfirmationPage.decApiResponseRows.get("Status") should be(expectedData)
    dataType match {
      case "valid data" => DeclarationConfirmationPage.decApiResponseRows("ConversationId").length should not be 0
      case "invalid xml" => DeclarationConfirmationPage.decApiResponseRows("ConversationId").length should be(0)
    }
  }

  Then("""^the declaration status should be (.*)$""") { statusText: String =>
    refreshUntilElementVisible(".declaration-status")
    NotificationsPage.statusList.size match {
      case 1          => NotificationsPage.status should be(statusText)
      case x if x > 1 => NotificationsPage.statusList contains statusText
      case _          => throw new NoSuchElementException("Declaration status is not received")
    }
  }

  Then("""^I should see the following errors$""") { dataTable: DataTable =>
    dataTable.asScalaListOfStrings.foreach { error =>
      val actual = NotificationsPage.errors.getText.replaceAll("[\r\n]","")
      actual should be(error)
    }
  }

  When("""^I enter the following data$""") { dataTable: DataTable =>
    dataTable.asScalaListOfMaps.foreach { field =>
      val inputField = inputFieldLabelled(field.get("Field Name"))
      inputField.clear()
      inputField.sendKeys(field.get("Value"))
    }
  }

  When("""^I click on Submit""") { () =>
    SinglePageDeclarationPage.submit()
  }

  Then("""^the submitted XML should include the following data elements$""") { dataTable: DataTable =>
    val submittedXML = lastSubmittedXML()

    dataTable.asScalaListOfMaps.groupBy(_.get("Path")).foreach {
      case (path: String, expectedElements: List[util.Map[String, String]] ) =>
        val expectedValues = expectedElements.map(_.get("Value"))

        val nodes = path.split("/")
        val actualElements = nodes.foldLeft(submittedXML) { case (node, pathFragment) => node \ pathFragment }
        val actualValues = actualElements.map(_.text)
        val commonValues = actualValues.intersect(expectedValues)

        commonValues.size should be (expectedValues.size) withClue s"for XML path $path"
    }
  }

  Then("""^the submitted XML should include a (.*) with the following (.*)$""") { (expectedElementName: String, expectedSubElementName: String, dataTable: DataTable) =>
    val actualElements = expectedSubElementName match {
      case "data elements" => lastSubmittedXML() \\ expectedElementName
      case _ => lastSubmittedXML() \\ expectedElementName \\ expectedSubElementName
    }
    val expectedSubElements = dataTable.asScalaListOfMaps
    val expectedKeyValuePairs = expectedSubElements.map(ee => (ee.get("Element"), ee.get("Value")))

    val actualKeyValuePairs = actualElements.map { actualElement =>
      expectedKeyValuePairs.flatMap { case (path: String, expectedValue: String) =>
        findElements(actualElement, path).filter(_.text == expectedValue).map { actualSubElement =>
          (path, actualSubElement.text)
        }
      }
    }

    actualKeyValuePairs should contain(expectedKeyValuePairs)
  }

  And("""^the (.*) attribute of node (.*) should be (.*)$""") { (attributeName: String, expectedSubElementName: String, expectedValue: String) =>
    val actualValue = (lastSubmittedXML() \\ expectedSubElementName \ s"@$attributeName").toString()
    actualValue should be(expectedValue) withClue s"$attributeName attribute is not present in $expectedSubElementName node"
  }

  private def lastSubmittedXML(): NodeSeq = {
    val eventualResponse = WSClient.httpGet("http://localhost:6790/last-submission")
    val response = Await.result(eventualResponse, 5.seconds)
    val submittedXML: NodeSeq = XML.loadString(response.body)
    submittedXML
  }

  private def findElements(rootElement: NodeSeq, path: String): NodeSeq = {
    val nodes = path.split("/")
    nodes.foldLeft(rootElement) { case (node, pathFragment) => node \ pathFragment }
  }
}
