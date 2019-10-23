package uk.gov.hmrc.pages

import org.openqa.selenium.By

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

}
