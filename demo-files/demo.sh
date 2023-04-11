# show deployment
k apply -f n1.yaml
k get pods
k get deploy
k get rs

# show rolling update
k get deploy -w # 2nd shell session
k get rs -w #3rd shell session
k apply -f n2.yaml # 1st shell session
k describe deployment hello-deployment # 1st shell session

# rollback
k rollout history deployment/hello-deployment --revision=2
k rollout undo deployment/hello-deployment
k describe deployment hello-deployment

# show recreate deployment
# show blue/green deployment
# show canary deployment