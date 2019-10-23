package uk.gov.hmrc.cucumber

import cucumber.api.DataTable

package object stepdefs {

  implicit class DataTableConverters(in:DataTable) {
    import scala.collection.JavaConverters._
    def asScalaListOfStrings:List[String] = in.raw().asScala.flatMap(_.asScala).toList
    def asScalaListOfMaps:List[java.util.Map[String, String]] = in.asMaps(classOf[String], classOf[String]).asScala.toList
  }

}
