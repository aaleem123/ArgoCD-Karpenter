# Node.js EC2 + K8s + Ansible + Terraform Project

## Overview
- Ansible playbooks for EC2 Node.js app deployment
- Ansible playbooks for Kubernetes (EKS) Node.js deployment
- Terraform files for AWS EKS cluster setup
- Dockerfile for containerizing Node.js app
- Clean repo structure with .gitignore in place

## Folders
- `app/` — Node.js application source code
- `ansible/ec2-deploy/` — Ansible for EC2 deployment
- `ansible/K8s-deploy/` — Ansible for Kubernetes deployment
- `terraform/` — Terraform for EKS cluster
- `manifests/` — Kubernetes manifests

## Notes
Ensure AWS credentials and kubeconfig are properly configured before running Ansible or Terraform commands.

