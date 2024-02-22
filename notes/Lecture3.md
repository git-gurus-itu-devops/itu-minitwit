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

## Andreas T & Mads

### 16-02-2024

* 12:27 - Kigger på DigitalOcean hjemmeside

* 12:45 - Laver en digital ocean account

* 12:52 - Installerer vagrant-digitalocean plugin

* 12:55 - Tilføjer digital_ocean box

* 12:56 - Genererer ny ssh key (ed25519) og tilføjer til DigitalOcean account

* 12:58 - Genererer ny Personal Access Token på DO

* 13:00 - kører vagrant init og paster content fra: https://rdarida.medium.com/creating-and-provisioning-a-digitalocean-droplet-dca8ba0f87f1

* 13:05 - Ændrer PAT og SSH key variabler til at bruge ENV, tilføjer til system variabler (windows)

* 13:07 - kører vagrant up

* 13:07 - Fejler fordi den prøver at generere SSH key selvom den eksisterer

* 13:19 - Fjerner SSH key fra DigitalOcean og lader Vagrant indsætte den. Dette fikser problemet men ny fejl, image invalid

* 13:20 - Retter image fra ubuntu-18-04-x64 til ubuntu-22-04-x64

* 13:20 - Fejl: This size is invalid - retter size til 's-1vcpu-1gb'

* 13:25 - Ny size virker og droplet1 blivet spawnet korrekt

* 13:30 - Tilføjer docker installering til provision script

* 13:45 - Bruger SCP til at kopiere lokale filer til serveren da "vagrant upload" fejler

* 13:50 - Bygger docker image i remote maskine med "docker build . -t minitwit"

* 13:52 - Bruger SCP til at rykke production database til server

* 14:00 - Åbner interaktiv docker prompt med docker run -v $(pwd):/app -it minitwit

* 14:01 - Kører database migrations i billedet: "bundle exec rake db:migrate"

* 14:02 - Starter app detached med: "docker run -d -v $(pwd):/app -p 5000:5000 minitwit"

* 14:03 - App kører nu på http://67.205.156.216:5000/public

### 19-02-2024

* 11:29 - Laver en Reserved IP til droplet via DigitalOcean interface

* 11:30 - App kører nu på http://134.209.131.46:5000/

### 20-02-2024

* 15:00 - Det går op for gruppen at API også skal deployes, så Vagrantfile skal rettes

* 15:30 - Vagrantfile bliver rettet til at bruge en navngivet SSH-key som bruger navnet fra miljøvariablen 'SSH\_KEY\_NAME'

* 15:19 - Vagrantfile bliver rettet til at bruge en "synced folder" så SCP ikke længere er nødvendigt.

* 15:20 - Vagrantfile bliver rettet til at provision en enkelt vm der kører både API og Interface som to docker containere

* 15:30 - Nogle problemer med at få docker containere til at starte 

### 21-02-20245

* 20:30 - Der er blevet lavet to shell scripts "api.sh" og "interface.sh" som bruges som entrypoint til de to docker containere

* 20:35 - Deploy kører korrekt igennem og app kan nu findes på http://165.227.245.161:5001 og http://165.227.245.161:5000


