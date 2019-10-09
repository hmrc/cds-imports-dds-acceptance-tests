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
package uk.gov.hmrc.driver

import java.net.{InetSocketAddress, URL}
import java.util.concurrent.TimeUnit

import net.lightbody.bmp.proxy.auth.AuthType
import net.lightbody.bmp.{BrowserMobProxy, BrowserMobProxyServer}
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.{ChromeDriver, ChromeDriverService, ChromeOptions}
import org.openqa.selenium.firefox.FirefoxOptions
import org.openqa.selenium.remote.{BrowserType, CapabilityType, DesiredCapabilities, RemoteWebDriver}


object BrowserDriver {
  private val sysProperties = System.getProperties

  def getOsName: String = System.getProperty("os.name")

  lazy val isMacOs: Boolean = getOsName.startsWith("Mac")
  lazy val isLinuxOs: Boolean = getOsName.startsWith("Linux")

  val proxy: BrowserMobProxy = new BrowserMobProxyServer()
  val proxyPort: Int = Option(System.getProperty("proxyPort")).getOrElse("16633").toInt
  val turnOnProxy: String = Option(System.getProperty("turnOnProxy")).getOrElse("No")
  private val isJsEnabled: Boolean = true

  if (!Option(System.getProperty(ChromeDriverService.CHROME_DRIVER_EXE_PROPERTY)).exists(_.length > 0)) {
    System.setProperty(ChromeDriverService.CHROME_DRIVER_EXE_PROPERTY, "/usr/local/bin/chromedriver")
  }

  val driverInstance: WebDriver = newWebDriver()

  def newWebDriver(): WebDriver = {
    val browserProperty = sysProperties.getProperty("browser", "chrome")
    val driver = createDriver(browserProperty)
    driver
  }

  private def createDriver(browserProperty: String): WebDriver = {
    browserProperty match {
      case "chrome" => createChromeDriver()
      case "remote-chrome" => createRemoteChrome   //Use this to run tests in Jenkins
      case "remote-firefox" => createRemoteFirefox //Use this to run tests in Jenkins
      case "zap-local-chrome" => createZapLocalChrome
      case "zap-remote-chrome" => createZapRemoteChrome
      case _ => throw new IllegalArgumentException(s"browser type $browserProperty is not recognised ")
    }
  }

  private def createRemoteChrome: WebDriver = {
    new RemoteWebDriver(new URL(s"http://localhost:4444/wd/hub"), new ChromeOptions())
  }

  private def createRemoteFirefox: WebDriver = {
    new RemoteWebDriver(new URL(s"http://localhost:4444/wd/hub"), new FirefoxOptions())
  }

  private def createChromeDriver(): WebDriver = {

    val options = new ChromeOptions()
    options.addArguments("test-type")
    options.addArguments("--disable-gpu")

    if (turnOnProxy.equalsIgnoreCase("yes")) {
      if (proxy.isStarted) proxy.stop()
      proxy.setConnectTimeout(15, TimeUnit.SECONDS)
      val upstream_proxy = new InetSocketAddress("outbound-proxy-vip", 3128)
      proxy.setChainedProxy(upstream_proxy)
      proxy.chainedProxyAuthorization("jenkins", "$S4sJkIUkx&V", AuthType.BASIC)
      proxy.setTrustAllServers(true)
      proxy.start(proxyPort)
      options.addArguments(s"--proxy-server=localhost:${proxyPort}")
    }

    val capabilities = DesiredCapabilities.chrome()
    capabilities.setJavascriptEnabled(isJsEnabled)
    capabilities.setBrowserName(BrowserType.CHROME)
    capabilities.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true)

    options.addArguments("--incognito")
    options.merge(capabilities)
    new ChromeDriver(options)
  }

  private def createZapRemoteChrome: WebDriver = {

    new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), chromeOptions)
  }

  private def createZapLocalChrome: WebDriver = {

    new ChromeDriver(DesiredCapabilities.chrome().merge(chromeOptions))
  }

  private def chromeOptions: ChromeOptions = new ChromeOptions().
    addArguments("test-type").
    addArguments("--proxy-server=http://localhost:11000").
    addArguments("--start-maximized")

  sys.addShutdownHook(driverInstance.quit())
}
