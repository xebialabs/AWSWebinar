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

3. Python 3.6 or up and yaml module installed (e.g. `pip3 install pyyaml`)

# Get the workshop

1) Download and extract the workshop zip into directory of your choice.

*Linux*
```
 curl -LO https://github.com/xebialabs/AWSWebinar/archive/master.zip
 unzip master.zip
 cd AWSWebinar-master/modules/xebialabs/devops-as-code
```

*Windows*
```
curl -LO https://github.com/xebialabs/AWSWebinar/archive/master.zip
```
- Unzip archive using GUI tool
- Switch your working directory
```
cd master\AWSWebinar-master\modules\xebialabs\devops-as-code
```

# Start up the XL DevOps Platform

1) If you are already running XL Deploy or XL Release on your local machine, please stop them.

2) Start up the XL DevOps Platform:
```
 docker-compose up --build
```

3) Wait for XL Deploy and XL Release to have started up.

1) Open the XL Deploy GUI at http://localhost:4516/ and login with the username `admin` and password `admin`. Verify that the about box reports the version to be **8.5.0-alpha.13**.

2) Open the XL Release GUI at http://localhost:5516/ and login with the username `admin` and password `admin`. Verify that the about box reports the version to be **8.5.0-alpha.9**.

# Install the XL CLI

Please note that XL CLI is in alpha stage and will be released at the end of 2018

1) Open a new terminal window and install the XL command line client:

*Mac*
```
 curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/darwin-amd64/xl
 chmod +x xl
 sudo mv xl /usr/local/bin
```

*Linux*
```
 curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/linux-amd64/xl
 chmod +x xl
 sudo mv xl /usr/local/bin
```

*Windows*

Switch your working directory to unpacked repo and download binary
```
 cd master\AWSWebinar-master\modules\xebialabs\devops-as-code
 curl -LO https://s3.amazonaws.com/xl-cli/bin/8.5.0-alpha.2/windows-amd64/xl.exe
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

3) (optionally) Configure XL cli for Windows

If your Docker installation for Windows uses non-localhost interface to expose ports from docker containers (i.e. you installed Docker with Docker Toolbox), you need:
- obtain IP address of Docker Machine
- create custom configuration for XL cli to reach XL Deploy & XL Release at Docker Machine's IP

You can do it using following:

```
mkdir %UserProfile%\.xebialabs
for /f %i in ('docker-machine ip') do set IP=%i
(
echo xl-deploy:
echo   password: admin
echo   url: http://%IP%:4516
echo   username: admin
echo xl-release:
echo   password: admin
echo   url: http://%IP%:5516
echo   username: admin
)>"%UserProfile%\.xebialabs\config.yaml"
```
# Deploying applications on AWS EC2 Container Service (ECS) with Fargate

This demos show you how to deploy to ECS with XL Deploy.


## Step 1 - Configure AWS in XL Deploy

Make sure you have setup the AWS command line interface installed and configured correctly as per [these instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).


This demo will not use the AWS command line interface itself, but will use the [credentials and configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html) files:

*Linux, macOS, or Unix*

`~/.aws/credentials`

`~/.aws/config`

*Windows*

`%UserProfile%\.aws\credentials`

`%UserProfile%\.aws\config`


### Generate XL YAML files
Once you've configured the AWS command line interface, use the `awsconfig2xld.py` script in the `config` directory to create XL YAML files that will create the AWS environment in XL Deploy.

*Linux and macOS*
```
 config/awsconfig2xld.py > AWSConfig.yaml
```
*Windows*
```
 config\awsconfig2xld.py > AWSConfig.yaml
```

Now send this file to XL Deploy using:
```
 xl apply -f AWSConfig.yaml
```

## Step 2 - Import the REST-o-rant YAML definition:

We will be deploying the docker images of `rest-o-rant-web` and `rest-o-rant-api` applications from the repositories below. The application docker images are already available in docker hub.

[https://github.com/xebialabs/rest-o-rant-web](https://github.com/xebialabs/rest-o-rant-web)

[https://github.com/xebialabs/rest-o-rant-api](https://github.com/xebialabs/rest-o-rant-api)


1) Import the REST-o-rant ECS/Fargate cluster definition for AWS into XL Deploy:

*Linux and macOS*
```
 xl apply -f ecs/rest-o-rant-ecs-fargate-cluster.yaml
```

*Windows*
```
 xl apply -f ecs\rest-o-rant-ecs-fargate-cluster.yaml
```

2) Import the REST-o-rant application definition into XL Deploy:

*Linux and macOS*
```
 xl apply -f ecs/rest-o-rant-ecs-service.yaml
```
*Windows*
```
 xl apply -f ecs\rest-o-rant-ecs-service.yaml
```

3) Import the release pipeline into XL Release:

*Linux and macOS*
```
 xl apply -f ecs/rest-o-rant-ecs-pipeline.yaml
```
*Windows*
```
 xl apply -f ecs\rest-o-rant-ecs-pipeline.yaml
```
## Step 3 - Start the release pipeline

1. Go to the XL Release UI running on http://localhost:5516.

2. Go to the "Templates" page under the "Design" tab.

3. Start a "New release" from the "REST-o-rant on ECS" template.

4. Provide a "Release name" and "Create" the release.

5. Click on "Start release" on the release page.

6. Start the release by completing the first manual step titled "Ready to go?"

7. Once the applications are deployed, complete the "Test REST-o-rant" step from the "Test" phase to do automatic cleanup.
