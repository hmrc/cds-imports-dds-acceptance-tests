package uk.gov.hmrc.pages

import org.openqa.selenium.By

object NotificationsPage extends CustomsImportsWebPage {

  override lazy val url = baseUrl + "/customs/imports/notification"

  val title = "Notifications"

  def status = elementText(".declaration-status")


  def statusList = elementTextAll(".declaration-status")


  def errors = webDriver.findElement(By.cssSelector(".wco-errors"))

}
