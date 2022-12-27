# AWS Terraform deployment

Terraform script handle the creation of a basic AWS superstructure, including VPC, Internet Gateway, NAT, subnets, key-pair definitions, VPN config, VPN endpoint file creation, security groups, EC2 instances, EKS, ECR, S3 bucket, billing monitors, and enabling flow-logs.

## Setup

- To generate self-signed keys, use `https://github.com/OpenVPN/easy-rsa.git`
- Place VPN chain certificate in `/certs/ca.crt`
- Place VPN server key in `/certs/private/server.key`
- Place VPN issued certificate in `/certs/issued/server.crt`
- Copy `vars.tf.sample` to `vars.tf` and fill out variables.

## Terraform

1. Install Terraform by following directions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Initialise Terraform and download packages with `terraform init`
3. Preview the planned changes with `terraform plan`
4. Apply the changes with `terraform apply`. Confirm by typing yes

## VPN connection

1. After Terraform is done, log into the AWS management console
2. In the Client VPN section, download the VPN client configuration file.
3. Open the downloaded configuration file and add the contents of the client certificate between <cert></cert> tags and the contents of the private key between <key></key> tags to the configuration file.
4. In addition, add four random letters before .cvpn on the first remote line, e.g. `remote adks.cvpn-end...`

### Example VPN config file

```
client
dev tun
proto udp
remote asdf.cvpn-endpoint-0011abcabcabcabc1.prod.clientvpn.eu-west-2.amazonaws.com 443
remote-random-hostname
resolv-retry infinite
nobind
remote-cert-tls server
cipher AES-256-GCM
verb 3

<ca>
Contents of CA
</ca>

<cert>
Contents of client certificate (.crt) file
</cert>

<key>
Contents of private key (.key) file
</key>

reneg-sec 0
```

## Destroying Terraform deployment

Before running a `terraform destroy` command, remove any additional layers added onto the AWS superstructure.

- Ensure the current nemspace is correct by entering `kubectl config get-contexts`. Check for the namespace with the \*
- Check deployments with `kubectl get deployments`
- Remove pods with `kubectl delete deployment <deploymentname>`
- Remove persistent containers: `kubectl get pvc` and `kubectl delete pvc <pvname>`
- Remove persistent volumes: `kubectl get pv` and `kubectl delete pv <pvname>`
- Remove any services. Check services running with `kubectl get services` (apart from the kubernetes service itself)
- Remove any pods. Check pods with `kubectl get pods`
- Empty all ECR containers.
- Delete the contents of all S3 buckets.

```

```
