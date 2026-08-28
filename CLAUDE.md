# CLAUDE.md — Next.js 15 + SQLite SaaS

## Stack and versions

- Next.js 15 App Router; TypeScript in strict mode.
- React Server Components by default. Add `"use client"` only where browser state, effects, or event handlers require it.
- SQLite through `better-sqlite3` for a single-node deployment, or Turso/libSQL when the application needs remote/edge-accessible SQLite. Keep the repository interface identical so the driver can change without leaking into UI code.
- SQL is the source of truth for persistence. Do not hide schema changes inside application startup.
- Validate untrusted input at the server boundary with Zod before it reaches domain or database code.

## Commands

Use the package manager already selected by the lockfile. Typical commands:

```bash
npm run dev
npm run lint
npm run typecheck
npm test
npm run build
```

Before declaring work complete, run lint, typecheck, tests, and a production build. A dev server rendering successfully is not sufficient validation.

## Project structure

```text
app/
  (public)/              # public routes/layouts
  (app)/                 # authenticated product routes
  api/                   # route handlers only when an HTTP boundary is required
components/
  ui/                     # reusable presentational primitives
  features/               # feature-specific composed UI
lib/
  auth/                   # authentication/session boundary
  db/
    client.ts             # database connection/driver
    migrations/           # ordered immutable SQL migrations
    repositories/         # persistence queries grouped by aggregate
  validation/             # shared boundary schemas
  server/                 # server-only orchestration/domain services
tests/
```

Keep route files thin: parse input, authorize, call a server/domain function, and map its result to a response. Business rules do not belong in page components or route handlers.

## Naming conventions

- React components and exported types: `PascalCase`.
- Functions, variables, route helpers: `camelCase`.
- Database tables/columns: `snake_case`.
- Boolean columns start with `is_`, `has_`, or `can_` where practical.
- Repository methods describe intent (`findUserByEmail`, `markInvoicePaid`) rather than SQL mechanics (`selectUser`).
- Prefer domain names over generic `data`, `item`, `thing`, `helper`, or `utils`.

Reason: names should expose the business invariant being changed so reviews can catch incorrect behavior without reverse-engineering implementation details.

## Server/client boundaries

1. Fetch data in Server Components or server-only modules when possible. This avoids shipping database-facing orchestration to the browser.
2. Never import the SQLite client, secrets, or repository modules into a Client Component.
3. Use Server Actions for mutations originating from first-party UI when they make the flow simpler. Use Route Handlers for external/webhook/API boundaries.
4. Every mutation must authenticate and authorize on the server. Hiding a button is not authorization.
5. Parse all external values before use. TypeScript types do not validate runtime input.

## Database rules

### Connection

Create exactly one database adapter module (`lib/db/client.ts`). Application modules depend on repositories, not on a driver imported ad hoc. For `better-sqlite3`, enable foreign keys and use WAL where appropriate for the deployment model.

### Queries

- Always bind parameters. Never interpolate user-controlled values into SQL strings.
- Select explicit columns instead of `SELECT *`; schema additions must not silently change application payloads.
- Put multi-step writes that must succeed together inside one transaction.
- Add indexes for actual lookup/ordering paths, not speculatively.
- Treat `UNIQUE`, `NOT NULL`, foreign keys, and `CHECK` constraints as a second enforcement layer for invariants that the database can express.

### Migration conventions

Migration filenames are monotonically ordered and descriptive, for example:

```text
0001_create_users.sql
0002_create_organizations.sql
0003_add_users_organization_id.sql
```

Rules:

1. Once a migration can have run outside a developer's machine, never edit or reorder it. Add a new migration. This keeps every environment on the same reproducible history.
2. Migrations contain schema/data transition logic only; they do not depend on application runtime code that may later change.
3. Make migrations safe for existing rows. For a new required column, introduce/backfill it before enforcing `NOT NULL` when necessary.
4. Destructive changes require an explicit data-preservation or rollback plan in the PR.
5. Test migrations against a copy/fixture representing the previous schema, not only a fresh empty database.
6. Never run migrations implicitly on ordinary request handling or module import. Deployment/startup migration is a deliberate operation.

## Repository pattern

