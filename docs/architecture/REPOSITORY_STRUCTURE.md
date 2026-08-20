# Canonical Repository Structure

This is the single canonical repository layout for APEXONE.

```text
apex-one/
├── application/              # APEX / ORDS / REST / static application layer
│   ├── apex/
│   ├── export/
│   ├── ords/
│   ├── rest/
│   └── static/
│
├── database/                 # Oracle Database implementation and lifecycle
│   ├── platform/             # shared technical database capabilities
│   ├── modules/              # owned functional capabilities
│   ├── migrations/           # schema evolution
│   ├── seed/                 # initial/reference data
│   ├── deployment/           # installation, upgrade, rollback orchestration
│   ├── verification/         # database verification
│   ├── build/                # build orchestration
│   ├── ci/                   # database CI validation
│   ├── config/               # database configuration scripts
│   ├── operations/           # runtime operations and maintenance
│   ├── dictionary/           # database catalog/reference
│   ├── governance/           # database-specific governance
│   ├── templates/            # database source templates
│   ├── samples/              # database examples
│   ├── tools/                # database developer tools
│   └── utilities/            # general database utilities
│
├── automation/               # repository-level automation and artifacts
├── config/                   # local/development repository configuration
├── deployment/               # environment-level deployment targets
├── environment/              # shared environment definitions
├── infrastructure/           # Docker/Kubernetes/Terraform
├── docs/                     # authoritative durable project knowledge
├── scripts/                  # repository-level scripts
├── tests/                    # repository-level tests
├── tools/                    # developer tooling
└── project-status/           # current project state only
```

## Non-duplication rules

- Architecture documentation exists only in `docs/architecture/`.
- Project governance documents have one canonical location under `docs/`.
- Repository-level tests exist only in `tests/`.
- Module tests may live inside their owning module.
- Database implementation is never duplicated into documentation or deployment folders.
- Deployment orchestrates implementation; it does not copy implementation.
- Historical backups are artifacts, not source.
- Empty catch-all directories are not created.
