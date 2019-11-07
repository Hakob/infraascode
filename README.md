# Infrastructure Cookbook

This code for infrastructure (formerly `IaC`) will let you up and run your infra which will consist of 6 `AWS` VM's, 3 Front and 3 Backend servers, and configure a `Log Collecting` system based on `Elasticsearch` and `Kibana` 

## Getting Started

These instructions will get you a copy of the project up and running on your AWS for testing and staging purposes.

```bash
$ git clone https://github.com/Hakob/infraascode.git
$ cd infraascode/terraform
$ terraform init
$ cd .. && chmod o+x startup.sh
$ ./startup.sh [plan|apply|destroy]
```

#### With this steps will create passphraseless SSH key for further connections to instances.

### Prerequisites

Before make things done you need to install the following software on your host machine from where you will run this code

#### Tools

* [ssh-keygen (required)](http://manpages.ubuntu.com/manpages/bionic/man1/ssh-keygen.1.html) - This SSH client tool required for generating key-pairs for connecting to remote machines
* [Terraform (required)](https://www.terraform.io/downloads.html) - Infrastructure building tool
* [Ansible (required)](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) - Used to generate RSS Feeds
* [AWS CLI (required)](https://www.terraform.io/downloads.html) - IT automation tool
* [jq (optional)](https://www.terraform.io/downloads.html) - JSON query is for parsing tf's output as needed

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/Hakob/infraascode/tags). 

## Authors

* **Hakob Arakelyan** - *Infra as Code* - [Hakob](https://github.com/Hakob)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
