# Producer - Setup
Used libaries and coding language
- [pika 1.3.2](https://pypi.org/project/pika/) for implementation of the AMQP 0-9-1 protocol including RabbitMQ’s extensions.
- [Pyhton 3.9](https://github.com/docker-library/python/blob/master/3.9/slim-bullseye/Dockerfile)

## Function:
-  Within producer.py will be first connection to RabbitMQ and declaring a queue **datetime_queue**
-  Afterwards there will be a  message created with current datetime including timezone as JSON
-  This will be published to the queue that before was created
-  With print error and message will be sent to kubectl standard out logging (only existing during runtime of producer)
