import pika # type: ignore
from datetime import datetime
from zoneinfo import ZoneInfo
import os
import json
import time

# Get RabbitMQ connection details from environment variables
rabbitmq_host = os.getenv('RABBITMQ_HOST', 'rabbitmq-service')
rabbitmq_port = int(os.getenv('RABBITMQ_PORT', '5672'))
rabbitmq_user = os.getenv('RABBITMQ_USER', 'guest')
rabbitmq_pass = os.getenv('RABBITMQ_PASS', 'guest')

# Create connection parameters
credentials = pika.PlainCredentials(rabbitmq_user, rabbitmq_pass)
parameters = pika.ConnectionParameters(
    host=rabbitmq_host,
    port=rabbitmq_port,
    credentials=credentials
)

def try_connect(parameters, max_retries=30, retry_delay=2):
    """Attempt to connect to RabbitMQ with retries"""
    print(f"Starting connection attempts to RabbitMQ at {parameters.host}:{parameters.port}")
    for attempt in range(max_retries):
        try:
            print(f"Connection attempt {attempt + 1}/{max_retries}...")
            connection = pika.BlockingConnection(parameters)
            print("Successfully connected to RabbitMQ!")
            return connection
        except Exception as e:  # Catch all exceptions
            if attempt == max_retries - 1:  # Last attempt
                print(f"Final attempt failed: {type(e).__name__}: {str(e)}")
                raise  # Re-raise the last exception
            print(f"Connection attempt {attempt + 1} failed: {type(e).__name__}: {str(e)}")
            print(f"Retrying in {retry_delay} seconds...")
            time.sleep(retry_delay)

try:
    # Establish connection with retry mechanism
    connection = try_connect(parameters)
    channel = connection.channel()

    # Declare queue
    queue_name = 'datetime_queue'
    channel.queue_declare(queue=queue_name, durable=True)

    # Create message with current datetime including timezone
    current_time = datetime.now(ZoneInfo("UTC")).strftime("%Y-%m-%d %H:%M:%S %Z")
    message = json.dumps({
        "timestamp": current_time,
        "data": f"The time is: {current_time}"
    })

    # Publish message
    channel.basic_publish(
        exchange='',
        routing_key=queue_name,
        body=message,
        properties=pika.BasicProperties(
            delivery_mode=2  # make message persistent
        )
    )

    print(f" [x] Sent '{message}'")

    # Close connection
    connection.close()

except Exception as e:
    print(f"Error: {str(e)}")
    exit(1) 