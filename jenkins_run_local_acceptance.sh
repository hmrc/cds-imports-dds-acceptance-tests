#!/bin/bash

sbt -Dbrowser=remote-chrome -Denvironment=local "test-only uk.gov.hmrc.cucumber.runner.RunAcceptance"
