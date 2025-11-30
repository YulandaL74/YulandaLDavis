# Compliance Report Automation (PowerShell)

Add PowerShell automation example to existing project

- Uploaded PNG screenshot demonstrating PowerShell script execution
- Showcased automation workflow as part of project documentation
- Updated project to include visual example of GitHub + PowerShell integration

- Add PowerShell automation PNG example to project

## Overview
This repo contains two example PowerShell automation scripts:
- scripts/collect-eventlogs.ps1 — collects Application and System event log entries and saves a timestamped report.
- scripts/user-management.ps1 — demonstrates basic user management (Add / Disable / ResetPassword) for AD or local accounts.

The README documents usage, prerequisites, and security considerations.

## Quick start (recommended)
1. Clone the repo.
2. Open PowerShell as Administrator.
3. Run the event collection example:
   - Example: .\scripts\collect-eventlogs.ps1 -OutputDir C:\Reports -MaxEvents 100 -Compress
4. Run a user-management example (AD):
   - Example: .\scripts\user-management.ps1 -Action Add -UserName jdoe -GivenName John -Surname Doe -UseAD

## Prerequisites
- Windows with PowerShell 5.1+ or PowerShell 7.
- Administrative privileges for most operations (especially reading certain logs or managing accounts).
- For Active Directory operations, the ActiveDirectory PowerShell module (RSAT) must be installed.
- Do not run these scripts in production without testing in a non-production environment.

## Why It Matters
- Compliance: Organizations often need regular system reports for audits and risk mitigation.
- Efficiency: Automating log collection and account management saves time compared to manual processes.
- Communication: Clear documentation makes technical processes accessible to non-technical stakeholders.

## Security & operational notes
- Never store plain-text credentials in source control.
- Prefer secrets stores (Azure Key Vault, HashiCorp Vault) or use secure prompts (Read-Host -AsSecureString) when obtaining credentials.
- Generated temporary passwords are printed in these examples for demonstration; replace with secure delivery (e.g., secure email, vault) in production.
- Test scripts on a non-production machine before deploying widely.
- Consider centralizing logs and reports (SIEM, file share with restricted access).

## Improvements you may want
- Add stronger auditing (send events to a central log or SIEM).
- Add unit/integration tests (e.g., Pester for PowerShell).
- Add scheduling instructions (Task Scheduler, Windows Scheduled Task or Azure Automation).
- Add encryption/compression and retention policy for generated reports.
- Add more robust filtering (by event levels, specific event IDs, date ranges).

## Teaching demo
These scripts are ideal for training because they:
- Show how automation supports compliance and IT workflows.
- Break down technical steps into clear, communicable actions.
- Bridge the gap between system administration and business communication.

## Assets
- Include the referenced PNG screenshot in a folder, e.g., docs/screenshots/powershell-run.png
- If you mention the screenshot in the README, ensure the file exists and the path is correct.

## License & Contributing
- Add a LICENSE and CONTRIBUTING.md if you plan to share this repo publicly or accept contributions.
