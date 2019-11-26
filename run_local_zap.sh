#!/bin/bash

sbt -Dbrowser=chrome -Dzap.proxy=true -Denvironment=local "testOnly uk.gov.hmrc.cucumber.runner.RunZap"
sbt "testOnly uk.gov.hmrc.cucumber.runner.ZapSpec"