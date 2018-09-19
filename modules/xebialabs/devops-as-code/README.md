# Provisisoning and deploying to AWS Fargate clusters using XL Platform

This workshop will teach you:

* How to start up the XL DevOps Platform with docker.
* How to install the XL CLI(alpha).
* How to provision AWS EC2 Container Service (ECS) with Fargate using XL Platform
* How to deploy an application on AWS EC2 Container Service (ECS) with Fargate using XL Platform

## Prerequisites

1. You'll need to have Docker installed on your machine before you begin:
    * Mac: https://docs.docker.com/docker-for-mac/
    * Windows: https://docs.docker.com/docker-for-windows/
    * Linux: Refer to the instructions for your Linux distribution on how to install Docker

2. AWS Command Line Tools

3. Python 3.6 or up

# Get the workshop

1) Download and extract the workshop zip into directory of your choice:
```
 curl -LO https://github.com/xebialabs/AWSWebinar/archive/master.zip
 unzip master.zip
 cd master/modules/xebialabs/devops-as-code
```

# Start up the XL DevOps Platform

1) If you are already running XL Deploy or XL Release on your local machine, please stop them.

2) Start up the XL DevOps Platform:
```
 docker-compose up --build
```

3) Wait for XL Deploy and XL Release to have started up. This will have occurred when the following line is shown in the logs:
```
devopsascode_xl-cli_1 exited with code 0
```

1) Open the XL Deploy GUI at http://localhost:4516/ and login with the username `admin` and password `admin`. Verify that the about box reports the version to be **8.5.0-alpha.13**.

2) Open the XL Release GUI at http://localhost:5516/ and login with the username `admin` and password `admin`. Verify that the about box reports the version to be **8.5.0-alpha.9**.

# Install the XL CLI

Please note that XL CLI is in alpha stage and will be released at the end of 2018

1) Open a new terminal window and install the XL command line client:

## Mac
```
 curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/darwin-amd64/xl
 chmod +x xl
 sudo mv xl /usr/local/bin
```

## Linux
```
 curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/linux-amd64/xl
 chmod +x xl
 sudo mv xl /usr/local/bin
```

## Windows
```
> curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/windows-amd64/xl.exe
```

2) Test the CLI by running the following the following command:
```
 xl help
```

The output should look something like this:
```
The xl command line tool provides a fast and straightforward method for provisioning
XL Release and XL Deploy with YAML files. The files can include items like
releases, pipelines, applications and target environments.

Usage:
  xl [command]

Available Commands:
  apply       Apply configuration changes
  help        Help about any command

Flags:
      --config string   config file (default: $HOME/.xebialabs/config.yaml)
  -h, --help            help for xl
  -v, --verbose         verbose output

Use "xl [command] --help" for more information about a command.
```

# Deploying applications on AWS EC2 Container Service (ECS) with Fargate

This demos show you how to deploy to ECS with XL Deploy.


## Step 1 - Configure AWS in XL Deploy

Make sure you have setup the AWS command line interface installed and configured correctly as per [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/tutorial-ec2-ubuntu.html#configure-cli).


This demo will not use the AWS command line interface itself, but will use the [credentials and configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html) in the `~/.aws/credentials` and `~/.aws/config` files:


Once you've configured the AWS command line interface, use the `awsconfig2xld.py` script in the `config` directory to create XL YAML files that will create the AWS environment in XL Deploy.

```
 cat config/awsconfig2xld.py > /tmp/AWSConfig.yaml
```

Now send this file to XL Deploy using

```
 xl apply -f /tmp/AWSConfig.yaml
```

## Step 2 - Import the REST-o-rant YAML definition:

We will be deploying the docker images of `rest-o-rant-web` and `rest-o-rant-api` applications from the repositories below. The application docker images are already available in docker hub.

[https://github.com/xebialabs/rest-o-rant-web](https://github.com/xebialabs/rest-o-rant-web)

[https://github.com/xebialabs/rest-o-rant-api](https://github.com/xebialabs/rest-o-rant-api)


Import the REST-o-rant ECS/Fargate cluster definition for AWS into XL Deploy:

```
 xl apply -f ecs/rest-o-rant-ecs-fargate-cluster.yaml
```

Import the REST-o-rant application definition into XL Deploy:

```
 xl apply -f ecs/rest-o-rant-ecs-service.yaml
```

Import the release pipeline into XL Release:

```
 xl apply -f ecs/rest-o-rant-ecs-pipeline.yaml
```

## Step 3 - Start the release pipeline

1. Go to the XL Release UI running on http://localhost:5516.

2. Go to the "Templates" page under the "Design" tab.

3. Start a "New release" from the "REST-o-rant on ECS" template.

4. Provide a "Release name" and "Create" the release.

5. Click on "Start release" on the release page.

6. Start the release by completing the first manual step titled "Ready to go?"

7. Once the applications are deployed, complete the "Test REST-o-rant" step from the "Test" phase to do automatic cleanup.
