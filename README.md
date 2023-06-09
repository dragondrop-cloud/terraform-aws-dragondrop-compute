# terraform-aws-dragondrop-compute
Terraform module for deploying the compute services needed to run dragondrop.cloud within your AWS cloud environment.

Available for consumption via HashiCorp's Public Module Registry: https://registry.terraform.io/modules/dragondrop-cloud/dragondrop-compute/aws/latest

# dragondrop Self-Hosting Compute
Terraform code for deploying the compute resources needed to run dragondrop.cloud within your AWS environment.

![AWS infrastructure diagram](./images/2023-03-05%20AWS%20Infrastructure%20Module.png)
Cloud architecture diagram of the infrastructure created by this module.

## Variables

| Name                            | Type        | Purpose                                                                                                                                           |
|---------------------------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| _**https_trigger_lambda_name**_ | string      | Name of the lambda function created by the Module which services as an HTTPS endpoint.                                                            |
| **_region_**                    | string      | AWS region into which resources should be deployed.                                                                                               |
| **_service_account_name_**      | string      | Name of the service account with exclusively ECS Task invocation privileges that serves as the service account for compute created by the module. |
| **_tags_**                      | map(string) | An optional mapping of tags to add to resources created by the module.                                                                            |


## How to Use this Module
This module defines the compute resources needed to run dragondrop within your own cloud environment.

It defines a [Lambda Function](https://github.com/dragondrop-cloud/ecs-fargate-http-trigger) that can
evoke the longer running dragondrop engine living in a provisioned ECS Fargate Task.

The url for this lambda function is output and should be passed to a dragondrop [Job](https://docs.dragondrop.cloud/product-docs/getting-started/creating-a-job)
definition as that Job's "HTTPS Url".

The ECS Fargate Task hosts dragondrop's proprietary container. All environment variables that need to be configured are references
to secrets within AWS Parameter Store, and can be customized like any other secret.

### Security When Using This Module
This module creates a new IAM role, "dragondrop HTTPS Trigger Role" which has the minimum permissions needed to evoke
the created Fargate Task. This role is assigned to a new service account, and that service account is the service account
used by the Lambda function provisioned by this module.

Lastly, another service account is granted Secret Accessor privileges on only the secrets referenced by the Fargate task as
environment variables, and used by the Fargate task to run the dragondrop engine.

## What is dragondrop.cloud?
[dragondrop.cloud](https://dragondrop.cloud) is a provider of IAC automation solutions that are self-hosted
within customer's cloud environment. For more information or to schedule a demo, please visit our website.

## What's a Module?
A Module is a reusable, best-practices definition for the deployment of cloud infrastructure.
A Module is written using Terraform and includes documentation, and examples.
It is maintained both by the open source community and companies that provide commercial support.

## How can I contribute to this module?
If you notice a problem or would like some additional functionality, please open a detailed issue describing
the problem or open a pull request.

### License
Please see [LICENSE](LICENSE) for details on this module's license.

Copyright © 2023 dragondrop.cloud, Inc.
