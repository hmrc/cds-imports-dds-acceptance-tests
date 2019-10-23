package uk.gov.hmrc.pages

import org.openqa.selenium.By
import org.scalatest.Assertion

trait CustomsImportsWebPage extends BasePage {

  def serviceUrl = s"$baseUrl/customs/imports"

  private def bearerToken = webDriver.findElement(By.xpath("//td[@data-session-id='authToken']"))

  def getBearerToken: String = {
    val stubSessionUrl: String = "http://localhost:9949/auth-login-stub/session"
    AuthStubPage.goToPage()
    AuthStubPage.logIn("registered user", stubSessionUrl)
    AuthStubPage.submit()
    bearerToken.getText
  }

  protected def assertElementInPageWithText(element: String, exists: Boolean, expectedParagraphText: String): Assertion = {
    val allTextForElement = elementTextAll(element)
    if (exists) {
      allTextForElement should contain(expectedParagraphText)
    }
    else {
      allTextForElement should not contain expectedParagraphText
    }
  }

}
