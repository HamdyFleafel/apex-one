# APEXONE Database Build System

## Overview

The `database/build` directory contains the database build orchestration scripts for the **APEXONE Enterprise Platform**.

These scripts are responsible for coordinating database installation, cleanup, rebuilding, health checks, and verification in a controlled and repeatable manner.

The build layer is designed to keep database deployment operations:

* Ordered by dependency
* Repeatable
* Easy to audit
* Safe to execute through SQL*Plus
* Separated from individual module implementation scripts
* Consistent with the APEXONE enterprise tablespace strategy

---

## Directory

```text
database/
└── build/
    ├── build_all.sql
    ├── build_database.sql
    ├── build_framework.sql
    ├── build_modules.sql
    ├── build_seed.sql
    ├── build_verification.sql
    ├── build_healthcheck.sql
    ├── clean_all.sql
    ├── clean_database.sql
    └── rebuild_database.sql
```

> The exact files present in the directory should always be verified against the repository before executing an orchestration script.

---

# Build Architecture

The build system separates the database lifecycle into logical stages.

```text
                    APEXONE DATABASE BUILD
                             │
                             ▼
                    ┌─────────────────┐
                    │  BUILD_ALL.SQL  │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
       ┌────────────┐ ┌────────────┐ ┌──────────────┐
       │ Framework  │ │   Modules  │ │     Seed     │
       │   Build    │ │   Build    │ │    Build     │
       └─────┬──────┘ └─────┬──────┘ └──────┬───────┘
             │              │               │
             └──────────────┼───────────────┘
                            ▼
                   ┌──────────────────┐
                   │   Verification   │
                   └────────┬─────────┘
                            ▼
                   ┌──────────────────┐
                   │   Health Check   │
                   └──────────────────┘
```

The orchestration layer should not contain the implementation details of individual database objects. Those remain under their respective framework and module directories.

---

# Build Order

The complete database build follows dependency order.

The current master build sequence is:

```text
1. Framework
2. Core
3. Identity
4. Security
5. Verification
6. Health Check
```

The dependency relationship is intentional.

```text
Framework
   │
   ▼
Core
   │
   ▼
Identity
   │
   ▼
Security
   │
   ▼
Verification
   │
   ▼
Health Check
```

This prevents dependent objects from being created before their required parent objects exist.

---

# Main Build Scripts

## build_all.sql

`build_all.sql` is the master database orchestration script.

Its purpose is to execute the complete APEXONE database build in the required dependency order.

The script is intended to be the primary entry point for a full database installation/build.

Typical execution:

```sql
@build/build_all.sql
```

The script uses SQL*Plus error handling so that database errors are not silently ignored.

Example:

```sql
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
```

The successful completion message indicates that the orchestration script reached its final stage.

---

# build_database.sql

`build_database.sql` is responsible for the database-level foundation required by the APEXONE platform.

This layer should contain infrastructure required before higher-level modules are installed.

Typical responsibilities include:

* Database schema preparation
* Enterprise tablespace preparation
* Required database-level objects
* Database initialization prerequisites

The exact operations must match the implementation contained in the corresponding deployment/build scripts.

---

# build_framework.sql

`build_framework.sql` handles installation of the APEXONE database framework.

The framework represents the foundational database layer on which the application modules depend.

Typical framework responsibilities include:

* Common database infrastructure
* Shared packages
* Error handling infrastructure
* Framework-level objects
* Common utilities

The framework must be installed before dependent modules.

---

# build_modules.sql

`build_modules.sql` coordinates installation of the application database modules.

The project currently contains modules such as:

```text
audit
configuration
core
identity
notification
security
workflow
```

Each module maintains its own database objects under its module directory.

A module may contain:

```text
tables/
constraints/
indexes/
sequences/
packages/
install/
```

The build layer should invoke the module installation scripts rather than duplicating module implementation logic.

---

# build_seed.sql

`build_seed.sql` handles initial reference and application seed data.

Seed data should be inserted only after the required database structures and dependencies have been created.

Examples already present in the project include security and identity seed areas.

Conceptually:

```text
Tables
  │
  ▼
Constraints
  │
  ▼
Packages / Supporting Objects
  │
  ▼
Seed Data
```

Seed execution should therefore occur after the corresponding module structures are available.

---

# build_verification.sql

`build_verification.sql` executes the database verification layer after installation.

The project contains verification scripts for areas including:

```text
identity
security
RBAC integrity
```

Verification should confirm that the installation completed structurally and logically.

Typical verification areas include:

