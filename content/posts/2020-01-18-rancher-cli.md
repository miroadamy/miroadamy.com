---
title: "Rancher CLI vs kubectl"
date: 2020-01-18T11:22:48+08:00
published: true
type: post
categories: ["devops"]
tags: ["kubernetes","rancher"]
author: "Miro Adamy"
---

# Accessing Rancher cluster

After creation, you can access the K8s cluster running Rancher by saving the config file available from the console and using standard ``kubectl`` command

![](/images/rancher-console-1.png)

```
kubectl --kubeconfig ./quickstart.kubeconfig get pods --all-namespaces
NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE
cattle-system   cattle-cluster-agent-5c98cb979f-bbhxf     1/1     Running     0          5d23h
cattle-system   cattle-node-agent-dwnxk                   1/1     Running     0          5d23h
cattle-system   kube-api-auth-d4zgq                       1/1     Running     0          5d23h
ingress-nginx   default-http-backend-67cf578fc4-grmsw     1/1     Running     0          5d23h
ingress-nginx   nginx-ingress-controller-mpnmb            1/1     Running     0          5d23h
kube-system     canal-jw85q                               2/2     Running     0          5d23h
kube-system     coredns-5c59fd465f-47q5z                  1/1     Running     0          5d23h
kube-system     coredns-autoscaler-d765c8497-sm5xf        1/1     Running     0          5d23h
kube-system     metrics-server-64f6dffb84-bp864           1/1     Running     0          5d23h
kube-system     rke-coredns-addon-deploy-job-95qnk        0/1     Completed   0          5d23h
kube-system     rke-ingress-controller-deploy-job-brv7w   0/1     Completed   0          5d23h
kube-system     rke-metrics-addon-deploy-job-tvt89        0/1     Completed   0          5d23h
kube-system     rke-network-plugin-deploy-job-7rqcr       0/1     Completed   0          5d23h
```

The same information (and much more) is available using rancher CLI.

## Using Rancher CLI

After downloading and installing Rancher CLI (see https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/cli/) we need API keys to authenticate against cluster.

The URL is https://CLUSTER-IP/apikeys - see

![](/images/rancher-console-2.png)

Generate new token and make sure there is NO SCOPE selected. If you generate token scoped to cluster (it seems to be the intuitively correct choice) the token will not work and will lead to this error message:

