# APEXONE Enterprise Platform

## SQL & PL/SQL Development Standard

### Version 1.0.0

### Status: Approved Development Standard

---

# 1. Purpose

This document defines the official development standards for all SQL and PL/SQL files inside the APEXONE Enterprise Platform.

Every SQL object inside the project **must** follow these standards.

---

# 2. Standard File Header

Every SQL/PLSQL file must begin with the following header.

```sql
-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Installation
-- Object Name    : INSTALL_IDENTITY
-- Object Type    : SCRIPT
-- File           : install_identity.sql
-- Path           : <APEXONE_REPO>\database\modules\identity\install_identity.sql
-- Schema         : APEXONE
-- Version        : 1.3.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- Title          : Enterprise Database Architect
-- Email          : hamdy.fleafel@belcofarms.com
-- WhatsApp       : 0020 1010506080
-- -----------------------------------------------------------------------------
-- Description    : Brief description of the object.
-- -----------------------------------------------------------------------------
-- Created On     : YYYY-MM-DD
-- Last Modified  : YYYY-MM-DD
-- -----------------------------------------------------------------------------
-- Change Log     :
--   YYYY-MM-DD  HF  Initial creation.
-- -----------------------------------------------------------------------------
-- Copyright (c) 2026 Hamdy Fleafel. All rights reserved.
-- =============================================================================
```

---

# 3. File Structure

Every SQL file follows the same order.

```text
Header

SET DEFINE OFF;

PROMPT ...

SQL Statements

SHOW ERRORS

PROMPT Completed.
```

---

# 4. Standard Installation Script Order

Each install script must execute objects in the following order.

```text
1. Sequences

2. Tables

3. Indexes

4. Primary Keys

5. Unique Constraints

6. Check Constraints

7. Foreign Keys

8. Views

9. Packages

10. Triggers

11. Documentation

12. Seed Data (if applicable)

13. Verification
```

---

# 5. Standard Folder Layout

Every module should follow the same structure.

```text
Module
│
├── install_<module>.sql
├── constraints
├── docs
├── indexes
├── packages
│   ├── spec
│   └── body
├── seed
├── sequences
├── tables
├── tests
├── triggers
├── views
└── verify
```

---

# 6. SQL File Naming Convention

## Sequences

```
SEQ_APP_USERS.sql
SEQ_APP_ROLES.sql
SEQ_APP_PERMISSIONS.sql
SEQ_APP_USER_ROLES.sql
SEQ_APP_ROLE_PERMISSIONS.sql
```

---

## Indexes

```
IDX_APP_USERS_USERNAME.sql

IDX_APP_USERS_EMAIL.sql

IDX_APP_USERS_STATUS.sql

IDX_APP_ROLE_PERMISSIONS_ROLE.sql

IDX_APP_ROLE_PERMISSIONS_PERMISSION.sql
```

---

## Constraints

```
APP_USERS_PK.sql

APP_USERS_USERNAME_UK.sql

APP_USERS_EMAIL_UK.sql

APP_USERS_STATUS_CK.sql

APP_USERS_ROLE_FK.sql
```

---

## Packages

```
PKG_IDENTITY.pks

PKG_IDENTITY.pkb
```

---

## Install Script

```
install_identity.sql
```

---

## Verify Script

```
verify_identity.sql
```

---

## Seed Script

```
seed_identity.sql
```

---

# 7. PROMPT Standard

Every installation script should display clear progress messages.

Example:

```sql
PROMPT ======================================================
PROMPT Installing Identity Module
PROMPT ======================================================

PROMPT Creating Sequences...

PROMPT Creating Tables...

PROMPT Creating Indexes...

PROMPT Creating Constraints...

PROMPT Creating Packages...

PROMPT Creating Documentation...

PROMPT Identity Module Installed Successfully.
```

---

# 8. SQL Comments Standard

Never write random comments.

Use section separators.

```sql
------------------------------------------------------------------------------
-- Validate Input
------------------------------------------------------------------------------
```

```sql
------------------------------------------------------------------------------
-- Create Record
------------------------------------------------------------------------------
```

```sql
------------------------------------------------------------------------------
-- Update Record
------------------------------------------------------------------------------
```

```sql
------------------------------------------------------------------------------
-- Delete Record
------------------------------------------------------------------------------
```

```sql
------------------------------------------------------------------------------
-- Business Rules
------------------------------------------------------------------------------
```

```sql
------------------------------------------------------------------------------
-- Exception Handling
------------------------------------------------------------------------------
```

---

# 9. Sequence Standard

Every sequence must follow this format.

```sql
CREATE SEQUENCE SEQ_APP_USERS
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NOCACHE
    NOCYCLE
    NOORDER;
```

This standard applies to every sequence in the project.

---

# 10. Index Standard

Each index must be created in its own SQL file.

Example:

```
IDX_APP_USERS_USERNAME.sql

IDX_APP_USERS_EMAIL.sql

IDX_APP_USERS_STATUS.sql
```

Install script executes them individually.

---

# 11. Constraint Standard

Each constraint must exist in a separate SQL file.

Examples:

```
APP_USERS_PK.sql

APP_USERS_USERNAME_UK.sql

APP_USERS_EMAIL_UK.sql

APP_USERS_STATUS_CK.sql

APP_USERS_ROLE_FK.sql
```

---

# 12. Versioning Standard

Use Semantic Versioning.

Examples

Major Feature

```
2.0.0
```

Minor Feature

```
1.4.0-alpha.1
```

Bug Fix

```
1.3.1-alpha.1
```

Documentation Update

```
1.3.0-alpha.2
```

---

# 13. Change Log Standard

Keep the last important changes only.

Example

```
Change Log
-----------
2026-08-05 HF Initial creation.

2026-08-06 HF Added indexes.

2026-08-07 HF Added documentation.
```

---

# 14. Coding Standard

* SQL keywords in UPPERCASE.
* Object names in UPPERCASE.
* Four-space indentation.
* One object per file.
* One responsibility per script.
* No hardcoded IDs unless seed data requires them.
* Use descriptive variable names.
* Keep package sections separated with comment blocks.

---

# 15. Installation Script Rules

Always use single @ references.

Example

```sql
@modules/identity/sequences/install_sequences.sql

@modules/identity/tables/app_users.sql

@modules/identity/indexes/install_indexes.sql

@modules/identity/constraints/install_constraints.sql

@modules/identity/packages/spec/PKG_IDENTITY.pks

@modules/identity/packages/body/PKG_IDENTITY.pkb
```

Do not use @@ references.

---

# 16. Enterprise Principles

Every database object must satisfy the following principles.

* Single Responsibility
* Modular Design
* Independent Deployment
* Reusable Components
* Consistent Naming
* Version Controlled
* Fully Documented
* Fully Testable
* Enterprise Ready

---

# 17. Project Official Standard

This document is considered the official SQL and PL/SQL development standard for the APEXONE Enterprise Platform.

All future modules including:

* Core
* Identity
* Security
* Configuration
* Notification
* Workflow
* Audit

must follow these standards without exception.

---

**Document Name**

```
SQL_FILE_STANDARD.md
```

**Recommended Location**

```
<APEXONE_REPO>\database\governance\standards\SQL_FILE_STANDARD.md
```
