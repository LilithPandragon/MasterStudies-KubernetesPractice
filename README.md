# Group 1 Kubernetes Deployment
```
Group 01 Harald Beier Susanne Peer Patrick Prugger
```
# Step 1
## Branch Protection
- Activated but the rule from Github: ==Your rules won't be enforced on this private repository until one of your organization's owners upgrades the account to GitHub Team or Enterprise.==
## Description for Usage
- WSL installed
- Rancher desktop installed
- IDE of Choice
- Project pulled
- Rancher desktop up and running
- To start the application you just have to start ./deploy-k8s.ps1
## Description of functionality
- Producer generates JSON with datetime in UTC
- RabbitMQ is used as messaging queue
- Consumer uses JS for visualisation of JSON with minimal functionality (Refresh, Delete and a little extra)
- K8S manifest includes the configuration Yamls for the different services
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

