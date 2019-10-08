#!/bin/bash

sbt -Dbrowser=remote-chrome -Denvironment=qa -DturnOnProxy=yes "test-only uk.gov.hmrc.cucumber.runner.RunSmoke"
