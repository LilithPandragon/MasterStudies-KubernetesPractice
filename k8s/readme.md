## **Deploying the project**
### **Steps to start the containers in k8s**
- navigate to the k8s directory
- run the deployment script

   - Linux/MacOS:
   ```
   ./scripts/deploy-k8s.sh
   ```
   - Windows (PowerShell):
   ```
   ./scripts/deploy-k8s.ps1
   ```
**The script performs the following tasks:**
   - creates a namespace `mcce-g1-test` or `mcce-g1-prod`
   - sets context to the namespace `mcce-g1-test` or `mcce-g1-prod`
   - generates RabbitMQ credentials and creates a secret file (`rabbitmq-secret.yaml`)
   - deploys RabbitMQ, consumer service, and producer as a CronJob
   - deploys necessary network policies
   - patches deployment to use overlays
   - displays running pods and services

The generated credentials will be shown in the terminal at the end. Note them down for future use.
The credentials change with every deployment.

## *Service Communication*
*RabbitMQ:*
   - RabbitMQ is started via `rabbitmq-deployment.yaml` deployment
   - credentials are obtained from the `rabbitmq-secret.yaml` secret
   - RabbitMQ service layout:
      - Test
         - **AMQP Port (5672):** for messages between producer and consumer
         - **Management UI (15672):** Accessible via `rabbitmq-management` on the host on port 15672
      - Prod
         - **AMQP Port (5673):** for messages between producer and consumer

*Producer (CronJob):*
   - runs every minute according to `cronjob.yaml`
   - produces messages and sends them to RabbitMQ (Hostname: `rabbitmq`, Test Port: `5672`, Prod Port: `5673`)

*Consumer (Deployment and Service):*
   - listens for messages from RabbitMQ
   - exposes a HTTP service (Test Port: `8080`, Prod Port: `8081`) via LoadBalancer `consumer-service.yaml`


## **Deleting the Configuration**
*Execute the deletion script from:*
   - Linux/MacOS:
     ```bash
     ./scripts/delete-deployment.sh
      ```
     
   - Windows (PowerShell):
     ```bash
      ./scripts/delete-deployment.ps1
     ```
      
*The script removes:*
   - RabbitMQ deployment, secret, and services
   - producer (CronJob)
   - consumer (deployment and service)
   - network policies
   - namespace `mcce-g1-test` or `mcce-g1-prod`

## General Notes
- *Simple Communication:* RabbitMQ serves as a message center between producer & consumer
- *Configuration Changes:* changes to deployment strategy can be made in the corresponding
                          YAML files
- *Troubleshooting:* use `kubectl logs` for debugging:
   ```
   kubectl logs <POD-NAME>
   ```
