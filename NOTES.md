✅ Notes
Section	Meaning
infra.provider: terraform	Tells azd to run Terraform for infra
path: infra	Points to your main.tf etc.
services.web	Declares a single service named web
language: docker	Means "I’m shipping a dockerized app"
host: vm	Means "this won’t go to Azure Container Apps / App Service — it stays on the VM"
docker.path	Used by azd exec but since you're doing docker-compose via Terraform, it's mainly metadata

