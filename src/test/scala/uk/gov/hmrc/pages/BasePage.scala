package uk.gov.hmrc.pages

import java.time.Duration

import cucumber.api.scala.{EN, ScalaDsl}
import org.openqa.selenium.support.ui.{ExpectedCondition, FluentWait}
import org.openqa.selenium.{By, WebDriver}
import org.scalatest.Matchers
import org.scalatestplus.selenium.WebBrowser
import uk.gov.hmrc.conf.TestConfiguration
import uk.gov.hmrc.driver.StartUpTearDown

trait BasePage extends Matchers with WebBrowser with StartUpTearDown with ScalaDsl with EN {

  lazy val url: String = ""

  private lazy val envBaseUrl : String = TestConfiguration.settings.baseUrl
  private val port = 9760

  def baseUrl: String = if (envBaseUrl.contains("localhost")) s"$envBaseUrl:$port" else envBaseUrl

  def goToPage(): Unit = {
    go to url
  }

  def elementText(selector: String): String = {
    try {
      find(cssSelector(selector)).get.text.trim
    }
    catch {
      case _: NoSuchElementException => fail(s"$selector is not found in page")
    }
  }

  def elementTextAll(selector: String): List[String] = {
    try {
      findAll(cssSelector(selector)).map(_.underlying.getText.trim).toList
    }
    catch {
      case _: NoSuchElementException => fail(s"$selector is not found in page")
    }
  }

  def pageTitle = webDriver.getTitle

  def refreshUntilElementVisible(elementLocator: String): Unit = {
    var elements = webDriver.findElements(By.cssSelector(elementLocator))
    var b = elements.size match {
      case 0 => false
      case x if x>0 => true
    }
    while (!b) {
      if(elements.size() <= 0) {
        Thread.sleep(500L)
        webDriver.navigate().refresh()
        elements = webDriver.findElements(By.cssSelector(elementLocator))
      } else {
          b = true
      }
    }
  }

  def fluentWait(timeoutInSeconds: Int = 10, pollingTimeInMilliSeconds: Int = 500): FluentWait[WebDriver] = {
    new FluentWait[WebDriver](webDriver)
      .withTimeout(Duration.ofSeconds(timeoutInSeconds))
      .pollingEvery(Duration.ofMillis(pollingTimeInMilliSeconds))
  }

  def waitUntil[T](expectedCondition: ExpectedCondition[T]): T = {
    fluentWait().until(expectedCondition)
  }
}

