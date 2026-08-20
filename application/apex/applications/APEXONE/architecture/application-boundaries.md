# APEXONE Application Boundaries

```text
Client
  -> APEX
      -> Application Services / REST adapters
          -> Database Module APIs
              -> Database Platform APIs
```

## APEX owns

- Presentation
- Navigation
- Page state
- User interaction
- Application-level composition
- Authorization adapters

## Database owns

- Business rules
- Identity and authentication rules
- Authorization policy
- Audit persistence
- Configuration persistence
- Workflow state
- Notification state

## ORDS/REST owns

- HTTP transport
- REST resource exposure
- External integration boundary

## Prohibited

- APEX-owned duplicate tables for database modules
- Duplicate role/permission stores
- Business logic copied from PL/SQL packages into page processes
- A second APEX application export location
- Environment-specific application source
