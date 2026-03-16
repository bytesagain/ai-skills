# Tips for terraform-helper

## Quick Start
- Use `resource` for individual resource configs
- Use `module` to create reusable, shareable configurations
- Use `backend` first to set up remote state before other resources

## Best Practices
- **Remote state** — Always use remote state backends (S3, GCS, Azure Blob)
- **State locking** — Enable DynamoDB/equivalent for state lock
- **Variables** — Parameterize everything, hardcode nothing
- **Modules** — Break large configs into small, focused modules
- **Naming** — Use consistent naming: `${project}-${env}-${resource}`
- **Tags** — Tag all resources for cost tracking and organization
- **Least privilege** — IAM policies should grant minimum required permissions

## Common Patterns
- `vpc --provider aws` — Start every AWS project with networking
- `compute + database + storage` — Typical 3-tier architecture
- `module --name "web-app"` — Package related resources together
- `backend --provider aws` — S3 + DynamoDB state management

## State Management
- Use separate state files per environment (dev/staging/prod)
- Use workspaces for light environment separation
- Never store state in version control
- Enable versioning on state bucket for recovery

## Security Checklist
- Encrypt state at rest and in transit
- Use IAM roles, not access keys
- Enable VPC flow logs
- Use private subnets for databases
- Enable encryption on all storage resources

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
