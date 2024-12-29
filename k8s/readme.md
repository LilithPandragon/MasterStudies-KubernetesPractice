## **Deploying the project**
### **Steps to start the containers in k8s**
- Navigate to the k8s directory
- Run the deployment script

-  For Linux:
```
./deploy-k8s.sh
```
- For Windows:
```
./deploy-k8s.ps1
```
**The script performs the following tasks:**
   - Creates a namespace `mcce-g1`
   - Sets the context to the namespace `mcce-g1`
   - Generates RabbitMQ credentials and creates a secret file (`rabbitmq-secret.yaml`)
   - Deploys RabbitMQ, the Consumer service, and the Producer as a CronJob
   - Deploys the necessary network policies
   - Displays running pods and services

The generated credentials will be shown in the terminal at the end. Note them down for future use.
The credentials change with every deployment.


## *Service Communication*
*RabbitMQ:*
   - RabbitMQ is started via the `rabbitmq-deployment.yaml` deployment.
     Credentials are obtained from the `rabbitmq-secret.yaml` secret.
   - RabbitMQ has two services:
     - **AMQP Port (5672):** For messages between Producer and Consumer
     - **Management UI (15672):** Accessible via `rabbitmq-management` on the host on port 15672

*Producer (CronJob):*
   - Runs every minute according to `cronjob.yaml`
   - Produces messages and sends them to RabbitMQ (Hostname: `rabbitmq`, Port: `5672`)

*Consumer (Deployment and Service):*
   - Listens for messages from RabbitMQ
   - Exposes an HTTP service (Port: `8080`) via the LoadBalancer `consumer-service.yaml`


## **Deleting the Configuration**
*Execute the deletion script from:*
   - For Linux/MacOS:
     ```
     ./delete-deployment.sh
      ```
     
   - For Windows (PowerShell):
     ```
      ./delete-deployment.ps1
     ```
      
*The script removes:*
   - RabbitMQ Deployment, Secret, and Services
   - Producer (CronJob)
   - Consumer (Deployment and Service)
   - Network Policies
   - Namespace `mcce-g1`

## General Notes
- *Simple Communication:* RabbitMQ serves as a message center between Producer & Consumer
- *Configuration Changes:* Changes to the deployment strategy can be made in the corresponding
                          YAML files
- *Troubleshooting:* Use `kubectl logs` for debugging:
```
  kubectl logs <POD-NAME>
```
