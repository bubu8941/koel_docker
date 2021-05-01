# K8S manifests to deploy miniflux servers
_Those file are here to help to build your own.  
They can be used in a specific usecase with a one node k8s like minikube.  
Contribution are welcome to adapt this to a production-ready k8s cluster._

## 1 - Build your Koel docker image
_This step is here because it could be usefull to perform this step, ins case of buggy php version for instance._  

Do the following to proceed : 
```
cd ..
# Do  you changes 
docker build . -t local/koel
#Ensure you have : 
imagePullPolicy: Never
# in 5_koel_deploy.yml
```

## 2 - apply manifest
- Ensure to have your secrets filled in `secret` directory (cf examples).

- Do the following : 

```bash
kubectl apply -f 1_namespace.yml
kubectl apply -f 2_pv_pvc.yml
./3_secrets.sh
kubectl apply -f secrets/env-secret.yaml
kubectl apply -f 4_db.deploy.yml
kubectl apply -f 5_db_service.yaml
kubectl apply -f 6_koel_deploy.yml
kubectl apply -f 7_app_service.yaml
kubectl get services -n koel # and search for nodeport IP
wget <nodeport_IP> #to see if it answers
```
## 3 - Initialization
If it's the firstime koel is running ,  please do the following : 
```bash
kubectl get pods -n koel # to see if pods are running
app_pod=$(kgp -n koel |grep app | awk '{print $1}')
kubectl exec -it -n koel $app_pod -- /bin/bash # to go into pod
php artisan koel:init --no-assets # to init koel
php artisan koel:sync # to sync the music (could be veeeeery long XD, mustbe re-done if music is added to your server)
```

## 4 - First connection

- go to your application url
- Username: admin@koel.dev
- Password: KoelIsCool
- Change your password :D

## 5 - Other precisions
- Don't forget to avoid EOL caracter with mysql secrets. To be sure to have a mysql compatible secret do : 
  ```bash
     echo -n 'MyS3c43T' > my-mysql.secret
  ```

