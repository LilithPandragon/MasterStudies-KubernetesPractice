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
## Kubernetes
- in the k8s folder resides the cronJob.yaml file
- the producer container is run as a cronjob every minute and publishes the created JSON within the **datetime_queue** to rabbitmq
-  afterwards the consumer will consume the message from the queue
