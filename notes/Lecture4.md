# Noter 23-02-2024

* 14:03 - Giver adgang til Digital Ocean til gruppemedlemmer, sætter Docker Hub op og sætter diverse repository secrets op
* 14:30 - Vi bruger Helge's yml workflow fil og tilpasser til vores setup. Vi opdaterer vores Vagrantfile til kun at synce `./remote_files`
* 14:50 - Vi diskuterer, hvordan vi bedst får en database ind på Digital Ocean. Vi aftaler, at vi sætter den ind i `./remote_files` så den bliver synced ind ved `vagrant up` kommandoen. Det har den effekt, at vores database ikke bliver gemt hvis vi genstarter vores VM på digital ocean (kører `vagrant up` på ny). Det vil dog lade os komme med releases og deploye selve kodebasen i Docker-containers uden behovet for at slette vores data. Vi snakker dog om muligheden for på sigt at gøre brug af at mounte volumes på vores VM frem for kun på vores Docker-containers. Det er et tilsvarende koncept som at mounte volumes på Docker Containers: https://docs.digitalocean.com/products/volumes/how-to/mount/ - Vi vurderer dog, at det er bedre at starte med den første løsning og så klare den her refactor når vi har tiden til det.
* 15:55 - Vi fjerner den del af vores Vagrantfile, der bygger og kører vores Docker-container. Det sker nu i stedet i Github Actions workflowet når der pushes til main.
* 16:03 - Vi vurderer, at interfacet ikke vil blive brugt særligt ofte, men at det kan hjælpe os med at se fejl i simulator-API'et hvis de to bruger samme database. Derfor ændrer vi fra at køre hver deres database til nu at bruge den samme.
* 16:32 - Vi bruger Helge's `docker-compose.yml` som inspiration til at lave vores eget, så vi nemt kan køre vores Docker-image på en container på vores virtual machine. Denne docker compose fil bliver brugt af vores `deploy.sh`, som er sidste step som vores Github Actions kører når den er SSH'et ind på vores VM.
* 16:59 - Vi forsøger at køre Github Actions workflowet ved at tilføje pattern matching på den branch, den bliver udviklet på (`cicd-pipeline`). Den fejler på steppet hvor den skal SSH ind på vores VM med en fejlbesked: 
```
Warning: Permanently added '***' (ED25519) to the list of known hosts.
Load key "/home/runner/.ssh/do_ssh_key": error in libcrypto
***@***: Permission denied (publickey).
```
* 17:13 - Vi finder ud af, at der er problemer med at SSH ind via `vagrant ssh`. Derfor forsøger vi at lave et nyt sæt SSH-keys og bruge disse i stedet, og konfigurerer dem på både Github Actions workflowet og Digital Ocean. Dette giver os adgang til kommandoen `vagrant ssh` men fejler stadig på Github Actions workflowet.
* 17:40 - Google viser nogle indikationer på, at det kan have noget med line-endings at gøre. SSH keysne er blevet genereret på en Windows maskine, og vi mistænker at fejlen er opstået på baggrund af CR/LF line-endings på Windows maskiner. Vi sidder dog uden andre laptops at teste med, og kan derfor ikke teste, om vi kan fixe problemet ved at lave SSH keys på et andet miljø.
* 18:05 - Vi forsøger at lave `ssh-keygen` på Windows Subsystem for Linux med Ubuntu 22.04.3 uden held.

# Noter 24-02-2024
* 14:15 - Forsøger igen med `rsa`-type SSH-key, ligesom givet i CI-guiden fra Helge uden held. Det samme gælder, ved forsøg på at tilføje newline ved slutningen af SSH private key på Github, inspireret af denne kommentar: https://github.com/openssl/openssl/issues/19487#issuecomment-1565402253
