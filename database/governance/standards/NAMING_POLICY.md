<!--====================================================================
APEXONE Enterprise Platform
Document Name : NAMING_POLICY
Document Type : Engineering Standard
Module        : Database Standards
Version       : 1.0.0-alpha.1
Status        : Approved
Database      : Oracle AI Database 26ai
Schema        : APEXONE

Purpose
Defines naming conventions for all database objects.

Change History
-----------------------------------------------------------------------
Version          Date         Description
-----------------------------------------------------------------------
1.0.0-alpha.1    2026-08-04   Initial Version
=====================================================================-->

# Naming Policy

## General Rules

- Uppercase object names.
- English only.
- Singular object names where appropriate.
- No abbreviations unless approved.
- No Oracle reserved words.

## Tables

APP_USERS

APP_ROLES

APP_PERMISSIONS

APP_CONFIG

APP_AUDIT_LOG

## Primary Keys

PK_APP_USERS

PK_APP_ROLES

## Foreign Keys

APP_CONFIG_GROUP_FK

APP_ROLE_PERMISSIONS_ROLE_FK

## Unique Constraints

UK_APP_USERS_EMAIL

UK_APP_USERS_USERNAME

## Check Constraints

CK_APP_USERS_STATUS

CK_APP_ROLES_ACTIVE

## Indexes

IDX_APP_USERS_EMAIL

IDX_APP_USERS_USERNAME

## Packages

PKG_SECURITY

PKG_NOTIFICATION

PKG_WORKFLOW

PKG_AUDIT

## Triggers

TRG_APP_USERS_BI

TRG_APP_USERS_AUDIT

## Views

VW_ACTIVE_USERS

VW_AUDIT_HISTORY