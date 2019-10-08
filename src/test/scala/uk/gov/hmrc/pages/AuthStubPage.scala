package uk.gov.hmrc.pages

import java.io.FileInputStream
import java.util.Properties

import uk.gov.hmrc.conf.TestConfiguration

object AuthStubPage extends AuthStubPage

trait AuthStubPage extends BasePage {

  override lazy val url = s"${TestConfiguration.settings.AUTH_LOGIN_STUB}"

  def logIn(user: String, redirectUrl: String) ={
    val pid = new scala.util.Random().nextInt(9999999).toString

    val eoriNumber = readEoriFromPropsFile(user)

    textField("authorityId").value = pid
    textField("redirectionUrl").value = redirectUrl
    singleSel("affinityGroup").value = "Organisation"

    textField("enrolment[0].name").value = "HMRC-CUS-ORG"
    textField("enrolment[0].taxIdentifier[0].name").value = "EORINumber"
    textField("enrolment[0].taxIdentifier[0].value").value = eoriNumber
  }

  private def readEoriFromPropsFile(user: String) = {
    val filePath = new FileInputStream("src/test/resources/testData.properties")
    val properties = new Properties()
    try {
      properties.load(filePath)
    }
    catch {
      case e: Exception => println("Exception in loading file")
    }
    finally {
      if (filePath != null) {
        try {filePath.close()}
        catch {
          case e: Exception => println("Exception on closing file")
        }
      }
    }
    properties.getProperty(user.replace(" ","-"))
  }
}
