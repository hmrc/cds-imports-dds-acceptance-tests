package uk.gov.hmrc.pages

import org.openqa.selenium.By

object SubmitDeclarationPage extends CustomsImportsWebPage {

  override lazy val url = baseUrl + "/customs/imports/submit-declaration"

  def declarationXmlInput = webDriver.findElement(By.id("declaration-data"))

  def errorSummary = webDriver.findElement(By.cssSelector(".error-summary"))

  def errorHeading = errorSummary.findElement(By.tagName("h2"))

  def errorMessage = errorSummary.findElement(By.tagName("p"))

  def errorLink = errorSummary.findElement(By.tagName("a"))

}
