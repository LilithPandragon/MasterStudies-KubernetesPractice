#### **Steps to Build and Run the Configuration**

*Build and Push the Docker Image*:
   - Execute the `build.sh` script:
     bash build.sh
 
   - This script:
     - uses the current timestamp as the image version
     - builds and tags the Docker image
     - pushes both the versioned and `latest` image tags to the registry (`ghcr.io/mcce2024`)

*Run the Docker Container*:
   - Start the service using Docker:
     docker run -p 3000:3000 ghcr.io/mcce2024/akkt1-g1-consumer:latest
  
   - application will be accessible at `http://localhost:3000`

---

#### **Service Communication Overview**

- *RabbitMQ Integration*:
  - RabbitMQ connection details are dynamically configured using environment variables:
    ```
    RABBITMQ_HOST
    RABBITMQ_PORT
    RABBITMQ_USER
    RABBITMQ_PASS
    ```
  - The service consumes messages from a `datetime_queue` queue

- *Web Dashboard*:
  - Serves an interactive interface via `Express`:
    - view and refresh messages
    - clear messages stored in memory

- *Key Scripts*:
  - **`server.js`**:
    - establishes a connection to RabbitMQ
    - handles incoming messages and displays them on the web dashboard
  - **`package.json`**:
    - start the server:
      ```
      npm start
      ```
    - development mode with live reload:
      ```
      npm run dev
      ```
---

#### **Simplified Workflow**
Run the `build.sh` script to build and push the Docker image
Start the container using the `docker run` command
Access the web dashboard to view and manage messages

For more details, consult the source files:
- **`server.js`**: RabbitMQ and Express configuration
- **`package.json`**: Scripts and dependencies
