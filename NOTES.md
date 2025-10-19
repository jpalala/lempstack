✅ Notes

AzureYaml Section	Meanings

- infra.provider: terraform	Tells azd to run Terraform for infra
- path: infra	Points to your main.tf etc.
- services.web	Declares a single service named web
- language: docker	Means "I’m shipping a dockerized app"
- host: vm	Means "this won’t go to Azure Container Apps / App Service — it stays on the VM"
- docker.path	Used by azd exec, since terraform this is mostly just metadata

# Installing docker-compose:

## Docker Compose Plugin Installation for Ubuntu 24.04 (Noble Numbat)

The error "Unable to locate package docker-compose-plugin" is fixed by properly adding the Docker repository, as the package is not in the default Ubuntu sources.

## Step 1: Update and Install Prerequisites

First, ensure your package list is up-to-date and install the necessary tools to manage external repositories:

```
sudo apt update
sudo apt install ca-certificates curl gnupg
```


## Step 2: Add Docker's GPG Key and Repository
This step uses the codename (noble) to correctly point your package manager to the right Docker repository.

Add Docker's official GPG key:

```
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Add the Docker repository to your APT sources: (This line will now correctly use your codename, noble, since the internal command . /etc/os-release && echo "$VERSION_CODENAME" would resolve to it.)

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  noble stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## Step 3: Install the Plugin

Update your package index (this loads the new Docker repository):

```bash
sudo apt update
```

Install the Docker Compose plugin:

```
sudo apt install docker-compose-plugin
```

## Step 4: Verify Installation

The Docker Compose plugin is now installed as part of the main Docker CLI (Command-Line Interface). It is invoked using the docker compose command (without a hyphen).

If you run `docker compose version`, you should see output confirming the version,for example: Docker Compose version v2.x.x.

