# AKTT1 Group 1 Kubernetes Deployment
```
Group 01 
Harald Beier 
Susanne Peer 
Patrick Prugger
```
# Step 2 Application - May the flower power be with you
## Branch Protection
> Activated but the rule from Github: *Your rules won't be enforced on this private repository until one of your organization's owners upgrades the account to GitHub Team or Enterprise.*

## Description for Usage
- WSL installed
- Rancher desktop installed
- IDE of Choice
- Project pulled
- Rancher desktop up and running
- To start the application you just have to run ./deploy-k8s.ps1
- To delete the application you just have to run ./delete-deployment.ps1
- 
## Description of functionality
- Producer generates JSON with datetime in UTC
- RabbitMQ is used as messaging queue
- Consumer uses JS for visualisation of JSON with minimal functionality (Refresh, Delete and a little extra because we love it if a plan is working)
- K8S manifest includes the configuration Yamls for the different services
  

## Architecture diagram
![Architecture diagram](drawio.png)

## 12 Factor App 
1. **Codebase:** github used as revision control. Dev and Main branches
2. **Dependencies:** Explicitly declare and isolate dependencies
3. **Config:** Store config in the environment
4. **Backing services:** Treat backing services as attached resources
5. **Build, release, run:** Strictly separate build and run stages
6. **Processes:** Execute the app as one or more stateless processes
7. **Port binding:** Export services via port binding
8. **Concurrency:** Scale out via the process model
9. **Disposability:** Maximize robustness with fast startup and graceful shutdown
10. **Dev/prod parity:** Keep development, staging, and production as similar as possible
11. **Logs:** Treat logs as event streams
12. **Admin processes:** Run admin/management tasks as one-off processes

## Pull-Request for Step 2
- Sent to Group 2
- Sent at 2024-12-27

# Step 3: Kubernetes Application Security Checklist and implement 2-3 aspects in your manifest 
## Base security hardening
- Application design 
- Service account
- Pod-level securityContext recommendations
- Container-level securityContext recommendations 
- Role Based Access Control (RBAC) 
- Image security
- Network policies

## **Security Configuration**
### **Base Security Hardening**
1. **Pod Security Context:**
   - Non-root user execution
   - Read-only root filesystem
   - Dropped capabilities
   - RunAsUser and fsGroup defined

2. **Container Security:**
   - Resource limits enforced
   - Latest base images used
   - No privileged containers

3. **RBAC Implementation:**
   - Service accounts with minimal permissions
   - Role-based access control for components
   - Namespace isolation

### **Network Policies**
The deployment includes NetworkPolicies to control pod-to-pod communication:

*RabbitMQ NetworkPolicy:*
- Restricts AMQP port (5672) access to only Producer and Consumer pods
- Management interface (15672) access:
  - Exposed via LoadBalancer

*Consumer NetworkPolicy:*
- Allows incoming traffic on port 3000 (web server)
- Permits bi-directional AMQP communication with RabbitMQ
- Enables DNS resolution (TCP/UDP port 53)

*Producer NetworkPolicy:*
- Allows outbound AMQP communication to RabbitMQ
- Enables DNS resolution (TCP/UDP port 53)


## Pull-Request for Step 3
- Sent to Group 2
- Sent at 2024-12-27
Unfortunately we pushed here to the same branch as the previous step.
So all commits are now in the same pull request.

# Step 4: Templating (optional)
Lessons learned:
-To avoid this problem for this step we have created a new branch called "templating".
