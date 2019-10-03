package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.Scenario
import cucumber.api.java.{After, Before}
import org.openqa.selenium.{OutputType, TakesScreenshot, WebDriverException}
import uk.gov.hmrc.driver.StartUpTearDown

class Hooks extends StartUpTearDown {

  @Before
  def initialize(): Unit = {
    webDriver.manage().deleteAllCookies()
  }

  @After
  def tearDown(res: Scenario) = {
    if(res.isFailed) {
      webDriver match {
        case takeScreenshot: TakesScreenshot =>
          try {
            val screenshot = takeScreenshot.getScreenshotAs(OutputType.BYTES)
            res.embed(screenshot, "image/png")
          }
          catch {
            case screenshotException: WebDriverException => System.err.println(screenshotException.getMessage)
          }
        case _ =>
      }
    }
  }
}
