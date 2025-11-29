package main

import (
	"context"
	"fmt"
	"os/exec"
	"strings"

	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/planmodifier"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/stringplanmodifier"
	"github.com/hashicorp/terraform-plugin-framework/types"
)

var _ resource.Resource = &LinuxVMResource{}

func NewLinuxVMResource() resource.Resource {
	return &LinuxVMResource{}
}

type LinuxVMResource struct{}

type LinuxVMResourceModel struct {
	Name   types.String `tfsdk:"name"`
	Distro types.String `tfsdk:"distro"`
	Arch   types.String `tfsdk:"arch"`
}

func (r *LinuxVMResource) Metadata(ctx context.Context, req resource.MetadataRequest, resp *resource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_linux_vm"
}

func (r *LinuxVMResource) Schema(ctx context.Context, req resource.SchemaRequest, resp *resource.SchemaResponse) {
	resp.Schema = schema.Schema{
		Description: "Manages an OrbStack Linux Virtual Machine.",
		Attributes: map[string]schema.Attribute{
			"name": schema.StringAttribute{
				Description: "The name of the Linux machine.",
				Required:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"distro": schema.StringAttribute{
				Description: "The Linux distribution to use (e.g., ubuntu, debian, fedora).",
				Optional:    true,
				Computed:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"arch": schema.StringAttribute{
				Description: "The architecture (e.g., amd64, arm64). Defaults to native.",
				Optional:    true,
				Computed:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
		},
	}
}

func (r *LinuxVMResource) Create(ctx context.Context, req resource.CreateRequest, resp *resource.CreateResponse) {
	var plan LinuxVMResourceModel
	resp.Diagnostics.Append(req.Plan.Get(ctx, &plan)...)
	if resp.Diagnostics.HasError() {
		return
	}

	name := plan.Name.ValueString()
	distro := "ubuntu" // Default if not specified in logic, though plan usually handles defaults if set in schema.
	if !plan.Distro.IsNull() {
		distro = plan.Distro.ValueString()
	}

	args := []string{"create", distro, name}

	// CRITICAL FIX: Handle 'Arch' being Computed but Optional.
	// If the user didn't specify arch, it comes in as Null.
	// We must set a concrete value (e.g., "native") in the plan so Terraform knows what happened.
	arch := "native"
	if !plan.Arch.IsNull() {
		arch = plan.Arch.ValueString()
		args = append([]string{"create", "--arch", arch, distro, name})
	} else {
		// Set the default "native" into the plan object so it gets saved to state
		plan.Arch = types.StringValue(arch)
	}

	// Execute: orb create <distro> <name>
	cmd := exec.Command("orb", args...)
	if output, err := cmd.CombinedOutput(); err != nil {
		resp.Diagnostics.AddError(
			"Error creating OrbStack VM",
			fmt.Sprintf("Could not create machine %s: %s\nOutput: %s", name, err, string(output)),
		)
		return
	}

	// Save state (ensure Distro is also set if it was optional/computed)
	plan.Distro = types.StringValue(distro)

	// Write the updated plan (with our defaulted Arch) back to state
	resp.Diagnostics.Append(resp.State.Set(ctx, plan)...)
}

func (r *LinuxVMResource) Read(ctx context.Context, req resource.ReadRequest, resp *resource.ReadResponse) {
	var state LinuxVMResourceModel
	resp.Diagnostics.Append(req.State.Get(ctx, &state)...)
	if resp.Diagnostics.HasError() {
		return
	}

	name := state.Name.ValueString()

	// Check if machine exists using 'orb list'
	cmd := exec.Command("orb", "list")
	output, err := cmd.Output()
	if err != nil {
		resp.Diagnostics.AddError("Error listing OrbStack VMs", err.Error())
		return
	}

	exists := false
	lines := strings.Split(string(output), "\n")
	for _, line := range lines {
		// Output format is usually: NAME STATE ...
		fields := strings.Fields(line)
		if len(fields) > 0 && fields[0] == name {
			exists = true
			break
		}
	}

	if !exists {
		resp.State.RemoveResource(ctx)
		return
	}

	// In a real provider, we would read back the actual distro/arch here.
	// For this simple example, we assume the state is correct if the VM exists.
	resp.Diagnostics.Append(resp.State.Set(ctx, &state)...)
}

func (r *LinuxVMResource) Update(ctx context.Context, req resource.UpdateRequest, resp *resource.UpdateResponse) {
	// OrbStack VMs are generally immutable in terms of distro/arch
	// (handled by RequiresReplace), so no update logic needed here.
}

func (r *LinuxVMResource) Delete(ctx context.Context, req resource.DeleteRequest, resp *resource.DeleteResponse) {
	var state LinuxVMResourceModel
	resp.Diagnostics.Append(req.State.Get(ctx, &state)...)
	if resp.Diagnostics.HasError() {
		return
	}

	name := state.Name.ValueString()

	// Execute: orb delete <name>
	cmd := exec.Command("orb", "delete", name)
	if output, err := cmd.CombinedOutput(); err != nil {
		resp.Diagnostics.AddError(
			"Error deleting OrbStack VM",
			fmt.Sprintf("Could not delete machine %s: %s\nOutput: %s", name, err, string(output)),
		)
		return
	}
}
