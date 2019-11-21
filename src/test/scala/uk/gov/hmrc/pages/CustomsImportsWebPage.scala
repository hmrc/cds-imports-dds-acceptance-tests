package uk.gov.hmrc.pages

import org.openqa.selenium.{By, WebElement}
import org.scalatest.Assertion

import scala.collection.JavaConverters._

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

  // TODO there's probably an XPath one-liner for this...
  def inputFieldLabelled(labelName: String): WebElement = {
    webDriver.findElements(By.tagName("label")).asScala.find(_.getText.replace("\n", " ") == labelName).map { label =>
      val inputId = label.getAttribute("for")
      webDriver.findElement(By.id(inputId))

    }.getOrElse(throw new NoSuchElementException(s"""No <input> element with <label> "$labelName""""))
  }

}
