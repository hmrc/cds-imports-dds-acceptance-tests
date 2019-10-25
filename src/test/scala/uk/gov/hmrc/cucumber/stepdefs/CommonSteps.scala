package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.PendingException
import org.scalatest.AppendedClues
import uk.gov.hmrc.conf.TestConfiguration
import uk.gov.hmrc.pages._
import uk.gov.hmrc.utils.DropMongo._
import uk.gov.hmrc.utils.WSClient

import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._

class CommonSteps extends CustomsImportsWebPage with AppendedClues  {

  Given("""^PENDING""") { () =>
    throw new PendingException()
  }

  Given("""^the (.*) feature is (.*)""") { (feature: String, featureState: String) =>
    TestConfiguration.environment.toString match {
      case "Local" => toggleFeatureSwitch(feature, featureState)
      case _ => None
    }
  }

  private def toggleFeatureSwitch(feature: String, featureState: String) = {
    val featureName = feature.toLowerCase().replace(" ", "-")
    val featureAction: String = featureState match {
      case "suspended" => "suspend"
      case "enabled" => "enable"
      case "disabled" => "disable"
      case _ => featureState
    }

    val result = FeatureSwitchPage(featureName, featureAction).featureToggle
    result should be(true) withClue ", Feature could not be toggled"
  }

  When("""^I navigate to the (.*) page$""") { page: String =>
    page match {
      case "Hello World" => HelloWorldPage.goToPage()
      case "Submit Declaration" => SubmitDeclarationPage.goToPage()
      case "Simple Declaration" => SinglePageDeclarationPage.goToPage()
    }
  }

  Then("""^I should (not |)see the (sub-|)heading "([^"]*)"$""") { (notWord: String, subWord: String, expectedHeadingText: String) =>
    val headingTag = if (subWord.isEmpty) "h1" else "h2"
    assertElementInPageWithText(headingTag, notWord.isEmpty, expectedHeadingText)
  }

  When("""^I click on the link (.*)$""") { selectedLink: String =>
    click on partialLinkText(selectedLink)
  }

  Given("""^our application is registered with the DEC-API$""") {() =>
    val body = """{
                 |"clientId": "cds-imports-dds",
                 |"callbackUrl": "http://localhost:9760/customs/imports/notification",
                 |"token": "secret-token"
                 |}""".stripMargin
    val headers = List("Content-Type" -> "application/json")
    val response = WSClient.httpPost("http://localhost:6790/customs-declarations-stub/admin/client", body, headers:_*)
    val result = Await.result(response.map(_.status), 5 seconds)
    assert(result == 201, s"Update to mongo failed with error code $result")
  }

  Given("""^the mongo database is empty$""") { () =>
    dropMongo("customs-declarations-stub")
  }

  When("""^I wait for (\d+) seconds$""") { seconds: Int =>
    Thread.sleep(seconds*1000)
  }

}
