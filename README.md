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

- **Schema Inspection** – Export complete database schemas (tables, indexes, constraints, views, functions, partitions) to local files for source control tracking
- **Intelligent Diffing** – Instantly compare live databases, SQL files, directories, or remote URLs with a full column lifecycle diff engine
- **Risk Classification** – Every migration plan is labeled Safe, Warning, or Destructive so you can assess impact at a glance
- **Impact Analysis** – See all downstream components (views, functions, etc.) that depend on modified entities before applying
- **Schema Overview** – Side-by-side comparison of source vs target schemas with entity counts and change highlighting
- **Safe Execution** – Preview all changes before applying with interactive approval. Auto-approve with `--approve` for CI/CD
- **Safe Cast Migrations** – Multi-step column type changes with temporary columns, data conversion, and automatic reapplication of constraints and indexes
- **Interactive Prompt Handling** – Safely remove enum values with guided prompts for valid replacements, applied transactionally
- **Advisory Locks** – Concurrent migration protection via PostgreSQL advisory locks, enabled by default
- **Dev-Database Validation** – Test migrations against an ephemeral Docker container with `--dev-image` to catch runtime errors early
- **Table Partition Support** – Detect and compare partition tables; basic create, drop, and rename automated
- **Fully Local** – Data and schemas never leave your machine; all operations happen within the CLI
- **Plain SQL** – No lock-in. Work with standard SQL DDL files your team already understands

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

The CLI is free to use. PostgreSQL is supported today, with more dialects on the way.

## What's Next?

- **CI/CD Integration** – GitHub Actions for automated migrations and PR previews
- **Expanded Dialects** – MySQL, MS SQL Server, Oracle, and SQLite support

---

For detailed documentation, visit [docs.migrata.io](https://docs.migrata.io)
