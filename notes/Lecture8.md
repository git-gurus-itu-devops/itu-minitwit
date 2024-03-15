# Lecture 8

## NewRelic Logging

15-03-2024

* Installeret new relic infrastructure og logging agent på VM "droplet1"
* Tilføjet /etc/docker/daemon.log med konfiguration der får Docker til at skrive logs til syslog. Derefter genstartet via. systemctl
* Rettet /etc/newrelic-infra/logging.d/logging.yml så Docker Container logs ikke bliver samlet op, da de nu kommer fra syslog

## Register refactoring

15-03-2024

* Register endpoint er refactored til at bruge ActiveRecord validations i stedet for manuelle validations
