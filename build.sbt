import sbt.Resolver

name := "cds-imports-dds-acceptance-tests"

version := "0.1.0"

scalaVersion := "2.11.11"

scalacOptions ++= Seq("-unchecked", "-deprecation", "-feature")

resolvers += "hmrc-releases" at "https://artefacts.tax.service.gov.uk/artifactory/hmrc-releases/"
resolvers += Resolver.bintrayRepo("hmrc", "releases")

libraryDependencies ++= Seq(
  "com.typesafe.play"          %% "play-ahc-ws-standalone"  % "2.0.3",
  "com.typesafe.play"          %% "play-ws-standalone-json" % "2.0.3",
  "com.typesafe.play"          %% "play-json"               % "2.3.10",
  "org.mongodb.scala"          %% "mongo-scala-driver"      % "2.4.0",
  "uk.gov.hmrc"                %% "webdriver-factory"       % "0.7.0" % "test",
  "org.scalatest"              %% "scalatest"               % "3.0.7" % "test",
  "info.cukes"                 %% "cucumber-scala"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-junit"          % "1.2.5" % "test",
  "info.cukes"                 %  "cucumber-picocontainer"  % "1.2.5" % "test",
  "junit"                      %  "junit"                   % "4.12"  % "test",
  "com.novocode"               %  "junit-interface"         % "0.11"  % "test",
  "uk.gov.hmrc"                %% "zap-automation"          % "2.4.0"  % "test",
  "com.typesafe"               %  "config"                  % "1.3.2",
  "net.lightbody.bmp"          % "browsermob-core"          % "2.1.5",
  "com.google.guava"           % "guava"                    % "21.0"
  )

