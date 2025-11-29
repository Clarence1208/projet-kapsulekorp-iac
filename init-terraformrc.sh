#!/bin/bash

# Fail on error
set -e

# Absolute path to project root (directory containing the script)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Relative provider folder inside your project
PROVIDER_DIR="orbstack-teraform-integration"

# Full absolute path to the provider
PROVIDER_PATH="$PROJECT_ROOT/$PROVIDER_DIR"

# Output file path
TERRAFORM_RC="$PROJECT_ROOT/terraform.rc"

echo "Generating $TERRAFORM_RC..."
echo

cat > "$TERRAFORM_RC" <<EOF
provider_installation {
  dev_overrides {
    "local/orbstack" = "$PROVIDER_PATH"
  }
  direct {}
}
EOF

echo "Done!"
echo "Created terraform.rc with provider path:"
echo "  $PROVIDER_PATH"
echo
echo "Terraform will now automatically use this config when run in this project."
