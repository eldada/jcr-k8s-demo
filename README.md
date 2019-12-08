# JFrog Container Registry Demo
This repository a demo with the technical steps of spinning up a secure, private (and free!)
[JFrog Container Registry](https://jfrog.com/container-registry/) in [Kubernetes](https://kubernetes.io/)
using the official [JCR Helm Chart](https://hub.helm.sh/charts/jfrog/artifactory-jcr) and uploading a locally built Docker image to it.

## Requirements
1. Docker
2. A running Kubernetes cluster
3. The [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) cli
4. [Helm client](https://github.com/helm/helm/releases)

## Steps

### Deploy JCR (using helm v3)
Use Helm (v3) to add the JFrog repository and deploy with the official JCR helm chart.
```bash
helm repo add jfrog https://charts.jfrog.io
helm install jcr jfrog/artifactory-jcr

```

### Setup JCR
Get the JCR setup as a Docker registry

1. [Option 1] Get JCR IP from load balancer if provisioned
```bash
# NOTE: It might take a few minutes before the public IP is ready
export JCR_IP=$(kubectl get service/jcr-artifactory-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo ${JCR_IP}

```

2. [Option 2] Use port forward to the service and access on localhost
```bash
kubectl port-forward jcr-artifactory-0 8081:8081 &
export JCR_IP=localhost

```

3. Browse to http://${JCR_IP} and follow on screen onboarding wizard. Create a Docker registry

### Docker image
1. Build a Docker image from the local [Dockerfile](Dockerfile)
```bash
docker build -t my-secret-app:0.0.1 .
```

2. Docker login
```bash
docker login -u admin ${JCR_IP}
```

3. Tag your local Docker image
```bash
docker tag my-secret-app:0.0.1 ${JCR_IP}/docker/my-secret-app:0.0.1
```

4. Push Docker image to JCR
```bash
docker push ${JCR_IP}/docker/my-secret-app:0.0.1
```

### Remove JCR (using helm v3)
Once done, you can easily remove JCR with helm
```bash
helm uninstall jcr

# Remove left over PVCs if needed
kubectl get pvc

kubectl delete pvc ...

```
