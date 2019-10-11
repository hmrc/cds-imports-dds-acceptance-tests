package uk.gov.hmrc.pages

import cucumber.api.scala.{EN, ScalaDsl}
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
}

