FROM cookielab/alpine:3.8

COPY src/connect.sh /usr/local/bin/kube-connect
COPY src/service.sh /usr/local/bin/kube-deploy-service
COPY src/ingress.sh /usr/local/bin/kube-deploy-ingress
COPY src/finish.sh /usr/local/bin/kube-finish-deploy
COPY src/destroy.sh /usr/local/bin/kube-destroy

RUN export KUBE_VERSION="v1.12.2" && \
    apk --update --no-cache add ca-certificates bash curl && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl
