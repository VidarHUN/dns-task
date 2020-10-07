# How to use local docker images in minikube 

```
eval $(minikube docker-env)
```

Build the image. 

Undo

```
eval $(minikube docker-env -u)
```