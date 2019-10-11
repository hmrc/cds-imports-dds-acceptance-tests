package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.PendingException
import org.scalatest.AppendedClues
import uk.gov.hmrc.conf.TestConfiguration
import uk.gov.hmrc.pages.{BasePage, FeatureSwitchPage, HelloWorldPage}

class CommonSteps extends BasePage with AppendedClues {

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
    val result = FeatureSwitchPage(
      feature.toLowerCase().replace(" ", "-"),
      featureState.dropRight(1)).featureToggle
    result should be(true) withClue ", Feature could not be toggled"
  }

  When("""^I navigate to the (.*) page$""") { page: String =>
    page match {
      case "Hello World" => HelloWorldPage.goToPage()
    }
  }

  Then("""^I should (not |)see the (sub-|)heading "([^"]*)"$""") { (notWord: String, subWord: String, expectedHeadingText: String) =>
    val headingTag = if (subWord.isEmpty) "h1" else "h2"
    assertElementInPageWithText(headingTag, notWord.isEmpty, expectedHeadingText)
  }

  private def assertElementInPageWithText(element: String, exists: Boolean, expectedParagraphText: String) = {
    val allTextForElement = elementTextAll(element)
    if (exists) {
      allTextForElement should contain(expectedParagraphText)
    }
    else {
      allTextForElement should not contain expectedParagraphText
    }
  }

}
