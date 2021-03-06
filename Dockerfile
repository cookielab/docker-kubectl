FROM cookielab/alpine:3.10

ARG KUBE_VERSION

COPY src/connect.sh /usr/local/bin/kube-connect
COPY src/service.sh /usr/local/bin/kube-deploy-service
COPY src/ingress.sh /usr/local/bin/kube-deploy-ingress
COPY src/finish.sh /usr/local/bin/kube-finish-deploy
COPY src/destroy.sh /usr/local/bin/kube-destroy

RUN apk --update --no-cache add ca-certificates bash curl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

USER 1987
ONBUILD USER root
