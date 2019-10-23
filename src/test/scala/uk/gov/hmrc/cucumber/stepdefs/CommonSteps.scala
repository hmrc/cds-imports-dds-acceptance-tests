package uk.gov.hmrc.cucumber.stepdefs

import cucumber.api.PendingException
import org.scalatest.AppendedClues
import uk.gov.hmrc.conf.TestConfiguration
import uk.gov.hmrc.pages._
import uk.gov.hmrc.utils.DropMongo._
import uk.gov.hmrc.utils.WSClient

import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._

class CommonSteps extends CustomsImportsWebPage with AppendedClues  {

  Given("""^PENDING""") { () =>
    throw new PendingException()
  }

  Given("""^the (.*) feature is (.*)""") { (feature: String, featureState: String) =>
    TestConfiguration.environment.toString match {
      case "Local" => toggleFeatureSwitch(feature, featureState)
      case _ => None
    }
  }

  private def toggleFeatureSwitch(feature: String, featureState: String) = {
    val featureName = feature.toLowerCase().replace(" ", "-")
    val featureAction: String = featureState match {
      case "suspended" => "suspend"
      case "enabled" => "enable"
      case "disabled" => "disable"
      case _ => featureState
    }

    val result = FeatureSwitchPage(featureName, featureAction).featureToggle
    result should be(true) withClue ", Feature could not be toggled"
  }

  When("""^I navigate to the (.*) page$""") { page: String =>
    page match {
      case "Hello World" => HelloWorldPage.goToPage()
      case "Submit Declaration" => SubmitDeclarationPage.goToPage()
    }
  }

  Then("""^I should (not |)see the (sub-|)heading "([^"]*)"$""") { (notWord: String, subWord: String, expectedHeadingText: String) =>
    val headingTag = if (subWord.isEmpty) "h1" else "h2"
    assertElementInPageWithText(headingTag, notWord.isEmpty, expectedHeadingText)
  }

  When("""^I click on the link (.*)$""") { selectedLink: String =>
    click on partialLinkText(selectedLink)
  }

  Given("""^My app is registered to Dec API$""") {() =>
    val body = """{
                 |"clientId": "cds-imports-dds",
                 |"callbackUrl": "http://localhost:9760/customs/imports/notification",
                 |"token": "secret-token"
                 |}""".stripMargin
    val headers = List("Content-Type" -> "application/json")
    val response = WSClient.httpPost("http://localhost:6790/customs-declarations-stub/admin/client", body, headers:_*)
    val result = Await.result(response.map(_.status), 5 seconds)
    assert(result == 201, s"Update to mongo failed with error code $result")
  }

  And("""^dec api is configured to send success response message$""") {() =>
    val body = """<md:MetaData xmlns:md="urn:wco:datamodel:WCO:DocumentMetaData-DMS:2">
                 |	<md:WCODataModelVersionCode>3.6</md:WCODataModelVersionCode>
                 |	<md:WCOTypeName>RES</md:WCOTypeName>
                 |	<md:ResponsibleCountryCode/>
                 |	<md:ResponsibleAgencyName/>
                 |	<md:AgencyAssignedCustomizationCode/>
                 |	<md:AgencyAssignedCustomizationVersionCode/>
                 |	<resp:Response xmlns:resp="urn:wco:datamodel:WCO:RES-DMS:2">
                 |		<resp:FunctionCode>01</resp:FunctionCode>
                 |		<resp:FunctionalReferenceID>Mf1kMq9AKW5tQyRog8V</resp:FunctionalReferenceID>
                 |		<resp:IssueDateTime>
                 |			<_2_2:DateTimeString formatCode="304" xmlns:_2_2="urn:wco:datamodel:WCO:Response_DS:DMS:2">20180119155357Z</_2_2:DateTimeString>
                 |		</resp:IssueDateTime>
                 |		<resp:Declaration>
                 |			<resp:AcceptanceDateTime>
                 |				<_2_2:DateTimeString formatCode="304" xmlns:_2_2="urn:wco:datamodel:WCO:Response_DS:DMS:2">20171001000000Z</_2_2:DateTimeString>
                 |			</resp:AcceptanceDateTime>
                 |			<resp:FunctionalReferenceID>Import_Accepted</resp:FunctionalReferenceID>
                 |			<resp:ID>18GBJCM3USAFD2WD51</resp:ID>
                 |			<resp:VersionID>1</resp:VersionID>
                 |		</resp:Declaration>
                 |	</resp:Response>
                 |</md:MetaData>""".stripMargin

    postNotificationToDecApi(body)
  }

