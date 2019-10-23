package uk.gov.hmrc.pages

object NotificationsPage extends CustomsImportsWebPage {

  override lazy val url = baseUrl + "/customs/imports/notification"

  val title = "Notifications"

  def status = {

    elementText(".declaration-status")
  }

}
