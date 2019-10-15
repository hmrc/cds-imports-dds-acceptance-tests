package uk.gov.hmrc.pages

import org.openqa.selenium.By

import scala.collection.JavaConverters._

object DeclarationConfirmationPage extends CustomsImportsWebPage {

  override lazy val url = baseUrl + "/customs/imports/submit-declaration"

  def ResponseRows = {
    val rows = webDriver.findElements(By.tagName("tr")).asScala
      .map(_.findElements(By.tagName("td")).asScala.map(_.getText).toList)
    rows.map{a => a(0) -> a(1);}.toMap
  }

}
