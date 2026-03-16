# Workflow Builder — Prompt Tips

## When User Asks for Workflow Design

1. Understand the business process and goals
2. Run: `bash scripts/workflow.sh <command> [process] [complexity]`
3. Present the workflow design with visual diagrams
4. Suggest automation opportunities and tool integrations

## Design Principles

- **Start with the goal** — what outcome does this workflow produce?
- **Identify actors** — who/what participates at each step?
- **Map happy path first** — then add error handling and edge cases
- **Minimize handoffs** — each handoff is a potential failure point
- **Build in visibility** — status tracking and notifications

## Automation Maturity Levels

1. **Manual** — documented but human-executed
2. **Semi-auto** — notifications + templates + checklists
3. **Auto with approval** — automated with human checkpoints
4. **Fully automated** — end-to-end with exception handling

## Integration Patterns

- **Event-driven** — webhooks trigger downstream actions
- **Scheduled** — cron/batch processing at intervals
- **Request-response** — synchronous API calls
- **Queue-based** — async processing with retry logic
