## Overview of base configurations

# Consumer Configurations

### deployment.yaml

Defines the deployment for consumer application.

- **Resource Limits and Security:**
  - Container runs with non-root permissions (`runAsNonRoot: true`)
  - **Security Context:**
    - no privilege escalation allowed (`allowPrivilegeEscalation: false`)
    - minimal capabilities (`capabilities: drop: ALL`)
    - read-only root filesystem (`readOnlyRootFilesystem: true`)
  - CPU and memory are restricted (max. 500m CPU and 512Mi memory)

- **ServiceAccount:**
  - uses `consumer-sa` and disables automatic token mounting

- **Environment Variables:**
  - connects to RabbitMQ (`RABBITMQ_HOST`, `RABBITMQ_PORT`, `RABBITMQ_USER`, `RABBITMQ_PASS`)
  - port is loaded from a ConfigMap (`CONSUMER_PORT`)

- **Port:**
  - container exposes port 3000 for the service

---

### networkpolicy.yaml

Controls network access for consumer application.

- **PodSelector:**
  - applies to pods with the label `app: consumer`

- **Ingress (Incoming Traffic):**
  - allows TCP traffic on port 3000 (from web server)
  - allows communication from RabbitMQ pods (port 5672)

- **Egress (Outgoing Traffic):**
  - allows communication with RabbitMQ pods (port 5672)
  - allows DNS queries over UDP and TCP (port 53)

---

### service.yaml

Creates a service to make consumer accessible.

- **Type:** `LoadBalancer`
  - service is externally accessible

- **Ports:**
  - Port 8080 is the external access point
  - forwards requests to port 3000 in the pod (`targetPort`)

- **Labels and Annotations:**
  - **Labels:**
    - `app: consumer`: links to consumer pod
    - `serviceAccount: consumer-sa`: indicates its connection to ServiceAccount
  - **Annotations:**
    - `security.kubernetes.io/owner`: marks owner (e.g., "MCCE-G1")
    - `security.kubernetes.io/environment`: marks environment (e.g., "production" - prod)

---

### serviceaccount.yaml

Creates a ServiceAccount for consumer.

- **Name:** `consumer-sa`.

- **Security:**
  - `automount-service-account-token: "false"`:
    - prevents the ServiceAccount's token from being automatically mounted 

---

# Producer

### deployment.yaml

Defines the CronJob for producer application.

- **Schedule**:
  - runs every minute as specified by cron expression `"*/1 * * * *"`

- **Concurrency Policy**:
  - Ensures only one job runs at a time (`Replace`)

- **Security Context**:
  - runs as a non-root user (`runAsNonRoot: true`)
  - user and group IDs set to 1000 and 3000, respectively
  - **Container Security**:
    - no privilege escalation allowed (`allowPrivilegeEscalation: false`)
    - drops all capabilities (`capabilities: drop: ALL`)
    - read-only root filesystem (`readOnlyRootFilesystem: true`)

- **Resource Requests and Limits**:
  - Limits: 200m CPU, 256Mi memory
  - Requests: 100m CPU, 128Mi memory

- **Environment Variables**:
  - connects to RabbitMQ (`RABBITMQ_HOST`, `RABBITMQ_PORT`, `RABBITMQ_USER`, `RABBITMQ_PASS`)
  - credentials are securely sourced from a Kubernetes Secret (`rabbitmq-secret`)

- **Restart Policy**:
  - the job restarts only on failure (`OnFailure`)

---

### networkpolicy.yaml

Controls egress traffic from producer application.

- **PodSelector**:
  - targets pods with the label `app: producer`

- **Egress Rules**:
  - allows communication with RabbitMQ pods (port 5672)
  - permits DNS resolution (UDP and TCP on port 53)
  - grants access to the Kubernetes DNS service within the `kube-system` namespace

Restricts the producer's outgoing connections to enhance security while ensuring necessary functionality.

---
### serviceaccount.yaml

Defines a dedicated ServiceAccount for producer application.

- **Name**:
  - `rabbitmq-producer-sa`

- **Annotations**:
  - disables automatic mounting of the ServiceAccount token 
            (`automount-service-account-token: false`)  
  - marks the owner (`security.kubernetes.io/owner: MCCE-G1`)
  - specifies the environment (`security.kubernetes.io/environment: production`)  

---

# RabbitMQ

### deployment.yaml

Deploys RabbitMQ with a secure setup.

