# pay attention to echo -n 'secret' > my-secret.secret
# without that, mysql will be broken
kubectl create  secret -n koel generic koel-credentials \
   --from-file=secrets/mysql-password.secret \
   --from-file=secrets/mysql-root-password.secret