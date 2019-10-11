package uk.gov.hmrc.pages

object HelloWorldPage extends CustomsImportsWebPage {
  override lazy val url: String = s"$serviceUrl/hello-world"
}
