#!/bin/bash 

cat > ./manifests/ingress.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: default-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/certificate-arn: $1
    external-dns.alpha.kubernetes.io/hostname: $2
  labels:
    app: traefik
spec:
  - rules:
    http:
      paths:
        # HTTP to HTTPS redirect entry
        - path: /*
          backend:
            serviceName: ssl-redirect
            servicePort: use-annotation
        - path: /*
          backend:
            serviceName: traefik
            servicePort: 443
EOF