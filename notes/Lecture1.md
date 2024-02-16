# Noter om hvad vi har lavet i lecture 1

- Lavet Github repo hvor vi hat lagt koden fra itu-minitwit i. Se slides for hvordan itu-minitwit kan findes
- Dannet overblik over itu-minitwit koden
- Migrere itu-minitwit til at kunne køre på en moderne Linux maskine
  - Installere python på Virtual Linux machine (VirtualBox)
  - Installere pip
  - Installere flask via pip
  - Installere sqlite3 (se task for this lecture)
  - Compile flag_tool.c : `make build`
  - Installere 2to3: `apt install 2to3`
  - Lave ændringer ved hjælp af 2to3: `2to3 -w .`
  - Se ændringerne: `diff minitwit.py minitwit-py.bak`
  - Ændrede i minitwit_test.py for at have rigtig type (python 2 -> python 3)
  - Brugte shellcheck til at opdatere control.sh
  - Lave et release på github