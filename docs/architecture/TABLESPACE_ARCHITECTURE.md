<!--====================================================================
APEXONE Enterprise Platform
Document Name : TABLESPACE_ARCHITECTURE
Document Type : Architecture
Module        : Database Infrastructure
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines the enterprise tablespace architecture.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Tablespace Architecture

## Objectives

- Separate data and indexes.
- Optimize storage.
- Improve backup strategy.
- Support future scalability.

## Current Tablespaces

| Tablespace | Purpose |
|------------|----------|
| APEXONE_DATA | Application tables |
| APEXONE_INDEX | Indexes |
| APEXONE_LOB | LOB data |
| APEXONE_AUDIT | Audit data |

## Planned Tablespaces

| Tablespace | Purpose |
|------------|----------|
| APEXONE_ARCHIVE | Historical data |
| APEXONE_TEMP | Temporary processing |
| APEXONE_REPORT | Reporting objects |

## Storage Strategy

- AUTOEXTEND enabled
- Locally managed
- Permanent tablespaces
- Separate index storage
- Dedicated audit storage

## Guidelines

- Tables must reside in APEXONE_DATA.
- Indexes must reside in APEXONE_INDEX.
- LOB columns must reside in APEXONE_LOB.
- Audit tables must reside in APEXONE_AUDIT.