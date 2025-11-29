package main

import (
	"context"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/provider"
	"github.com/hashicorp/terraform-plugin-framework/provider/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource"
)

// Ensure OrbStackProvider satisfies various provider interfaces.
var _ provider.Provider = &OrbStackProvider{}

type OrbStackProvider struct {
	// Version is set to the provider version on release, "dev" when the
	// provider is built and ran locally, and "test" when running acceptance
	// testing.
	Version string
}

type OrbStackProviderModel struct{}

func New() provider.Provider {
	return &OrbStackProvider{
		Version: "dev",
	}
}

func (p *OrbStackProvider) Metadata(ctx context.Context, req provider.MetadataRequest, resp *provider.MetadataResponse) {
	resp.TypeName = "orbstack"
	resp.Version = p.Version
}

func (p *OrbStackProvider) Schema(ctx context.Context, req provider.SchemaRequest, resp *provider.SchemaResponse) {
	resp.Schema = schema.Schema{
		Description: "Interact with OrbStack Linux machines.",
		Attributes:  map[string]schema.Attribute{}, // No provider-level config needed for local CLI
	}
}

func (p *OrbStackProvider) Configure(ctx context.Context, req provider.ConfigureRequest, resp *provider.ConfigureResponse) {
	// No configuration necessary as we use the local 'orb' CLI
}

func (p *OrbStackProvider) Resources(ctx context.Context) []func() resource.Resource {
	return []func() resource.Resource{
		NewLinuxVMResource,
	}
}

func (p *OrbStackProvider) DataSources(ctx context.Context) []func() datasource.DataSource {
	return []func() datasource.DataSource{}
}

