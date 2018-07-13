# awsecr

Container helps managing images from AWS ECR without having to manually login with AWS CLI.

When defining a workflow for you team, it is very common to push images to repository
(public or private) after everything is alright and, then pull in server to start a
service to provide applications in productions.

There are good solutions for docker-login for private repositories.
This images provides a way to fluid log-in into AWS ECR repository to pull and push images.

# Usage

With this container you do some good fastly:

* pull images from AWS ECR;
* push images to AWS ECR;
* list all tagged images hosted AWS ECR (tagged only) - _I do not care about UNTAGGED images_;
* get the last image (most recent according to SEMVER algorithm) hosted in AWS ECR;  

Check it out!

**IMPORTANT:** you must provide a volume: `-v /var/run/docker.sock:/var/run/docker.sock`

## Dependencies

**awscli**

Obviously to login to AWS ECR.

**Amazon ECR Credential Helper**

See at: https://github.com/awslabs/amazon-ecr-credential-helper

Helper for docker-login automatically.

**docker-py**

Library to access docker environment system.

**Jinja2**

Configure templates to setup automation inside container.

# Envirnoment Variables

**AWS_KEY** AWS access key ID
**AWS_SECRET** AWS access secret
**AWS_ACCOUNT_ID** your account key, you can see it in ECR. <account-key>.dkr.ecr.<region>.amazonaws.com
**AWS_REGION** AWS region (Default: us-east-1)
**AWS_FORMAT** AWS Cli output format (Default: json)

## Publishing an image

```bash
$ docker exec -ti awsecr push mynamespace/myimage:1.0.0  
```

## Pulling an image

```bash
$ docker exec -ti awsecr pull mynamespace/myimage:1.0.0  
```

## Listing available images already published

```bash
$ docker exec -ti awsecr list-images mynamespace
```

## Last published tag

If you tags as provided using [semver](https://semver.org/), this commands
provides the higher version as tag.

```bash
$ docker exec -ti awsecr last-image mynamespace
```