SQL lives in `lib/db/repositories` (or the chosen query layer), not scattered through components/actions. A repository returns domain-shaped records and owns persistence-specific details.

```ts
// lib/db/repositories/users.ts
export function findUserByEmail(email: string) {
  return db
    .prepare(`select id, email, display_name from users where email = ?`)
    .get(email);
}
```

A service composes repositories and enforces workflow rules. This makes database behavior independently testable and prevents UI refactors from changing persistence semantics.

## Component patterns

- Prefer Server Components for pages, layouts, read-heavy feature shells, and data loading.
- Keep Client Components small and push them down the tree. Pass serializable values rather than whole server objects.
- `components/ui` primitives are domain-agnostic. A generic `Button` belongs there; `CancelSubscriptionButton` belongs with its feature.
- Forms have one authoritative server mutation path. Client validation may improve UX, but the same constraints must be enforced server-side.
- Represent expected domain failures as typed/structured results; reserve thrown exceptions for unexpected failures.
- Do not duplicate derived state in React state. Derive it during render unless there is a genuine independent lifecycle.

## Authentication and authorization

- Authentication answers who the caller is; authorization separately answers whether that caller may perform this operation.
- Perform tenant/organization scoping in every repository query involving tenant-owned data. Do not fetch globally and filter afterward.
- Never accept ownership fields such as `userId`, `organizationId`, role, or billing state from the browser when they can be derived from the authenticated session/server record.
- Return minimal records to the client; server-only columns stay server-only.

## Error handling and observability

- Do not expose SQL errors, stack traces, secrets, or internal identifiers to public clients.
- Log unexpected server failures with enough context to trace the operation, but never log passwords, session tokens, API keys, or full sensitive payloads.
- Expected validation/conflict/not-found outcomes should have stable application-level error codes/messages.

## Tests

For each behavioral change, test the smallest stable boundary that proves it:

- repository tests for SQL, constraints, transactions, and tenant scoping;
- service tests for business rules;
- route/action tests for validation, authentication, authorization, and response mapping;
- component tests only for meaningful interactive behavior.

Bug fixes require a regression test that fails before the fix when practical. Database tests use isolated temporary databases and apply the real migrations.

## Patterns to follow

- **Thin route, explicit service, focused repository** — keeps HTTP/UI concerns separate from business and persistence rules.
- **Server-first rendering** — minimizes client JavaScript and prevents accidental exposure of server dependencies.
- **Runtime validation at boundaries** — static types disappear at runtime.
- **Constraints plus application checks** — concurrency can invalidate an application-only check between read and write.
- **Small transactional units** — preserve invariants without holding SQLite write locks longer than necessary.

## What we do not do (and why)

- **No `any` to silence TypeScript.** It removes the exact contract checking strict TypeScript is intended to provide.
- **No raw SQL in React components or route files.** It couples presentation/transport code to persistence and makes authorization/scoping inconsistent.
- **No client-side-only authorization.** Browser code is controlled by the caller.
- **No string-built SQL containing input.** Parameter binding prevents injection and quoting bugs.
- **No `SELECT *`.** Explicit result shapes survive schema evolution predictably.
- **No editing applied migrations.** Existing databases cannot replay rewritten history safely.
- **No schema mutation on request/import.** Concurrent requests and partial startup failures make implicit migration unsafe.
- **No global singleton mutable business state.** Deployment processes/instances do not share memory reliably.
- **No premature Client Components.** `"use client"` expands the browser bundle and server/client boundary.
- **No catch-and-ignore.** Swallowed failures create false success and corrupt workflows.
- **No generic abstraction until repetition is real.** SaaS rules diverge quickly; premature abstractions hide important differences.

## Definition of done

A change is done only when:

1. the requested behavior and edge cases are implemented;
2. authorization and tenant isolation are preserved;
3. schema changes have a forward migration and safe existing-data path;
4. relevant regression/unit/integration tests exist and pass;
5. lint and strict typecheck pass;
6. `next build` succeeds;
7. no secret/server-only dependency crosses into the client bundle;
8. documentation is updated when the project contract or operator workflow changed.

When requirements are ambiguous, inspect existing code, tests, migrations, and conventions first. Prefer the smallest change consistent with these rules rather than inventing a new architecture.