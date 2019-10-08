#!/bin/bash

sbt -Dbrowser=remote-chrome -Denvironment=dev "test-only uk.gov.hmrc.cucumber.runner.RunSmoke"
