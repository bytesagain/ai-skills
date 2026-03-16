# Macro Helper — Prompt Tips

## When User Asks for VBA/Macro Help

1. Identify the task: generate / explain / debug / template / convert / optimize
2. Run: `bash scripts/macro.sh <command> [task_description]`
3. Present well-commented VBA code
4. Include usage instructions and potential gotchas

## Code Quality Standards

- **Option Explicit** — always declare variables
- **Error handling** — On Error GoTo with proper cleanup
- **Screen updating** — Application.ScreenUpdating = False for performance
- **Comments** — explain WHY, not WHAT
- **Naming** — descriptive variable and procedure names

## Common Patterns

- Data processing: loop through rows, filter, transform
- Report generation: formatting, charts, pivot tables
- File operations: import/export CSV, PDF generation
- Email automation: Outlook integration
- User forms: input dialogs, progress bars

## Performance Tips

- Disable events and screen updating during batch operations
- Use arrays instead of cell-by-cell operations
- Avoid Select/Activate — use direct Range references
- Use With blocks for repeated object access