* Required tables exist
* Required constraints exist
* Required indexes exist
* Required packages are available
* Security objects are valid
* RBAC relationships are valid
* Installation dependencies are satisfied

A successful build should not be considered fully verified merely because SQL*Plus reached the end of the installation scripts.

---

# build_healthcheck.sql

`build_healthcheck.sql` is intended for post-build health validation.

The health-check layer should be used after the main build and verification stages.

It should focus on the operational state of the database rather than recreating objects.

Recommended areas for a health check include:

```text
Schema status
Object validity
Tablespace availability
Required tables
Required indexes
Constraint status
Package validity
Security objects
```

The health check should produce clear success/failure output.

---

# Cleanup Scripts

## clean_all.sql

`clean_all.sql` is the master cleanup orchestration script.

It should coordinate removal of APEXONE database objects in reverse dependency order.

The conceptual order is:

```text
Verification / Runtime Objects
             │
             ▼
          Modules
             │
             ▼
          Core
             │
             ▼
        Framework
```

Cleanup must be performed carefully because it is destructive.

A cleanup script should always use explicit object names or controlled module uninstall scripts rather than broad destructive commands.

---

# clean_database.sql

`clean_database.sql` handles cleanup of database-level objects created by the APEXONE database layer.

This script should be executed only when a database reset is intentionally required.

Before execution, verify:

* Correct database
* Correct PDB
* Correct schema
* Correct environment
* Required backups
* No active deployment depending on the objects

---

# rebuild_database.sql

`rebuild_database.sql` provides a controlled rebuild workflow.

Conceptually:

```text
CLEAN
  │
  ▼
BUILD
  │
  ▼
SEED
  │
  ▼
VERIFY
  │
  ▼
HEALTH CHECK
```

A rebuild is useful when the database needs to be reconstructed from the repository state.

It should not be confused with a normal incremental deployment.

---

# Tablespaces

APEXONE follows an enterprise tablespace separation strategy.

The database objects observed during verification use:

```text
APEXONE_DATA
APEXONE_INDEX
```

The intended separation is:

| Object Type         | Tablespace      |
| ------------------- | --------------- |
| Normal application tables | `APEXONE_DATA` |
| Normal application indexes | `APEXONE_INDEX` |
| Audit tables | `APEXONE_AUDIT` |
| Audit indexes | `APEXONE_AUDIT` |

For example, the current `APP_FILE_METADATA` table is stored in:

```text
APEXONE_DATA
```

while its indexes are stored in:

```text
APEXONE_INDEX
```

This includes:

```text
APP_FILE_METADATA_PK
APP_FILE_METADATA_PATH_UK
APP_FILE_METADATA_CREATED_IDX
APP_FILE_METADATA_STATUS_IDX
```

---

# Constraint Index Placement

Primary-key and unique constraints that create or use indexes should explicitly place those indexes in the enterprise index tablespace.

The standard pattern is:

```sql
ALTER TABLE APP_EXAMPLE
ADD CONSTRAINT APP_EXAMPLE_PK
PRIMARY KEY (ID)
USING INDEX TABLESPACE APEXONE_INDEX;
```

For a unique constraint:

```sql
ALTER TABLE APP_EXAMPLE
ADD CONSTRAINT APP_EXAMPLE_UK
UNIQUE (CODE)
USING INDEX TABLESPACE APEXONE_INDEX;
```

This prevents Oracle from placing constraint-generated indexes in an unintended default tablespace.

---

# External File Storage

Large application files are not intended to be stored directly inside the database as large binary payloads.

The database stores metadata describing externally stored files.

The current metadata table is:

```text
APP_FILE_METADATA
```

It is located in:

```text
APEXONE_DATA
```

The table contains metadata including:

```text
FILE_ID
FILE_NAME
RELATIVE_PATH
FILE_EXTENSION
MIME_TYPE
FILE_SIZE_BYTES
CHECKSUM_SHA256
FILE_STATUS
CREATED_AT
PROCESSED_AT
ERROR_MESSAGE
```

The important design principle is:

```text
Large File
   │
   ├── Physical file → External file storage
   │
   └── Metadata      → APP_FILE_METADATA
```

This allows the database to manage file identity, location, status, checksum, processing state, and error information without unnecessarily storing large file contents inside database tables.

---

# APP_FILE_METADATA

The current metadata table uses:

```text
FILE_ID
```

as its identity column.

The primary key is:

```text
APP_FILE_METADATA_PK
```

The file location is protected by:

```text
APP_FILE_METADATA_PATH_UK
```

