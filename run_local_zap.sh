#!/bin/bash

sbt -Dbrowser=zap-local-chrome -Dzap.proxy=true -Denvironment=local "testOnly uk.gov.hmrc.cucumber.runner.RunZap"
sbt "testOnly uk.gov.hmrc.cucumber.runner.ZapSpec"