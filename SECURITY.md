\# APEXONE Enterprise Platform



\# Security Policy



Version: 1.0



Status: Approved



\---



\# Purpose



This document defines the official security policy for the APEXONE Enterprise Platform.



Its purpose is to ensure that all development, deployment, and maintenance activities follow secure engineering practices.



\---



\# Supported Versions



| Version | Supported |

|----------|-----------|

| 1.x | Yes |



Older versions are not supported.



\---



\# Reporting Security Vulnerabilities



Security issues must never be reported through public GitHub issues.



Instead, vulnerabilities should be reported privately to the project owner.



The report should include:



\- Description

\- Steps to reproduce

\- Expected behavior

\- Actual behavior

\- Severity

\- Suggested mitigation



\---



\# Responsible Disclosure



The project follows responsible disclosure principles.



Security researchers are requested to allow sufficient time for investigation and remediation before public disclosure.



\---



\# Authentication Policy



The following principles apply:



\- Every user must have a unique account.

\- Shared accounts are prohibited.

\- SYS account is for database administration only.

\- Application access must use the APEXONE schema.

\- Administrative actions must be audited.



\---



\# Password Policy



Passwords should:



\- Contain at least 12 characters.

\- Include uppercase letters.

\- Include lowercase letters.

\- Include numbers.

\- Include special characters.

\- Never be stored in plain text.

\- Be rotated periodically.



\---



\# Database Security



Oracle Database security requirements include:



\- Least privilege principle.

\- Dedicated application schema.

\- Role-based access control.

\- Secure password management.

\- Object ownership isolation.

\- Regular privilege reviews.



\---



\# Oracle APEX Security



The application shall follow Oracle APEX security best practices.



Including:



\- Session State Protection

\- Authorization Schemes

\- Authentication Schemes

\- Deep Link Protection

\- Cross-Site Scripting protection

\- SQL Injection prevention



\---



\# ORDS Security



ORDS configuration must:



\- Require HTTPS in production.

\- Disable unnecessary REST modules.

\- Protect configuration files.

\- Restrict administrative endpoints.



\---



\# Source Code Security



The repository must never contain:



\- Passwords

\- API Keys

\- Wallet files

\- Certificates

\- Private keys

\- Environment secrets



These items must remain outside Git.



\---



\# Dependency Management



All third-party components should be reviewed before adoption.



Only supported versions should be used.



\---



\# Logging



Security events should be logged.



Examples include:



\- Authentication failures

\- Privilege escalation

\- Account lockout

\- Configuration changes



\---



\# Backup Security



Database backups must:



\- Be encrypted when required.

\- Be stored securely.

\- Be verified periodically.

\- Never be committed into Git.



\---



\# Incident Response



In case of a security incident:



1\. Identify.

2\. Contain.

3\. Eradicate.

4\. Recover.

5\. Review.



\---



\# Compliance



The project aims to follow common enterprise security practices including:



\- Principle of Least Privilege

\- Secure by Default

\- Defense in Depth

\- Auditability



\---



\# Revision History



| Version | Date | Description |

|----------|------|-------------|

| 1.0 | 2026-08-04 | Initial security policy |

