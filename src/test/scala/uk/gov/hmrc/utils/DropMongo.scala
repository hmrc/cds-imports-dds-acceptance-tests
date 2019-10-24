package uk.gov.hmrc.utils

import org.mongodb.scala.MongoClient

import scala.concurrent.Await
import scala.concurrent.duration._


object DropMongo extends DropMongo
trait DropMongo {

  def dropMongo(dbName: String): Unit = {
    val mongoClient: MongoClient = MongoClient()
    Await.result(
      mongoClient
        .getDatabase(dbName)
        .drop()
        .head(),
      2 seconds
    )
    mongoClient.close()
  }

}