using:

```text
RELATIVE_PATH
FILE_NAME
```

The table also contains validation constraints for:

```text
FILE_STATUS
FILE_SIZE_BYTES
CHECKSUM_SHA256
```

The supported file status values are:

```text
RECEIVED
PROCESSING
PROCESSED
FAILED
ARCHIVED
```

---

# APP_FILE_METADATA Indexes

The current indexes are:

```text
APP_FILE_METADATA_PK
APP_FILE_METADATA_PATH_UK
APP_FILE_METADATA_CREATED_IDX
APP_FILE_METADATA_STATUS_IDX
```

All are expected to reside in:

```text
APEXONE_INDEX
```

This maintains the separation between table storage and index storage.

---

# SQL*Plus Execution

The build scripts are SQL*Plus-oriented scripts.

Before execution, connect to the intended PDB and schema.

Example:

```text
sqlplus APEXONE/<password>@//127.0.0.1:1521/FREEPDB1
```

Then execute the required orchestration script.

Example:

```sql
@database/build/build_all.sql
```

If already inside the `database` directory:

```sql
@build/build_all.sql
```

Always verify the current working directory before using relative paths.

---

# Relative Path Rules

The build scripts use relative SQL*Plus paths.

Therefore, execution location matters.

For example, a script containing:

```sql
@framework/install/install_framework.sql
```

expects the current SQL*Plus path to correspond to the `database` directory.

From:

```text
<APEXONE_REPO>\database
```

the following is valid:

```sql
@build/build_all.sql
```

From the repository root, the corresponding path is:

```sql
@database/build/build_all.sql
```

Do not prepend `database\` when the current directory is already:

```text
<APEXONE_REPO>\database
```

---

# PowerShell File Validation

Before running a build, validate that the required build files exist.

From the repository root:

```powershell
Get-ChildItem database\build -File |
    Select-Object Name, Length, FullName
```

To inspect the complete build directory recursively:

```powershell
Get-ChildItem database\build -Recurse -File |
    Select-Object FullName, Length
```

To verify that a specific file exists:

```powershell
Test-Path database\build\build_all.sql
```

Expected result:

```text
True
```

---

# Pre-Build Validation

The project contains:

```text
scripts\check_build_files.ps1
```

This script is used to verify that required database build files are present before starting the database build.

Run it from the repository root:

```powershell
.\scripts\check_build_files.ps1
```

A successful validation should end with a message equivalent to:

```text
ALL FILES PRESENT. You can safely run the build.
```

The pre-build check should be performed before executing a full database build.

---

# Recommended Deployment Workflow

The recommended operational sequence is:

```text
1. Verify repository status
2. Verify build files
3. Connect to the correct Oracle PDB
4. Verify schema
5. Execute build
6. Execute verification
7. Execute health check
8. Validate tablespaces
9. Validate indexes
10. Validate constraints
11. Review SQL*Plus output
```

Example PowerShell preparation:

```powershell
cd <APEXONE_REPO>

git status --short

.\scripts\check_build_files.ps1
```

Then connect to Oracle:

```text
sqlplus APEXONE/<password>@//127.0.0.1:1521/FREEPDB1
```

Then:

```sql
@database/build/build_all.sql
```

---

# Post-Build Validation

After the build, verify important objects.

For tables:

```sql
SELECT TABLE_NAME,
       TABLESPACE_NAME
FROM USER_TABLES
ORDER BY TABLE_NAME;
```

For indexes:

```sql
SELECT INDEX_NAME,
       TABLE_NAME,
       STATUS,
       TABLESPACE_NAME
FROM USER_INDEXES
ORDER BY TABLE_NAME, INDEX_NAME;
```

For constraints:

```sql
SELECT TABLE_NAME,
       CONSTRAINT_NAME,
       CONSTRAINT_TYPE,
       STATUS
FROM USER_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_NAME;
```

For invalid objects:

```sql
SELECT OBJECT_NAME,
       OBJECT_TYPE,
       STATUS
