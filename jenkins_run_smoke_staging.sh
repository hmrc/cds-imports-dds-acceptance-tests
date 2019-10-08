#!/bin/bash

sbt -Dbrowser=remote-chrome -Denvironment=staging "test-only uk.gov.hmrc.cucumber.runner.RunSmoke"
