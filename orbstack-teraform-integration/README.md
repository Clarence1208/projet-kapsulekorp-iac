Terraform OrbStack ProviderA simple Terraform provider to manage OrbStack Linux machines.1. Build the
ProviderPrerequisites: Go 1.21+ installed.# Initialize dependencies
go mod tidy

# Build the binary

```bash
  go build -o terraform-provider-orbstack
```

2. Configure Terraform to use Local ProviderSince this is not on the official registry, you need to tell Terraform where
   to find it.Create a file named ~/.terraformrc (MacOS/Linux) or %APPDATA%\terraform.rc (Windows) with the following
   content. Replace /PATH/TO/YOUR/FOLDER with the actual path where you built the binary.provider_installation {
   dev_overrides {
   "local/orbstack" = "/PATH/TO/YOUR/FOLDER"
   }

# For all other providers, install normally from registry

direct {}
}

3. Usage Example (main.tf)Create a main.tf in your project folder:terraform {
   required_providers {
   orbstack = {
   source = "local/orbstack"
   version = "1.0.0"
   }
   }
   }

resource "orbstack_linux_vm" "web_server" {
name = "web-server-01"
distro = "ubuntu"

# Optional: arch = "amd64"

}

resource "orbstack_linux_vm" "db_server" {
name = "db-server-01"
distro = "debian"
}

4. Run it# Note: 'terraform init' is skipped for dev_overrides usually,

# but if you have other providers run:

terraform init

terraform plan
terraform apply

