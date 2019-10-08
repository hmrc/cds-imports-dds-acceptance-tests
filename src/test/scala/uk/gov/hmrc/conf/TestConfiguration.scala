/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package uk.gov.hmrc.conf

case class TestConfiguration(baseUrl: String, AUTH_LOGIN_STUB: String)

object TestConfiguration {

  lazy val environment: Environment.Name = {
    val environmentProperty = Option(System.getProperty("environment")).getOrElse("local").toLowerCase
    environmentProperty match {
      case "local" => Environment.Local
      case "qa" => Environment.Qa
      case "dev" => Environment.Dev
      case "staging" => Environment.Staging
      case _ => throw new IllegalArgumentException(s"Unknown Environment '$environmentProperty'")
    }
  }

  lazy val settings: TestConfiguration = create()

  private def create(): TestConfiguration = {
    environment match {
      case Environment.Local =>
        new TestConfiguration(
          baseUrl = "http://localhost",
          AUTH_LOGIN_STUB = "http://localhost:9949/auth-login-stub/gg-sign-in"
        )
      case Environment.Dev =>
        new TestConfiguration(
          baseUrl = "https://www.development.tax.service.gov.uk",
          AUTH_LOGIN_STUB = "https://www.development.tax.service.gov.uk/auth-login-stub/gg-sign-in"
        )
      case Environment.Qa =>
        new TestConfiguration(
          baseUrl = "https://www.qa.tax.service.gov.uk",
          AUTH_LOGIN_STUB = "https://www.qa.tax.service.gov.uk/auth-login-stub/gg-sign-in"
        )
      case Environment.Staging =>
        new TestConfiguration(
          baseUrl = "https://www.staging.tax.service.gov.uk",
          AUTH_LOGIN_STUB = "https://www.staging.tax.service.gov.uk/auth-login-stub/gg-sign-in"
        )
      case _ => throw new IllegalArgumentException(s"Unknown environment '$environment'")
    }
  }
}

object Environment extends Enumeration {
  type Name = Value
  val Local, Dev, Qa, Staging = Value
}