FROM USER_OBJECTS
WHERE STATUS <> 'VALID'
ORDER BY OBJECT_TYPE, OBJECT_NAME;
```

---

# Security Verification

Security-related database objects should be verified after installation.

The project contains a security verification layer.

The verification should confirm that security tables, constraints, indexes, and related packages are correctly installed and valid.

A successful verification should produce an explicit success message rather than relying only on the absence of SQL errors.

---

# Error Handling

The master build scripts should use SQL*Plus error handling such as:

```sql
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
```

This is important because a deployment script should not report successful completion after an earlier SQL error.

If an error occurs:

1. Stop the build.
2. Read the first Oracle error.
3. Identify the failing script.
4. Correct the underlying issue.
5. Clean/rebuild if required.
6. Re-run verification.

Do not ignore Oracle errors and continue manually without understanding their cause.

---

# Git and Build Changes

Database build scripts are part of the source-controlled deployment system.

Before committing changes:

```powershell
git status --short
```

Review changes:

```powershell
git diff -- database/build/
```

Then stage the intended files:

```powershell
git add database/build/
```

Review staged changes:

```powershell
git diff --cached -- database/build/
```

Commit only after confirming that the changes are intentional.

---

# Operational Safety

The following commands may be destructive:

```text
clean_all.sql
clean_database.sql
rebuild_database.sql
```

Never execute cleanup or rebuild scripts against a production database without explicit authorization and appropriate backup/recovery procedures.

Always confirm:

```text
Database
PDB
Schema
Environment
Backup status
```

before destructive operations.

---

# Troubleshooting

## ORA-00942

Example:

```text
ORA-00942: table or view does not exist
```

Verify:

* Current schema
* Required privileges
* Correct PDB
* Whether the object belongs to `APEXONE`
* Whether `USER_*` views should be used instead of `DBA_*` views

For example:

```sql
SELECT TABLE_NAME,
       TABLESPACE_NAME
FROM USER_TABLES;
```

is appropriate when connected directly as the application schema.

---

## SP2-0734

Example:

```text
SP2-0734: unknown command beginning "PRIMARY KEY..."
```

This usually means a fragment of SQL was entered into SQL*Plus without its complete `ALTER TABLE ... ADD CONSTRAINT ...` statement.

Do not execute fragments such as:

```sql
PRIMARY KEY (...)
```

or:

```sql
+USING INDEX TABLESPACE APEXONE_INDEX
```

by themselves.

They must be part of the complete SQL statement.

---

## File Not Found

If PowerShell reports:

```text
Cannot find path ...
```

first verify the actual repository path.

Use:

```powershell
Get-ChildItem database\build -Recurse -File |
    Select-Object FullName
```

Then use the exact path returned by PowerShell.

Do not assume that a filename is located in a nested `build\build` directory.

---

# Design Principles

The APEXONE build system follows these principles:

### 1. Dependency First

Objects are installed in dependency order.

### 2. Separation of Concerns

Build orchestration is separate from module implementation.

### 3. Explicit Storage

Tables and indexes use explicit enterprise tablespaces.

### 4. Verification

Installation is followed by structural and logical verification.

### 5. Repeatability

A clean build should be reproducible from repository-controlled scripts.

### 6. Controlled Destruction

Cleanup and rebuild operations are explicit and isolated.

### 7. External Large-File Storage

Large files are represented by metadata in the database while the physical file can remain outside the database.

### 8. Source-Controlled Deployment

Database changes are maintained as version-controlled SQL scripts.

---

# Quick Reference

## Full Build

From repository root:

```sql
@database/build/build_all.sql
```

## Build from database directory

```sql
@build/build_all.sql
```

## File Check

```powershell
.\scripts\check_build_files.ps1
```

## Review Build Changes

```powershell
git diff -- database/build/
```

## Check Repository

```powershell
git status --short
```

## Check Tablespaces

```sql
SELECT TABLE_NAME,
       TABLESPACE_NAME
FROM USER_TABLES
ORDER BY TABLE_NAME;
```

## Check Indexes

```sql
SELECT INDEX_NAME,
       TABLE_NAME,
       STATUS,
       TABLESPACE_NAME
FROM USER_INDEXES
ORDER BY TABLE_NAME, INDEX_NAME;
```

## Check Constraints

```sql
SELECT TABLE_NAME,
       CONSTRAINT_NAME,
       CONSTRAINT_TYPE,
       STATUS
FROM USER_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_NAME;
```

## Check Invalid Objects

```sql
SELECT OBJECT_NAME,
       OBJECT_TYPE,
       STATUS
FROM USER_OBJECTS
WHERE STATUS <> 'VALID'
ORDER BY OBJECT_TYPE, OBJECT_NAME;
```

---

# Status

```text
Project   : APEXONE Enterprise Platform
Component : Database Build System
Directory : database/build
Purpose   : Database build orchestration
Database  : Oracle
Schema    : APEXONE
```

This README documents the purpose, organization, execution model, validation procedures, tablespace strategy, external file metadata architecture, and operational safety requirements of the APEXONE database build layer.
