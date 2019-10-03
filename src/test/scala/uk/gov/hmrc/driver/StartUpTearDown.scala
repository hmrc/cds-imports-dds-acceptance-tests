package uk.gov.hmrc.driver

import org.openqa.selenium.WebDriver

trait StartUpTearDown {
  implicit val webDriver: WebDriver = BrowserDriver.driverInstance
}
