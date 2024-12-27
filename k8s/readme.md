## **Deployen der Konfiguration**
### **Schritte zum Starten**
Hierzu navigiere in das Verzeichnis, in dem sich die Skripte und YAML-Dateien befinden.
Führe das Bereitstellungsskript aus:
   - Für Linux/MacOS:
     ./deploy-k8s.sh
   
   - Für Windows (in powershell):
     ./deploy-k8s.ps1
    
Das Skript führt folgendes aus:
   - Generiert RabbitMQ Zugangsdaten und erstellt ein Secret (`rabbitmq-secret.yaml`)
   - Deployt RabbitMQ, den Consumer-Service und den Producer als CronJob
   - Zeigt laufenden Pods und Services an

Am Ende werden die generierten Zugangsdaten im Terminal angezeigt. Notiere sie für die weitere Nutzung.

######################################################################

## *Kommunikation der Services*
*RabbitMQ:*
   - RabbitMQ wird über das Deployment `rabbitmq-deployment.yaml` gestartet.
     Die Zugangsdaten werden aus dem Secret `rabbitmq-secret.yaml` bezogen.
   - RabbitMQ hat zwei Services:
     - **AMQP-Port (5672):** Für Nachrichten zwischen Producer und Consumer
     - **Management-UI (15672):** Über `rabbitmq-management` erreichbar

*Producer (CronJob):*
   - Läuft jede Minute gemäß dem `cronjob.yaml`
   - Produziert Nachrichten und sendet diese dann an RabbitMQ (Hostname: `rabbitmq`, Port: `5672`)

*Consumer (Deployment und Service):*
   - Lauscht/Hört auf Nachrichten von RabbitMQ
   - Exponiert einen HTTP-Service (Port: `8080`) über den LoadBalancer `consumer-service.yaml`

#######################################################################

## **Löschen der Konfiguration**
*Ausführen des Löschskript aus:*
   - Für Linux/MacOS:
     ./delete-deployment.sh

   - Für Windows (powershell):
     ./delete-deployment.ps1
  
*Das Skript entfernt:*
   - RabbitMQ Deployment, Secret und Services
   - Producer (CronJob)
   - Consumer (Deployment und Service)

#########################################################################

- *Einfache Kommunikation:* RabbitMQ dient als Nachrichtenzentrale zwischen Producer & Consumer
- *Konfigurationsänderungen:* Änderungen an der Deployment Strategie können in den entsprechenden
                              YAML-Dateien vorgenommen werden.
- *Fehlerbehebung:* `kubectl logs` für Debugging:

  kubectl logs <POD-NAME>

