# Noter til lecture 3

* 12:52 - Vi har delt os i 2 grupper, et api hold og et digital ocean hold

* 13:00 - API gruppen starter på latest endpoint

* 13:02 - API gruppen vælger register endpoint, da de havde en anden forforståelse for latest endpoint

* 13:07 - En fra API-gruppen opretter en branch med den gamle python flask application baseret på første commit mens de øvrige fjerner den gamle applikation. Dette inkluderer at opdatere `control.sh` til ruby applikationen.

* 13:29 - API-gruppen sletter python filter for at rydde op

* 13:51 - API-gruppen har oprettet `./common/util/user_utils.rb` for at dele kode mellem almindelig API og simulator-API'en.

* 14:27 - Problemer med at køre tests mod API. Sandsynligvis i forbindelse med hvilken database vi kører API-simulatoren i.

* 14:35 - Tests på /register giver en JSON decode error men uden tydelig stacktrace for problemet.

* 14:55 - API-holdet opdager, at der er små forskelle på API-specs for app og api-simulatoren. Appen forventer password og password2 på /register mens simulator-APIen forventer "pwd" i stedet.

* 14:59 - Første test på /register virker på nær den del, der tester at /latest er opdateret.