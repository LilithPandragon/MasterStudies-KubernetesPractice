To start the application you just have to start ./deploy-k8s.ps1

##########################################################

Group 01 
  Harald Beier
  Susanne Peer
  Patrick Prugger

########################################################################################

# Aufgabenstellung:


Bis Ende des Semesters noch eine Abgabe, die Aufgabenstellung sieht wie folgt aus (Aufgabe in Moodle schreibe ich noch).

Schritt 1: Schreibt eine sehr einfache Applikation (Hello World oder ähnliches in irgendeiner Sprache), containerisiert diese 
und schreibt einmal ein Kubernetes Manifest dafür

Macht diesen Schritt bei Möglichkeit allein, und versucht euch bei Problemen in der Gruppe zu helfen. Typische Primitives die Ihr 
hier verwenden solltet sind Deployments, Services, ev. ConfigMaps und Secrets

Schritt 2: Versucht eine Applikation zu entwickeln, welche aus mehreren (mind. 3) Services besteht und schreibt ein Kubernetes 
Manifest dafür (60%)

Teilt euch die Arbeit so gut wie möglich auf, so dass jede*r von euch Teile implementiert
KISS (keep it simple, stupid): Ich werde die Applikation selbst nicht bewerten, für mich ist in dem Fall der Kubernetes Teil relevant
Folgt den Prinzipien der 12-factor apps (Stichwort Konfiguration, Logging, Port-binding,...)

Schritt 3: Schaut euch die Kubernetes Application Security Checklist an und implementiert 2-3 Aspekte in eurem Manifest 
(30% der Beurteilung bei 3 gewählten Aspekten)

https://kubernetes.io/docs/concepts/security/application-security-checklist/

https://www.cncf.io/wp-content/uploads/2022/06/CNCF_cloud-native-security-whitepaper-May2022-v2.pdf

Überlegt euch auch mögliche Angriffsszenarien und warum es Sinn macht, diese Aspekte zu konfigurieren

Hint: 3 davon sind ziemlich leicht umzusetzen

Schritt 4: Templating (10 % der Beurteilung, optional)

Überlegt euch, wie man eure Konfiguration am einfachsten konfigurierbar machen könnte 
Seht euch Tools wie Helm/Kustomize an und implementiert den von euch gewählten Ansatz
Delivery

Bitte gebt die Konfigurationen wieder in GitHub ab, sucht euch bitte wieder eine Partnergruppe, welche eure Pull Requests 
approved (je ein PR für Schritte 2-4)

Versucht diesmal schon von Haus aus zu unterbinden dass jemand direkt in den main branch pushed (Stichwort Branch Protection)
Stellt bitte auch sicher dass ich auf etwaige Container Images zugreifen kann (ghcr bzw. Dockerhub, public)
Beschreibung der gewählten Security Mechanismen und möglichen Angriffszenarien
Beurteilungskriterien:

Verteilung wie vorher beschrieben
Verwendung der richtigen primitives für die richtigen Anwendungsfälle
Anwendung der 12-factors

Uniqueness: Bitte stellt sicher dass nicht zwei Gruppen haargenau das selbe tun

Commit History: Im Idealfall sollten alle Gruppenmitglieder in etwa gleich viel beitragen und das sollte auch in der commit history ersichtlich sein

Dokumentation: Ich sollte in der Lage sein mit einem Command / Shell Script eure Konfiguration zum laufen zu bringen und zu verstehen wie eure 
Services miteinander kommunizieren (bitte auch das einfach halten)
