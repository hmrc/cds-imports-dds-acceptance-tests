package uk.gov.hmrc.utils

import akka.actor.ActorSystem
import akka.stream.ActorMaterializer
import com.typesafe.config.ConfigFactory
import play.api.libs.ws.DefaultBodyWritables._
import play.api.libs.ws.ahc.{AhcWSClientConfigFactory, StandaloneAhcWSClient}
import play.api.libs.ws.{DefaultWSProxyServer, StandaloneWSRequest, WSCookie, WSProxyServer}
import uk.gov.hmrc.driver.BrowserDriver.turnOnProxy

import scala.concurrent.Future

object WSClient {
  private implicit val system: ActorSystem = ActorSystem()
  private implicit val mat: ActorMaterializer = ActorMaterializer()
  private val wsClient = StandaloneAhcWSClient(config = AhcWSClientConfigFactory.forConfig(ConfigFactory.load()))

  private val wsProxy: Option[WSProxyServer] = if (turnOnProxy.contains("yes")) {
    Some(DefaultWSProxyServer(host = "localhost", port = 16633, principal = Some("jenkins"), password = Some("$S4sJkIUkx")))
  } else {
    None
  }

  def httpGet(url: String, cookie: Set[WSCookie]=Set.empty, headers: Seq[(String, String)]=Nil): Future[StandaloneWSRequest#Response] = {
    def request(url: String): StandaloneWSRequest = {
      if (turnOnProxy.equalsIgnoreCase("yes")) {
        wsClient.url(url).withProxyServer(wsProxy.get)
      } else {
        wsClient.url(url)
      }
    }
    request(url).addHttpHeaders(headers:_*).withCookies(cookie.toSeq:_*).get()
  }

  def httpPost(url: String, requestBody: String, headers: (String, String)*) = {
    def request(url: String): StandaloneWSRequest = {
      if (turnOnProxy.equalsIgnoreCase("yes")) {
        wsClient.url(url).withProxyServer(wsProxy.get)
      } else {
        wsClient.url(url)
      }
    }
    request(url).withHttpHeaders(headers: _*).post(requestBody)
  }

}
