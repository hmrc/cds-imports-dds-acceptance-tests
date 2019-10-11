package uk.gov.hmrc.pages

import org.openqa.selenium.By

case class FeatureSwitchPage(featureName: String, featureState: String) extends CustomsImportsWebPage {
  override lazy val url: String = s"$serviceUrl/test-only/feature/$featureName/$featureState"

  def featureToggle: Boolean = {
    go to url
    val elements = webDriver.findElements(By.tagName("pre"))
    elements.size() == 1 && elements.get(0).getText.toLowerCase.startsWith(featureState.toLowerCase())
  }
}