  And("""^dec api is configured to send a rejected response message$""") { () =>
    val body =
      """<_2:MetaData xmlns:_2="urn:wco:datamodel:WCO:DocumentMetaData-DMS:2">
        |    <_2:WCODataModelVersionCode>3.6</_2:WCODataModelVersionCode>
        |    <_2:WCOTypeName>RES</_2:WCOTypeName>
        |    <_2:ResponsibleCountryCode/>
        |    <_2:ResponsibleAgencyName/>
        |    <_2:AgencyAssignedCustomizationCode/>
        |    <_2:AgencyAssignedCustomizationVersionCode/>
        |    <_2_1:Response xmlns:_2_1="urn:wco:datamodel:WCO:RES-DMS:2">
        |        <_2_1:FunctionCode>03</_2_1:FunctionCode>
        |        <_2_1:FunctionalReferenceID>Mf1kMq9AKW5tQyRog8V</_2_1:FunctionalReferenceID>
        |        <_2_1:IssueDateTime>
        |            <_2_2:DateTimeString formatCode="304" xmlns:_2_2="urn:wco:datamodel:WCO:Response_DS:DMS:2">20191023124817Z</_2_2:DateTimeString>
        |        </_2_1:IssueDateTime>
        |        <_2_1:Error>
        |            <_2_1:ValidationCode>CDS12050</_2_1:ValidationCode>
        |            <_2_1:Pointer>
        |                <_2_1:DocumentSectionCode>42A</_2_1:DocumentSectionCode>
        |            </_2_1:Pointer>
        |            <_2_1:Pointer>
        |                <_2_1:DocumentSectionCode>67A</_2_1:DocumentSectionCode>
        |            </_2_1:Pointer>
        |            <_2_1:Pointer>
        |                <_2_1:SequenceNumeric>1</_2_1:SequenceNumeric>
        |                <_2_1:DocumentSectionCode>68A</_2_1:DocumentSectionCode>
        |            </_2_1:Pointer>
        |            <_2_1:Pointer>
        |                <_2_1:DocumentSectionCode>70A</_2_1:DocumentSectionCode>
        |                <_2_1:TagID>166</_2_1:TagID>
        |            </_2_1:Pointer>
        |        </_2_1:Error>
        |        <_2_1:Declaration>
        |            <_2_1:FunctionalReferenceID>Mf1kMq9AKW5tQyRog8V</_2_1:FunctionalReferenceID>
        |            <_2_1:ID>19GBBQACB980OFGV07</_2_1:ID>
        |            <_2_1:RejectionDateTime>
        |                <_2_2:DateTimeString formatCode="304" xmlns:_2_2="urn:wco:datamodel:WCO:Response_DS:DMS:2">20191023124817Z</_2_2:DateTimeString>
        |            </_2_1:RejectionDateTime>
        |            <_2_1:VersionID>1</_2_1:VersionID>
        |        </_2_1:Declaration>
        |    </_2_1:Response>
        |</_2:MetaData>
        |""".stripMargin

    postNotificationToDecApi(body)
  }

  private def postNotificationToDecApi(body: String) = {
    val bearerToken = getBearerToken
    val headers = List("Accept" -> "application/vnd.hmrc.1.0+xml",
                    "Content-Type" -> "application/xml",
                    "Authorization" -> bearerToken,
                    "X-Submitter-Identifier" -> "GB123",
                    "X-Client-Id" -> "cds-imports-dds")

    val response = WSClient.httpPost("http://localhost:6790/customs-declarations-stub/admin/notification/cds-imports-dds/submit/Mf1kMq9AKW5tQyRog8V", body, headers: _*)
    val result = Await.result(response, 5 seconds)
    assert(result.status == 201, s"POST to DEC-API failed with error code $result")
  }

  And("""^the mongo database is dropped$""") { () =>
    dropMongo("customs-declarations-stub")
  }

  And("""^I wait for (\d+) seconds$""") { seconds: Int =>
    Thread.sleep(seconds*1000)
  }

}
