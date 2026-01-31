<h1 align="center">
  <img src="./assets/migrata-logo-cropped.svg" alt="Migrata Logo" width="35" height="35" />
  Migrata
</h1>

> **This repository hosts the public releases of the Migrata CLI**, including installation scripts and release binaries. For documentation and usage instructions, visit [https://docs.migrata.io](https://docs.migrata.io).

<div align="center">
  <strong>Database migrations made simple.</strong><br>
  Take the stress out of schema changes.<br>
  Inspect, diff, and apply changes with plain SQL, like Terraform but for your database.
</div>

## See It In Action

[migrata-demo.webm](https://github.com/user-attachments/assets/54953fe3-7c23-40ba-b3ff-7e76b76ee6d5)

*Watch as we sync a schema, rename and remove columns, change data types, and apply migrations with automatic diffing and safe execution.*

## What is the Migrata CLI?

The Migrata CLI takes the stress out of database schema changes. It's a fully local tool that helps you version-control your database schema, preview changes before applying them, and execute migrations safely using standard SQL DDL files your team already understands.

### Key Features

- **Schema Inspection** – Export complete database schemas (tables, indexes, constraints) to local files for source control tracking
- **Intelligent Diffing** – Instantly compare live databases, SQL files, directories, or remote URLs
- **Safe Execution** – Preview all changes before applying; every migration requires explicit manual approval
- **Fully Local** – Data and schemas never leave your machine; all operations happen within the CLI
- **Plain SQL** – No lock-in. Work with standard SQL DDL files your team already understands
- **Multi-Step Migrations** – Automatically handles risky operations like temporary columns and safe data remapping

## Quick Links

- **Website**: [https://migrata.io](https://migrata.io)
- **Documentation**: [https://docs.migrata.io](https://docs.migrata.io)
- **Console**: [https://console.migrata.io](https://console.migrata.io)

## Installation

> **Note:** The installation URLs below redirect to the latest versions of the install scripts hosted in this repository on the `master` branch.

### macOS/Linux
```sh
curl -fsSL https://migrata.io/install.sh | sh
```

### Windows (PowerShell)
```powershell
irm https://migrata.io/install.ps1 | iex
```

## How It Works

1. **Sync** – Pull your live database schema into local SQL files to create a versioned snapshot
2. **Commit** – Check those schema files into Git alongside your application code
3. **Modify** – Edit DDL statements directly to add columns, change types, or adjust constraints
4. **Apply** – Run a diff to preview exactly what will change, then approve and apply the migration

## Pricing

The CLI is **free forever** for PostgreSQL. The free plan includes:
- 1 user account
- Unlimited devices
- Full CLI access
- Complete PostgreSQL support

Future paid tiers may be introduced for additional database dialect support.

## What's Next?

- **CI/CD Integration** – GitHub Actions for automated migrations and PR previews
- **Expanded Dialects** – MySQL, MS SQL Server, Oracle, and SQLite support

---

For detailed documentation, visit [docs.migrata.io](https://docs.migrata.io)
