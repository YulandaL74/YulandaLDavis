# Compliance Report Automation (PowerShell)

## Overview
This script demonstrates how PowerShell can be used to automate compliance reporting.  
It collects recent **Application** and **System** event logs from Windows and saves them into a timestamped text file.  
The goal is to show how automation reduces manual work, improves accuracy, and supports risk management.

## Why It Matters
- **Compliance:** Organizations often need regular system reports for audits and risk mitigation.  
- **Efficiency:** Automating log collection saves time compared to manual export.  
- **Communication:** By documenting each step clearly, technical processes become easier for non-technical professionals to understand.

## How It Works
1. **Create Output Folder** – Ensures reports are stored in a dedicated directory.  
2. **Generate Timestamped File** – Each report is uniquely named for easy tracking.  
3. **Collect Logs** – Pulls the latest 50 entries from Application and System event logs.  
4. **Export to File** – Saves logs into a text file with clear section headers.  
5. **Confirm Completion** – Outputs the location of the generated report.

## Example Use Case
- A compliance officer needs daily system logs for audit purposes.  
- Instead of manually exporting logs, they run this script.  
- The script generates a report automatically, ensuring consistency and reliability.

## Teaching Demo
This script is ideal for training sessions because it:
- Shows how **automation supports compliance**.  
- Breaks down technical steps into **clear, communicable actions**.  
- Bridges the gap between **IT workflows** and **business communication**.

---

✨ This project highlights the intersection of **technology and executive communication** — demonstrating not only how to automate tasks, but also how to explain them in a way that empowers professionals.





# User Management Automation (PowerShell)

## Overview
This script demonstrates how PowerShell can be used to automate basic user management tasks.  
It provides examples such as adding new users, disabling accounts, and resetting passwords.  
The goal is to show how automation supports IT teams, HR processes, and compliance requirements.

## Why It Matters
- **Compliance:** Ensures user accounts are managed consistently and securely.  
- **Efficiency:** Reduces manual effort in onboarding, offboarding, or account maintenance.  
- **Risk Mitigation:** Helps prevent unauthorized access by automating account updates.  
- **Communication:** Clear documentation makes technical processes accessible to non-technical professionals.  

## How It Works
1. **Define User Actions** – Choose whether to add, disable, or reset accounts.  
2. **Run PowerShell Commands** – Executes the appropriate automation for each action.  
3. **Log Results** – Outputs confirmation messages for transparency and auditing.  

## Example Use Case
- An HR team needs to onboard a new employee.  
- Instead of manually creating accounts, they run this script.  
- The script adds the user, sets a temporary password, and logs the action for compliance.  

## Teaching Demo
This script is ideal for training sessions because it:  
- Shows how **automation supports HR and IT workflows**.  
- Breaks down technical steps into **clear, communicable actions**.  
- Bridges the gap between **system administration** and **business communication**.
  
