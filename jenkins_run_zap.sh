#!/bin/bash

sbt -Dbrowser=zap-remote-chrome -Dzap.proxy=true -Denvironment=local "test-only uk.gov.hmrc.cucumber.runner.RunZap"
sbt "testOnly uk.gov.hmrc.cucumber.runner.ZapSpec"