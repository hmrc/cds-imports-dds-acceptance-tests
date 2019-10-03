package uk.gov.hmrc.pages

import org.scalatest.Matchers

trait BasePage extends Matchers {
  val url: String
}

