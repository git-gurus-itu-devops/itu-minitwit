* 12:25 - vi diskuterer valg af framework
* 12:30 - Ruby with sinatra babyyyy
* 12:39 - `gem install bundler` til dependency mangament
  * `bundle init` til at lave gem file
  * Tilføjer puma til gemfile -> `bundle add puma`
  * Laver en test index (myapp.rb) fil til Sinatra
  * kør test fil `bundle exec ruby myapp.rb` -> Den fejler fordi den mangler rackup
	 `bundle add rackup`
* 12:46 - Vi blev enige om at bruge den ruby version der ligger i apt som standard (3.0.2)
	  For at enforce det her laves en .ruby-version fil, med indhold 3.3.0
* 12:58 - Der er nogle problemer med at installerer gems på visse maskiner (FilePermissionError)
* 13:02 - Vi kommer uden om problemer ved at installere "rbenv" igennem homebrew
* 13:09 - Vi havde nogle problemer med rbenv, fordi /usr/local/share ikke var ejet af brugeren.
  * `chown -R <user> /usr/local/share` fixede dette
* 13:12 - Vi vælger at bruge 3.3.0 i stedet da vi alligevel alle sammen bruger rbenv (`rbenv install 3.3.0`)
* 13:15 - Vi installerer Homebrew til Linux (linuxbrew) for at kunne installere rbenv og ruby-build.
* 13:15 - Sætter ruby 3.3.0 som standard version (`rbenv global 3.3.0`)
* 13:20 - rbenv skal init når terminalen startes
  * tilføjes til .zshrc `eval “$(rbenv init -)”`
* 13:30 - De nye test er grønne for nogen, men ikke andre
  * Kopier database til forventet sti `cp minitwit.db /tmp/minitwit.db`
* 13:30 - Linuxbrew tager ekstremt lang tid om at installere, men bliver færdig. Alle linuxbrew operationer tager dog meget lang tid.
* 13:40 - Et gruppemedlem har oplevet lignende problemer tidligere og oplevede at root cause var prolemer med WSL's DNS-lookup. Dette fikses ved at indsætte `[networking] generateResolvConf = false` i `/etc/wsl.conf`. Herefter slettes `/etc/resolv.conf` og en ny tilføjes med indholdet `nameserver 8.8.8.8` eller lignende DNS-server, og denne fil gøres immutable med `sudo chattr +i resolv.conf`. Dette tvinger WSL til at bruge en bestemt nameserver og efter dette fikses netværk-hastighed.

* 13:50 - Vi installerer dependencies så sinatra kan tale med db
  * `bundle add activerecord`
  * `bundle add sinatra-activerecord`
  * `bundle add rake`


MANDAG
* 9:45 - Vi laver en .standardrc for at normalisere kode gruppen skriver
* 9:48 - StringLiterals reglen i standard skal ignores
* 9:50 - Alle bedes installerer følgende VS code extensions:
  * Ruby Solargraph
  * Standard Ruby
  * Ruby (Den fra shopify)
* 10:00 - Vi prøver at lave et test endpoint der returnerer sidste besked. Dette kræver at vi opretter en model (message.rb)
* 10:05 - Endpointet fejler fordi database tabel hedder "message" og ikke "messages" - Vi overskriver manuelt table name med self.table_name = :message
* 11:00 - Problemer med at gemme hashed password i databasen fordi ActiveModel.has_secure_password gemmer til `password_digest` attr, som ikke findes i db
* 11:10 - vi renamer eksisterende `pw_hash` kolonne til `password_legacy` og laver en ny kolonne der hedder `password_digest` for at understøtte has_secure_password
* 16:00 - Jeg glemte at lave noter

TORSDAG
* 10:20 - Hvis man får fejl ved at køre migrations kan det være fordi at der ligger en gammel database i tmp. For at løse dette så slet databasen i tmp ved `rm /tmp/minitwit.db` og initialliser databasen igen med `./control.sh init`
* 10:39 - `mkdir log` i repo for at `make test` virker