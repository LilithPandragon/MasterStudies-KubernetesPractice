# Overlays for Production (Prod)

### kustomization.yaml

Defines the resources, patches, and configurations for the `prod` environment.

- **Namespace**:
  - all resources are deployed in the `mcce-g1-prod` namespace

- **Resources**:
  - includes base manifests (`../../base`)
  - adds prod specific resources as `namespace.yaml` and `rabbitmq-secret.yaml`

- **Patches**:
  - applies customizations to base manifests:
    - `service-ports.yaml`: updates RabbitMQ ports for prod
    - `consumer-ports.yaml`: updates Consumer ports for prod
    - `consumer-env.yaml` and `producer-env.yaml`: updates RabbitMQ port environment variables
    - `rabbitmq-networkpolicy.yaml`, `consumer-networkpolicy.yaml`, and `producer-networkpolicyyaml`: adjusts network policies for prod

- **ConfigMapGenerator**:
  - creates a `ConfigMap` with production specific configurations:
    - `ENVIRONMENT=prod`
    - `CONSUMER_PORT=3000`

### namespace.yaml

creates a dedicated namespace for prod environment

- Name: `mcce-g1-prod`

---

### consumer-env.yaml

Updates the RabbitMQ port environment variable for consumer application

- sets `RABBITMQ_PORT` to `5673` for the Consumer deployment

---

### consumer-networkpolicy.yaml

Customizes the network policy for consumer application in prod

- **Ingress**:
  - allows TCP traffic on port 3000 (Consumer service)
  - allows RabbitMQ communication on ports 5672 and 5673

- **Egress**:
  - allows outgoing traffic to RabbitMQ on ports 5672 and 5673
  - permits DNS resolution (TCP and UDP on port 53)

---

### consumer-ports.yaml

Updates the service configuration for consumer application.

- changes the external port to `8081`
- forwards traffic to internal port `3000`

---

### producer-env.yaml

Updates the RabbitMQ port environment variable for producer application.

- sets `RABBITMQ_PORT` to `5673` for producer CronJob

---

### producer-networkpolicy.yaml

Customizes the network policy for the Producer application in production.

- **Egress**:
  - allows outgoing traffic to RabbitMQ on ports 5672 and 5673
  - permits DNS resolution (TCP and UDP on port 53)
  - grants access to Kubernetes DNS in the `kube-system` namespace

---

### rabbitmq-networkpolicy.yaml

Customizes the network policy for RabbitMQ in production.

- **Ingress**:
  - allows communication from producer and consumer pods on ports 5672 and 5673

- **Egress**:
  - allows communication to producer and consumer pods on ports 5672 and 5673

---

### service-ports.yaml

Updates the RabbitMQ service configuration.

- changes the external port to `5673`
- forwards traffic to internal port `5672`

---

### rabbitmq-secret.yaml

Provides the RabbitMQ credentials for production.

- **Type**: Opaque secret for storing sensitive data
- **Credentials**:
  - Base64-encoded `username` and `password`

---



