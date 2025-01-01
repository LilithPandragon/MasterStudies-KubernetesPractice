# Producer - Setup
Used libaries and coding language
- [pika 1.3.2](https://pypi.org/project/pika/) for implementation of the AMQP 0-9-1 protocol including RabbitMQ’s extensions.

Used docker image from dockerhub
- [Python 3.9](https://github.com/docker-library/python/blob/master/3.9/slim-bullseye/Dockerfile)

## Function:
-  Within producer.py will the queue **datetime_queue** is declared and a connection is opened to the RabbitMQ instance
-  Afterwards a message will be created with the current datetime including timezone
-  Then the data is published to the queue as JSON
-  All messages of the application are sent to STDOUT and can be access with kubectl logs
### **Steps to Build and Run the Configuration**

*Build and Push the Docker Image*:
- navigate to the producer directory
- run the deployment script

   - Linux/MacOS:
   ```
   ./build.sh
   ```
   - Windows (PowerShell):
   ```
   ./build.ps1
   ```
 
   - This script:
     - uses the current timestamp as the image version
     - builds and tags the Docker image
     - pushes both the versioned and `latest` image tags to the registry (`ghcr.io/mcce2024`)
     - Additionally checks for a correct GITHUB_TOKEN if not a push is prohibited

*Run the Docker Container*:
   - Start the service using Docker:
     docker run -p 3000:3000 ghcr.io/mcce2024/akkt1-g1-producer:latest
   - application is not accessible through localhost and port because 
> Action is no longer needed because there is a github action for this `build (producer)`
---
### **Service Communication Overview**

- *RabbitMQ Integration*:
  - RabbitMQ connection details are dynamically configured using environment variables:
    ```
    RABBITMQ_HOST
    RABBITMQ_PORT
    RABBITMQ_USER
    RABBITMQ_PASS
    ```
  - The service pushes messages to the `datetime_queue` queue with pika

- *def try_connect*:
  - Establishes the connection with pika to RabbitMQ
    - parameters `max_retries=30, retry_delay=2`
    - establishes connection if not
    - retries after `retry_delay=2`
- *try*:
  - Declares in RabbitMQ a queue_name `datetime_queue` this is needed for the consumer service
    - Creates a JSON with datetime and zone information `datetime.now(ZoneInfo("UTC")).strftime("%Y-%m-%d %H:%M:%S %Z")`
    - Publishes the JSON to the channel   
    
- *Key Scripts*:
  - **`producer.py`**:
    - establishes a connection to RabbitMQ
    - tries to establish a connection 30 retries
    - generates a JSON with time and zone information
    - pushes this JSON into the RabbitMQ channel

---
## Kubernetes
- in the k8s folder resides the base folder and producer folder there exist the deployment.yaml file
- the producer container is run as a cronjob every minute and publishes the created JSON within the **datetime_queue** to rabbitmq
-  afterwards the consumer will consume the message from the queue
