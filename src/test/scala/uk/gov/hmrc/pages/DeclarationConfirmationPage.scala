package uk.gov.hmrc.pages

import org.openqa.selenium.By

import scala.collection.JavaConverters._

object DeclarationConfirmationPage extends CustomsImportsWebPage {

  override lazy val url = baseUrl + "/customs/imports/submit-declaration"

  def responseRows = {
    val rows = webDriver.findElements(By.tagName("tr")).asScala
      .map(_.findElements(By.tagName("td")).asScala.map(_.getText).toList)
    rows.map{a => a(0) -> a(1);}.toMap
  }

  def decApiResponseRows = {
    webDriver.findElements(By.cssSelector(".govuk-summary-list__row")).asScala
      .map{a=>
        val dtText = a.findElement(By.tagName("dt")).getText
        val ddText = a.findElement(By.tagName("dd")).getText
        (dtText, ddText)
      }.toMap
  }

}
