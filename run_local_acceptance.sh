#!/bin/bash

sbt -Denvironment=local "test-only uk.gov.hmrc.cucumber.runner.RunAcceptance"