- **Replicas**:
  - runs a single instance of RabbitMQ (`replicas: 1`)

- **Security Context**:
  - runs with RabbitMQ-specific user and group IDs (`fsGroup: 999`, `runAsUser: 999`,          `runAsGroup: 999`)
  - runs as a non-root user (`runAsNonRoot: true`)
  - **Container Security**:
    - no privilege escalation allowed (`allowPrivilegeEscalation: false`)
    - drops all capabilities (`capabilities: drop: ALL`)

- **Ports**:
  - exposes port 5672 for AMQP communication
  - exposes port 15672 for management interface

- **Environment Variables**:
  - uses `RABBITMQ_DEFAULT_USER` and `RABBITMQ_DEFAULT_PASS` to configure default credentials
  - credentials are securely sourced from the `rabbitmq-secret`

---

### networkpolicy.yaml

Controls ingress and egress traffic for RabbitMQ.

- **PodSelector**:
  - targets pods with label `app: rabbitmq`

- **Ingress Rules**:
  - allows communication from pods with labels:
    - `app: producer`
    - `app: consumer`
  - permits management interface access on port 15672 (open to all sources; restrict for production)

- **Egress Rules**:
  - Allows RabbitMQ to communicate with:
    - producer pods (port 5672)
    - consumer pods (port 5672)

---

### rabbitmq-secret.example.yaml

Defines the structure for RabbitMQ credentials.

- **Type**:
  - secret type is `Opaque`, designed for arbitrary data storage

- **Placeholders**:
  - replace `<BASE64_ENCODED_USERNAME>` and `<BASE64_ENCODED_PASSWORD>` with base64-encoded credentials

---

### service.yaml

Creates a service to expose RabbitMQ internally within the cluster.

- **Type**:
  - `ClusterIP`: limits access to within Kubernetes cluster

- **Ports**:
  - exposes port 5672 for AMQP communication

- **Selector**:
  - targets pods with label `app: rabbitmq`

---

### serviceaccount.yaml

Defines a ServiceAccount for RabbitMQ

- **Name**:
  - `rabbitmq-sa`

- **Annotations**:
  - disables automatic token mounting (`automount-service-account-token: false`)
  - marks owner (`security.kubernetes.io/owner: MCCE-G1`)
  - specifies environment (`security.kubernetes.io/environment: production`)

---

# kustomization.yaml

## Purpose of `kustomization.yaml`

Kustomize is a Kubernetes-native configuration management tool. It enables the customization of Kubernetes resource manifests without modifying the original files. The `kustomization.yaml` file defines the resources and configurations to be deployed and allows overlays for environment-specific customization [Source: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/].

## Structure of `kustomization.yaml`

### File Overview:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- consumer/deployment.yaml
- consumer/service.yaml
- consumer/networkpolicy.yaml
- consumer/serviceaccount.yaml
- producer/deployment.yaml
- producer/networkpolicy.yaml
- producer/serviceaccount.yaml
- rabbitmq/deployment.yaml
- rabbitmq/service.yaml
- rabbitmq/networkpolicy.yaml
- rabbitmq/serviceaccount.yaml
```

**API Version and Kind**:
   - `apiVersion: kustomize.config.k8s.io/v1beta1`: specifies version of Kustomize being used
   - `kind: Kustomization`: declares type of the file as a Kustomize configuration

**Resources**:
   - lists all Kubernetes manifest files that are part of the base configuration
   - **Consumer Resources**:
     - `consumer/deployment.yaml`: defines deployment for consumer application
     - `consumer/service.yaml`: creates a service to expose consumer application
     - `consumer/networkpolicy.yaml`: controls network access for consumer
     - `consumer/serviceaccount.yaml`: specifies the ServiceAccount for consumer
   - **Producer Resources**:
     - `producer/deployment.yaml`: defines the deployment for producer application
     - `producer/networkpolicy.yaml`: controls network access for producer
     - `producer/serviceaccount.yaml`: specifies the ServiceAccount for producer
   - **RabbitMQ Resources**:
     - `rabbitmq/deployment.yaml`: deploys RabbitMQ with necessary configurations
     - `rabbitmq/service.yaml`: creates an internal service for RabbitMQ
     - `rabbitmq/networkpolicy.yaml`: regulates RabbitMQ network access
     - `rabbitmq/serviceaccount.yaml`: defines the ServiceAccount for RabbitMQ

