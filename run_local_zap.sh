#!/bin/bash

sbt -Dbrowser=zap-local-chrome -Denvironment=local "testOnly uk.gov.hmrc.cucumber.runner.RunZap"
sbt "testOnly uk.gov.hmrc.cucumber.runner.ZapSpec"