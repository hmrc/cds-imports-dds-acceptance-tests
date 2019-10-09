package uk.gov.hmrc.cucumber.stepdefs

import org.openqa.selenium.By
import uk.gov.hmrc.pages.{AuthStubPage, BasePage}

class SignInSteps extends BasePage {

  Given("""^I am signed in as a (.*)$""") { (user: String) =>
    val redirectUrl = s"$baseUrl/customs/imports"

    AuthStubPage.goToPage()
    AuthStubPage.logIn(user, redirectUrl: String)
    AuthStubPage.submit()
  }

  //TODO Remove when actual landing page is ready
  Then("""^I should land on a temporary page$""") { () =>
    val loginText = webDriver.findElement(By.tagName("pre")).getText
    val expectedText = "You are logged in"
    loginText should be(expectedText)
  }
}
