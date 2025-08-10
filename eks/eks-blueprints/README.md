# EKS Blueprints

[**EKS Blueprints for Terraform**](https://aws-ia.github.io/terraform-aws-eks-blueprints/) is an open-source project by AWS that provides reusable, opinionated Terraform modules and reference architectures for provisioning Amazon EKS (Elastic Kubernetes Service) clusters and the associated AWS infrastructure in a **secure**, **scalable**, and **production-ready** manner.

### **Purpose**

* To simplify and standardize the deployment of EKS clusters using Terraform.
* To enable organizations to bootstrap EKS clusters **with best practices, security, add-ons, and integrations** (like monitoring, logging, networking, and GitOps) out of the box.

### **How It Works**

* Provides **modular, composable Terraform modules and patterns** that you can mix and match based on your requirements.
* You can quickly provision EKS clusters along with:

  * VPC and networking
  * Node groups (managed and self-managed)
  * Add-ons (AWS Load Balancer Controller, CoreDNS, Karpenter, Prometheus, etc.)
  * Security controls (IAM, RBAC)
  * GitOps (ArgoCD, Flux)
  * Observability (CloudWatch, Grafana, Loki, etc.)

### **Benefits**

* **Accelerates EKS adoption:** Removes a lot of undifferentiated heavy lifting.
* **Best Practices:** Encapsulates AWS and industry best practices.
* **Extensible:** You can customize blueprints for your organization's needs.
* **Composability:** Supports adding or removing modules/add-ons easily.

### **Use Cases**

* Rapid bootstrapping of new EKS environments (dev, staging, prod).
* Standardizing EKS infrastructure across multiple teams or accounts.
* Building a secure, multi-tenant EKS foundation.


### References

* [EKS Blueprints for Terraform - GitHub Repo](https://github.com/aws-ia/terraform-aws-eks-blueprints)
* [AWS Blog: Bootstrapping clusters with EKS Blueprints](https://aws.amazon.com/blogs/containers/bootstrapping-clusters-with-eks-blueprints/)
* [Official Documentation](https://aws-ia.github.io/terraform-aws-eks-blueprints/getting-started/)
* [YouTube: EKS Blueprints for Terraform Explained](https://www.youtube.com/watch?v=DhoZMbqwwsw)

EKS Blueprints for Terraform is your “starter kit” for building production-grade EKS clusters on AWS using Terraform, with built-in best practices and extensibility.