```
 rancher login https://18.204.194.218/v3 --token token-jbh7m:4zrjfbzvqtq9lbtkzzw2pckfd8r6qd9542dhqwrr2nh6gjf4f6wtlw
The authenticity of server 'https://18.204.194.218' can't be established.
Cert chain is : [Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 7227871200284629574 (0x644e8e8fcf3dda46)
    Signature Algorithm: SHA256-RSA
        Issuer: O=the-ranch,CN=cattle-ca
        Validity
            Not Before: Jan 14 14:27:54 2020 UTC
            Not After : Jan 15 16:37:21 2021 UTC
        Subject: O=the-ranch,CN=cattle
        Subject Public Key Info:
            Public Key Algorithm: RSA
                Public-Key: (2048 bit)
                Modulus:
                    ba:ee:fc:fb:b1:76:98:3d:58:59:bf:e2:bf:be:46:
                    ab:c8:43:89:97:7a:0d:da:71:dd:25:c9:31:3c:86:
                    7e:97:1d:5a:3a:95:77:ba:6f:20:77:ea:8d:84:f9:
                    8a:a4:1b:3c:e5:79:c5:e3:5b:d2:c9:19:ef:6f:fe:
                    e4:6e:e6:06:89:42:d2:81:e8:b1:b2:cf:96:18:4a:
                    41:cf:5e:4a:99:3c:c7:80:38:45:42:3f:fa:1c:0f:
                    cf:a9:26:74:d6:8a:ab:62:c4:fd:8a:77:73:c8:d5:
                    76:40:eb:ff:72:4d:b1:85:cf:d5:8a:ca:8d:d3:a8:
                    f4:b2:c3:77:2d:44:66:e0:b2:f4:3a:c3:3f:a1:0f:
                    56:4c:71:45:4d:da:d6:63:d1:64:f5:f6:14:a7:63:
                    44:56:08:61:47:20:34:33:c7:c0:71:92:1e:a1:61:
                    13:85:aa:5c:23:b3:74:bd:9f:07:e5:4f:10:0b:53:
                    ad:50:44:ed:f1:60:32:a6:44:3d:9e:4f:64:46:28:
                    2d:e9:ef:fe:c1:df:59:3f:39:60:81:9c:c2:e0:d6:
                    1c:fd:a3:05:da:b4:6a:8e:a1:dd:1d:65:f9:6a:6d:
                    2c:84:d4:32:87:ba:1d:ea:cc:2f:ca:a8:20:e5:b0:
                    ea:85:b4:cf:66:15:77:a3:9f:61:30:6a:3c:0d:e9:
                    83
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Subject Alternative Name:
                DNS:
                IP Address:18.204.194.218, IP Address:127.0.0.1, IP Address:169.254.169.254, IP Address:5.188.210.101, IP Address:23.205.25.30, IP Address:123.125.114.144

    Signature Algorithm: SHA256-RSA
         78:fb:ca:ff:ef:1d:3b:f4:6c:f7:f4:c7:12:6c:f5:f7:d2:4c:
         95:71:b9:6c:f5:8c:42:83:35:1f:3d:c0:10:05:1f:7f:9e:80:
         53:a6:e8:42:31:e9:a9:73:d4:84:b4:ca:cd:24:ae:55:9a:31:
         28:91:9f:6f:d6:db:dc:b2:b8:2c:ea:46:2a:74:51:0e:07:63:
         d8:4e:47:17:1f:de:bd:4f:9e:34:36:5c:e3:ea:6c:ec:7b:fd:
         7d:58:9d:d3:8a:88:6f:0d:b2:36:3d:a4:04:32:9a:0f:4a:2f:
         29:f0:93:e1:4f:e1:37:f3:1d:1c:8b:5a:14:2a:ed:92:cb:3b:
         14:39:c5:6d:5c:a5:4d:ff:aa:66:31:46:9f:ac:57:10:7f:ef:
         14:b5:9d:d1:7b:3b:c4:8f:4a:06:15:b1:52:59:8b:78:49:3f:
         9b:31:46:cd:63:21:03:4c:32:58:06:28:f6:7e:26:54:6c:1e:
         fb:5b:64:78:cc:99:1e:e6:95:78:14:f7:64:b5:da:1d:32:ec:
         ea:3c:49:4e:7e:a2:ca:15:96:e1:69:f8:18:8c:09:72:d0:78:
         c6:9e:4e:04:8e:96:01:88:d2:24:df:c3:8f:7d:c4:ec:43:01:
         e9:db:bc:d2:44:53:ee:e9:4a:e0:24:85:cb:82:d8:3c:8a:d4:
         4b:dd:e9:1a
]
Do you want to continue connecting (yes/no)? yes
FATA[0012] Bad response statusCode [401]. Status [401 Unauthorized]. Body: [message=clusterID does not match] from [https://18.204.194.218/v3]

```

With `good token` == N/A as scope, the message will be

```
rancher login https://18.204.194.218/v3 --token token-k6c5s:g5sm********************************************stjv
The authenticity of server 'https://18.204.194.218' can't be established.
Cert chain is : [Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 7227871200284629574 (0x644e8e8fcf3dda46)
    Signature Algorithm: SHA256-RSA

.... DELETED    

Do you want to continue connecting (yes/no)? yes
INFO[0005] Saving config to /Users/miro/.rancher/cli2.json


```

## Using Rancher CLI

After login I do not need to use kubeconfig for kubectl:

```
rancher kubectl get pods --all-namespaces
NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE
cattle-system   cattle-cluster-agent-5c98cb979f-bbhxf     1/1     Running     0          5d23h
cattle-system   cattle-node-agent-dwnxk                   1/1     Running     0          5d23h
cattle-system   kube-api-auth-d4zgq                       1/1     Running     0          5d23h
ingress-nginx   default-http-backend-67cf578fc4-grmsw     1/1     Running     0          5d23h
ingress-nginx   nginx-ingress-controller-mpnmb            1/1     Running     0          5d23h
kube-system     canal-jw85q                               2/2     Running     0          5d23h
kube-system     coredns-5c59fd465f-47q5z                  1/1     Running     0          5d23h
kube-system     coredns-autoscaler-d765c8497-sm5xf        1/1     Running     0          5d23h
kube-system     metrics-server-64f6dffb84-bp864           1/1     Running     0          5d23h
kube-system     rke-coredns-addon-deploy-job-95qnk        0/1     Completed   0          5d23h
kube-system     rke-ingress-controller-deploy-job-brv7w   0/1     Completed   0          5d23h
kube-system     rke-metrics-addon-deploy-job-tvt89        0/1     Completed   0          5d23h
kube-system     rke-network-plugin-deploy-job-7rqcr       0/1     Completed   0          5d23h
```