# Business-Analytics
## Installation Guide
### Packages Shiny
Vor der Ausführung muss in R Studio folgende Packages installiert sein:
```
install.packages("shinydashboard")
install.packages("hms")
install.packages("scales")
install.packages("plyr")
install.packages("dplyr")
install.packages("dbplyr")
install.packages("RSQLite")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("fmsb")
install.packages("hrbrthemes")
install.packages("treemap")
install.packages("shinyjs")
```

### Packages Django
Die entsprechenden Packages für die Web Applikation stehen in der requirements.txt und können mit:
```
pip install -r requirements.txt
```
im Terminal unter ~\Business-Analytics\TrainingsApp\training_app installiert werden.


### Shiny Server starten
- R Studio öffnen
- Projekt R.Rproj öffnen 
- in diesem Projekt app.R öffnen
- App durch den Button "Run App" starten

Anmerkung: sollte die App nicht den Port xx.xx.xx:9999/  nutzen muss die App nochmals geschlossen werden, die Datei .Rprofile geöffnet und ausgeführt werden. Anschließend sollte app.R mit dem richtigen Port starten.

### Django Applikation 
Visual Studio Code oder andere ähnliche IDE öffnen und auf der Ebene ~\Business-Analytics\TrainingsApp\training_app
```
python manage.py runserver
```
über das Terminal ausführen.

## Ausführung
Wenn beide Applikationen korrekt gestartet wurden, kann die Startseite auf http://127.0.0.1:8000/ gefunden werden.
Um direkt auf den Shiny Server zu gelangen, muss http://127.0.0.1:9999 genutzt werden, sollte die Port Definierung mit .Rprofile zuvor funktioniert haben.

## Projektaufteilung
Dies ist nur eine sporadische Aufteilung, da die meiste Arbeit während der Vorlesungszeit in ständiger Rücksprache im Team entstanden ist.

Django Webapplikation + Database --> Kai Horlacher
Shiny Server + Datenverarbeitung + Plot --> Cornelius Fichtner & Christoph Mattmann
