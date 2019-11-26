#!/bin/bash

sbt -Denvironment=local -Dbrowser=chrome "test-only uk.gov.hmrc.cucumber.runner.RunWip"
