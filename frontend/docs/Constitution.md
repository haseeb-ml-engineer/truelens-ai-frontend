# TrueLens AI — Project Constitution

**Version:** 1.0
**Status:** Living Document — Binding for all Human and AI Contributors
**Scope:** Flutter Client · FastAPI Backend · AI Inference Layer · Infrastructure

---

## 0. Purpose of This Document

This Constitution is the **single source of truth** for how TrueLens AI is designed, built, and maintained. It exists so that every contributor — human or AI — produces work that is consistent, maintainable, and aligned with the product's long-term architecture, regardless of who wrote it or when.

This document outranks convenience, speed, and personal preference. If a request, prompt, or shortcut conflicts with this Constitution, **the Constitution wins** unless an amendment is explicitly made to this file itself.

Any AI coding agent (Claude, GPT-based agents, Copilot, etc.) operating on this codebase must read and obey **Section 19 — AI Agent Instructions** before writing a single line of code.

---

## 1. Product Overview

**TrueLens AI** is a deepfake and AI-generated media detection platform. Users upload images or videos; the system analyzes them and returns an authenticity verdict, a confidence score, and supporting evidence (e.g. heatmaps, explainability data).

### 1.1 Current Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Riverpod, GoRouter) |
| Backend | FastAPI (Python) |
| AI Inference | Python ML models (deployed separately, integrated later) |
| Database | PostgreSQL (assumed default — see §10) |
| Storage | Cloud object storage (provider-agnostic abstraction — see §6.6) |

### 1.2 Existing Frontend Surface

Splash · Onboarding · Authentication · Dashboard · Upload Flow · Processing Screen · Results Screen · Reports · History · Notifications · Profile · Settings

Mock services currently power these screens and **must be replaced behind existing repository interfaces**, never by rewriting UI code (see §4.7).

---

## 2. Core Architectural Principles

These principles apply across the entire system, frontend and backend alike.

1. **Clean Architecture, always.** Presentation → Domain → Data, with dependencies pointing inward only.
2. **Repository Pattern is mandatory** for every external data source (API, database, cache, storage, device APIs).
3. **The UI never talks to the network, disk, or database directly.** It talks to repositories through domain-layer abstractions.
4. **APIs must be replaceable.** Mock implementations and real implementations must conform to the same interface so swapping one for the other requires zero changes to calling code.
5. **One workflow, one path.** Where the product defines a single canonical flow (e.g. upload), the codebase must never offer a second, redundant way to do the same thing.
6. **Favor maintainability over speed of delivery.** A slower, correct implementation is always preferred over a fast, fragile one.
7. **No premature optimization, no premature abstraction.** Build for the MVP scope (§17) with clean seams for growth — not speculative generality.

### 2.1 Layered Architecture Diagram (Conceptual)

```
┌─────────────────────────────────────────────┐
│                 Presentation                 │  Widgets, Screens, Riverpod Providers
├─────────────────────────────────────────────┤
│                    Domain                     │  Entities, UseCases, Repository Interfaces
├─────────────────────────────────────────────┤
│                     Data                      │  Repository Impls, DTOs, API Clients, Mocks
├─────────────────────────────────────────────┤
│            Infrastructure / Platform          │  HTTP client, local storage, device APIs
└─────────────────────────────────────────────┘
```

Backend mirrors this with **Router → Service → Repository → Data Source**.

---

## 3. Folder Structure

### 3.1 Flutter (Feature-First)

```
lib/
├── core/
│   ├── config/              # env, flavors, constants
│   ├── network/              # Dio/HTTP client, interceptors
│   ├── error/                 # Failure types, exception mapping
│   ├── theme/                  # ThemeData, colors, typography
│   ├── routing/                 # GoRouter config
│   ├── utils/                    # Pure helper functions
│   └── widgets/                   # Shared, reusable, dumb widgets
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/       # remote_auth_datasource.dart, mock_auth_datasource.dart
│   │   │   ├── models/             # DTOs
│   │   │   └── repositories/        # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/         # AuthRepository (abstract)
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/             # Riverpod providers/notifiers
│   ├── onboarding/
│   ├── dashboard/
│   ├── upload/
│   ├── processing/
│   ├── results/
│   ├── reports/
│   ├── history/
│   ├── notifications/
│   ├── profile/
│   └── settings/
└── main.dart
```

**Rule:** Every feature folder follows the same `data / domain / presentation` shape. No exceptions, no "just this once" flat structures.

### 3.2 FastAPI (Layered, Domain-Oriented)

```
app/
├── api/
│   └── v1/
│       ├── routes/             # auth.py, scans.py, reports.py, users.py
│       └── dependencies.py     # shared FastAPI Depends()
├── core/
│   ├── config.py               # Settings (pydantic-settings)
│   ├── security.py             # JWT, hashing
│   ├── logging.py
│   └── exceptions.py           # Custom exception hierarchy
├── services/                   # Business logic, orchestrates repositories
├── repositories/                # DB / storage access, one per aggregate
├── models/                      # ORM models (SQLAlchemy)
├── schemas/                     # Pydantic request/response models
├── ai/
│   ├── inference_client.py      # Abstraction over model-serving layer
│   └── pipelines/                # image_pipeline.py, video_pipeline.py
├── workers/                       # Background/async job handlers
├── db/
│   ├── session.py
│   └── migrations/                # Alembic
└── main.py
```

**Rule:** Routes contain **no business logic** — they validate input, call a service, and return a schema. All logic lives in `services/`.

---

## 4. Coding Standards (Universal)

1. **Clean Architecture** — enforced per §2 and §3, no exceptions.
2. **SOLID** — especially Single Responsibility and Dependency Inversion (depend on abstractions, not concrete classes).
3. **DRY** — if logic is written twice, it must be extracted. AI agents must search for existing implementations before writing new ones (§19).
4. **KISS** — the simplest design that satisfies the requirement wins. Cleverness is a liability, not a virtue.
5. **Feature-first, not type-first** — never organize top-level folders by `screens/`, `models/`, `services/` across the whole app; organize by feature, with type-based subfolders inside.
6. **Strong typing everywhere.** No `dynamic` in Dart, no untyped `dict`/`Any` in Python where a Pydantic model or dataclass is feasible.
7. **Null safety is non-negotiable.** Dart: no unjustified `!`. Python: use `Optional[...]` explicitly and handle `None`.
8. **Separation of UI and business logic is absolute.** Widgets render state; they do not compute it.

### 4.1 Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Dart files | `snake_case.dart` | `upload_repository.dart` |
| Dart classes | `PascalCase` | `UploadRepositoryImpl` |
| Dart variables/functions | `camelCase` | `uploadMedia()` |
| Riverpod providers | `camelCase` + `Provider` suffix | `authStateProvider` |
| Python files/modules | `snake_case.py` | `scan_service.py` |
| Python classes | `PascalCase` | `ScanService` |
| Python functions/vars | `snake_case` | `run_inference()` |
| Folders | `snake_case`, plural for collections | `repositories/`, `widgets/` |
| API routes | `kebab-case`, plural nouns | `/api/v1/scans` |

### 4.2 Documentation & Comments Policy

- Every public class and function gets a doc comment (`///` in Dart, docstring in Python) describing **purpose**, not implementation detail.
- Comments explain **why**, not **what** — the code already says what; assume the reader can read code.
- No commented-out code committed to the repository.
- Every repository interface documents its contract (inputs, outputs, error conditions).

### 4.3 Error Handling

- **Dart:** Domain layer returns `Either<Failure, T>` or a sealed `Result` type — never throw raw exceptions across layer boundaries. UI maps `Failure` to user-facing messages via a centralized mapper.
- **Python:** Raise typed exceptions from a custom hierarchy (`AppException` subclasses). A single global exception handler converts them to the standard error schema (§8.4). Never let raw stack traces reach the client.
- No silent failures. No empty `catch {}` blocks. No bare `except:`.

### 4.4 Logging Standards

- Structured logging only (JSON in production for backend).
- Log levels used intentionally: `DEBUG` (dev detail), `INFO` (business events), `WARNING` (recoverable issues), `ERROR` (failures needing attention), `CRITICAL` (system-down).
- Never log secrets, tokens, passwords, or raw uploaded media content.
- Every backend request log includes a correlation/request ID.

---

## 5. Flutter-Specific Rules

### 5.1 Riverpod

- Prefer `Notifier` / `AsyncNotifier` (Riverpod 2.x generator-based) over legacy `StateNotifier` for new code.
- Providers live in the feature's `presentation/providers/` folder — never inline inside widget files.
- No business logic inside a `Notifier`'s build method beyond orchestration; actual logic belongs in use cases.
- Providers depend on **repository interfaces**, never concrete implementations, via `ref.watch`/`ref.read` of an abstract provider that's overridden at the composition root for tests/mocks.

### 5.2 GoRouter

- All routes are declared centrally in `core/routing/`.
- Route paths are named constants — never hardcoded path strings scattered through the app.
- Guards (auth redirects, onboarding checks) live in router `redirect` callbacks, not inside individual screens.

### 5.3 Widget Decomposition

- A widget's `build()` method should be readable in one screen of code. If it isn't, extract sub-widgets.
- Stateless by default. Use `ConsumerWidget`/`HookConsumerWidget` for read access to providers; reserve stateful widgets for purely local, ephemeral UI state (e.g. animation controllers).
- No widget should directly perform an HTTP call, database query, or file I/O.

### 5.4 Responsive UI & Theming

- Use `LayoutBuilder`/breakpoints from `core/theme/` — no hardcoded pixel breakpoints duplicated across screens.
- All colors, spacing, and typography come from the central `ThemeData` / design tokens — never inline hex codes or magic numbers in widgets.
- Full dark mode parity is required for every screen before it is considered "done."

### 5.5 Animations & Performance

- Prefer implicit animations (`AnimatedContainer`, `AnimatedSwitcher`) over manual `AnimationController` unless fine-grained control is required.
- Avoid rebuilding large widget trees: scope `ref.watch` as narrowly as possible (`select`), use `const` constructors wherever possible.
- Lists use `ListView.builder`/pagination, never `Column` with unbounded children for dynamic data.

### 5.6 Accessibility

- All interactive elements have semantic labels.
- Minimum tap target size respected (48x48dp).
- Color is never the sole carrier of meaning (e.g. pair red/green status with icon + text).

---

## 6. Backend Constitution (FastAPI)

### 6.1 REST API Principles

- Resource-oriented URLs, plural nouns: `/scans`, `/reports`, `/users/me`.
- Standard HTTP verbs map to standard semantics — no verbs in URLs (`/getScans` is forbidden).
- All endpoints are versioned under `/api/v1/...`. Breaking changes require a new version, not a mutation of v1's contract.

### 6.2 Authentication

- JWT-based access + refresh token pattern.
- Access tokens short-lived (e.g. 15 min); refresh tokens long-lived and rotated on use.
- Tokens validated via a shared FastAPI dependency, never re-implemented per route.
- Password storage uses a strong adaptive hash (bcrypt/argon2) — never reversible encryption.

### 6.3 Standard Error Response Schema

All errors return a consistent shape:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable explanation",
    "details": { "field": "email", "reason": "invalid format" }
  },
  "request_id": "uuid"
}
```

### 6.4 Standard Success Response Schema

```json
{
  "success": true,
  "data": { },
  "request_id": "uuid"
}
```

### 6.5 Repository & Data Abstraction

- Services never import SQLAlchemy models or storage SDKs directly — they depend on repository interfaces.
- Each repository owns exactly one aggregate (e.g. `ScanRepository`, `UserRepository`).
- Database engine and cloud provider must be swappable without touching service-layer code.

### 6.6 Cloud Storage Abstraction

- All file uploads pass through a `StorageClient` interface (`upload()`, `get_signed_url()`, `delete()`).
- Provider-specific implementations (S3, GCS, Azure Blob) live behind this interface — business logic never references provider SDKs directly.

### 6.7 Async Processing & Background Jobs

- Long-running work (inference, report generation) is never executed inline within a request/response cycle.
- Use a task queue (e.g. Celery, ARQ, or FastAPI `BackgroundTasks` only for trivial, fast fire-and-forget work).
- Jobs are idempotent and tracked with a status (`pending`, `processing`, `completed`, `failed`) persisted to the database.

### 6.8 File Upload Handling

- Validate file type (magic-byte sniffing, not just extension) and size before accepting.
- Stream uploads to storage rather than buffering entire files in memory where feasible.
- Generate a unique storage key per upload; never trust client-supplied filenames for storage paths.

### 6.9 Security Best Practices

- Input validated via Pydantic schemas at the boundary — no unvalidated dict access.
- Rate limiting applied per-IP and per-user on auth and upload endpoints.
- CORS explicitly scoped to known frontend origins — never `*` in production.
- All secrets loaded from environment/secret manager, never hardcoded or committed.

---

## 7. AI Integration Constitution

1. **Model deployment is decoupled from the API layer.** FastAPI calls an `InferenceClient` abstraction; the actual model may run in-process, on a separate microservice, or via a third-party API — the rest of the system must not care.
2. **Confidence scoring** is always returned as a normalized float `0.0–1.0` alongside a categorical verdict (`authentic`, `manipulated`, `uncertain`).
3. **Explainability is a first-class output**, not an afterthought — every inference result should be capable of carrying supporting evidence (e.g. heatmap reference, affected regions, model rationale text) even if early models only populate it partially.
4. **Heatmap generation** outputs are stored as artifacts (image overlays) referenced by URL in the result schema, not embedded as base64 blobs in API responses.
5. **Result schema is stable and versioned** so future model upgrades do not break existing clients:

```json
{
  "scan_id": "uuid",
  "media_type": "image | video",
  "verdict": "authentic | manipulated | uncertain",
  "confidence": 0.0,
  "model_version": "string",
  "explainability": {
    "heatmap_url": "string | null",
    "regions_of_interest": [],
    "summary": "string"
  },
  "processed_at": "ISO8601"
}
```

6. **Model versioning** — every inference result records the exact model version used, enabling reproducibility and safe rollback.
7. **Future model replacement** must require zero changes to API contracts or frontend code — only the `InferenceClient` implementation changes.
8. **Caching** — identical media (by content hash) should be eligible for cached results to avoid redundant inference cost, with an explicit override option.
9. **Performance & scalability** — inference is always async (§6.7); the API returns a job reference immediately, and the client polls or receives a push update (see Processing Screen flow).

---

## 8. Database Constitution

### 8.1 Core Entities

- **Users** — identity, auth metadata, profile.
- **Scans** — one record per uploaded media analysis, linking to storage, status, and result.
- **Reports** — generated/exportable summaries derived from one or more scans.
- **Notifications** — user-facing event records (scan complete, report ready, etc.).
- **AuditLogs** — append-only record of security-relevant and state-changing actions.

### 8.2 Standards

- Every table has `id (UUID)`, `created_at`, `updated_at` at minimum.
- **Soft deletes** via `deleted_at` timestamp — hard deletes are reserved for explicit data-retention/GDPR erasure flows only (§9.7).
- Foreign keys are always indexed.
- Timestamps stored in UTC; conversion to local time is a presentation-layer concern only.
- Relationships are explicit (no implicit joins via shared naming conventions) and documented in the schema/migration.

### 8.3 Migration Strategy

- All schema changes go through versioned migrations (Alembic) — never manual schema edits against a live database.
- Migrations are additive and backward-compatible where possible (add nullable column → backfill → enforce constraint, across separate migrations) to support zero-downtime deploys.

---

## 9. Security Constitution

1. **Authentication** — JWT, short-lived access tokens, rotated refresh tokens, secure storage on-device (Flutter Secure Storage, not plain SharedPreferences).
2. **Authorization** — every endpoint explicitly checks the requesting user owns or is permitted to access the resource; never rely on "security through obscure IDs."
3. **Secure file uploads** — type validation, size limits, virus/malware scanning hook point reserved for future integration, storage in non-public buckets with signed URLs for access.
4. **Input validation** — Pydantic on backend, form validators on Flutter; never trust client input, even from the app's own UI.
5. **Encryption** — TLS/HTTPS everywhere in transit; sensitive fields (if any beyond standard auth) encrypted at rest.
6. **Secrets management** — environment variables backed by a secret manager in production; `.env` files never committed; `.env.example` documents required keys without values.
7. **OWASP alignment** — guard against injection, broken auth, sensitive data exposure, broken access control, security misconfiguration (OWASP Top 10) as a standing checklist for code review.
8. **Privacy & GDPR readiness** — users can request export and deletion of their data; uploaded media has a defined retention policy; audit logs do not store raw media content, only references.

---

## 10. Git Workflow

### 10.1 Branch Strategy

- `main` — always production-deployable.
- `develop` — integration branch for upcoming release.
- `feature/<short-description>` — one feature per branch, branched from `develop`.
- `fix/<short-description>` — bug fixes.
- `release/<version>` — stabilization branch before a release.
- `hotfix/<short-description>` — urgent production fixes, branched from `main`.

### 10.2 Commit Convention (Conventional Commits)

```
<type>(<scope>): <short summary>

[optional body]
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `style`.
Example: `feat(upload): add automatic media-type detection`

### 10.3 Pull Request Standards

- One logical change per PR — no bundling unrelated work.
- PR description states: what changed, why, how it was tested.
- PR must pass CI (lint, tests, build) before review.
- Linked to the relevant ticket/issue.

### 10.4 Code Review Checklist

- [ ] Follows folder structure and layering rules (§3)
- [ ] No business logic in UI or route handlers
- [ ] No duplicated logic/models/repositories
- [ ] Error handling follows §4.3
- [ ] Tests added/updated for new behavior
- [ ] No hardcoded secrets or endpoints
- [ ] Naming conventions respected
- [ ] No unnecessary new dependencies introduced

### 10.5 Versioning & Releases

- Semantic Versioning (`MAJOR.MINOR.PATCH`).
- Changelog maintained per release.
- Release branches frozen for new features; only fixes land before tagging.

---

## 11. Testing Standards

| Layer | Type | Tooling |
|---|---|---|
| Flutter domain/data | Unit tests | `flutter_test`, mocks via `mocktail` |
| Flutter widgets | Widget tests | `flutter_test` |
| Flutter end-to-end | Integration tests | `integration_test` |
| Backend services | Unit tests | `pytest` |
| Backend API | API/contract tests | `pytest` + `httpx`/`TestClient` |
| AI models | Validation tests | accuracy/regression test sets, not part of standard CI gate but tracked |
| System | Performance tests | load testing tools (e.g. k6, Locust) before major releases |

**Rule:** No PR introducing new business logic merges without corresponding tests. Mocks used in tests must conform to the same interfaces as production repositories.

---

## 12. Performance Standards

### Flutter
- Avoid unnecessary widget rebuilds (scoped `ref.watch`, `const` widgets).
- Images/videos use proper caching and downsampling for display (never load full-resolution media just to show a thumbnail).
- Pagination for any list with unbounded growth (History, Reports, Notifications).

### Backend
- Database queries are indexed and reviewed for N+1 patterns.
- Heavy work is offloaded to background jobs (§6.7); request/response cycle stays fast.
- Response payloads are paginated for list endpoints.

### Media-Specific
- Image optimization: resize/compress on upload pipeline before long-term storage where appropriate.
- Video optimization: avoid re-encoding more than necessary; stream rather than fully buffer where feasible.
- Caching: identical-content detection avoids redundant inference (§7.8).

---

## 13. UI/UX Constitution

1. **Minimalism** — every screen shows only what the user needs for the task at hand.
2. **Consistency** — identical patterns (buttons, spacing, iconography) used identically everywhere; no per-screen reinvention.
3. **Single responsibility per screen** — each screen does one job well.
4. **No redundant navigation** — no two paths to the same destination unless there's a clear UX reason, and never for the upload flow specifically (§14).
5. **Material 3** as the design system baseline, themed to TrueLens AI's brand.
6. **Full state coverage per screen**: loading, error, empty, and populated states must all be explicitly designed and implemented — no screen ships with only the "happy path" handled.
7. **Skeleton loading** preferred over spinners for content-heavy screens (Dashboard, History, Reports).
8. **Professional typography** — a clear type scale (display/headline/title/body/label) applied consistently via theme, never ad-hoc `TextStyle` overrides.
9. **Dark mode** is a first-class citizen, not an afterthought retrofit.
10. **Accessibility** per §5.6 applies to every new screen before merge.

---

## 14. Upload Flow Rules (Permanent)

This is one of the most important constraints in the entire product and **must never be violated**:

> **There is exactly ONE primary upload workflow.**

```
Upload Media
     ↓
Choose File
     ↓
Automatically detect media type (image vs. video)
     ↓
Route to the correct backend analysis pipeline
```

Rules:

- The UI never asks the user "is this an image or a video?" — detection is automatic, based on the file itself.
- There is never more than one upload entry point per context (e.g. no separate "Upload Image" and "Upload Video" buttons; no duplicate FAB + menu item doing the same thing on one screen).
- Image vs. video pipeline branching is a **backend** concern (§7), driven by detected MIME type/content — not a UI decision tree.
- Any new feature request that implies "a second way to upload" must be redirected into the existing single flow, e.g. via a new source option (camera, gallery, file picker) **within** the one upload step — never a parallel flow.

---

## 15. Things That Must Never Happen

- ❌ Duplicated upload buttons or upload flows
- ❌ Hardcoded business logic in UI or route handlers
- ❌ API calls made directly from widgets
- ❌ Duplicated models (DTOs/entities) representing the same concept
- ❌ Duplicated repositories for the same data source
- ❌ Business logic inside UI components
- ❌ Adding a new package when an existing dependency already solves the problem
- ❌ Over-engineering: building abstractions for requirements that don't exist yet
- ❌ Premature optimization at the cost of clarity, before profiling shows a real bottleneck
- ❌ Silent error handling (swallowed exceptions, empty catch blocks)
- ❌ Bypassing the repository pattern "just this once"
- ❌ Committing secrets, `.env` files, or credentials

---

## 16. Glossary

| Term | Definition |
|---|---|
| **Scan** | A single analysis request for one piece of uploaded media. |
| **Verdict** | The categorical outcome of a scan (`authentic`, `manipulated`, `uncertain`). |
| **Confidence** | Normalized 0–1 score expressing model certainty in the verdict. |
| **Explainability data** | Supporting evidence (heatmaps, regions of interest, rationale) behind a verdict. |
| **Repository (pattern)** | An abstraction that isolates data-access logic from business logic. |
| **Composition root** | The point in the app where concrete implementations are wired to abstract interfaces (e.g. provider overrides, DI container). |

---

## 17. MVP Scope

### Must Have
- Splash, Onboarding, Auth (sign up/in, session persistence)
- Single canonical Upload Flow (image + video, auto-detected)
- Processing screen with real-time/polled status
- Results screen with verdict, confidence, basic explainability
- History of past scans
- Basic Profile & Settings
- Core security (§9) and error handling (§4.3) in place from day one

### Should Have
- Reports (export/share of results)
- Notifications (scan complete, report ready)
- Dark mode polish across all screens
- Caching of repeated-content scans

### Future Features (Explicitly Out of MVP Scope)
- Advanced explainability visualizations (interactive heatmaps, frame-by-frame video breakdown)
- Team/organization accounts and multi-user collaboration
- Public API for third-party integrations
- Browser extension / non-Flutter clients
- Model marketplace or pluggable third-party detection models

**Rule:** No feature from "Future Features" is implemented, scaffolded, or stubbed until explicitly promoted into an active milestone. No exceptions for "while I'm in there anyway."

---

## 18. Amendment Process

This Constitution may evolve, but changes are deliberate:

1. Proposed changes are made as edits to this file in a dedicated PR (`docs(constitution): ...`).
2. The PR description states the rationale and the impact on existing code.
3. Once merged, the new rule is binding immediately for all future work; existing code is migrated opportunistically, not necessarily all at once, unless the change is security-critical.

---

## 19. AI Agent Instructions (Binding)

Every AI coding assistant — including but not limited to Claude, GPT-based agents, and Copilot — operating on this codebase **must** follow these rules before, during, and after generating code:

1. **Read this Constitution first.** If context window limits prevent reading it in full, prioritize: §2 (architecture), §3 (folder structure), §14 (upload flow), §15 (forbidden patterns).
2. **Search before writing.** Before creating a new function, class, model, or repository, search the codebase for an existing equivalent. If one exists, extend or reuse it — do not duplicate it.
3. **Never break the folder structure.** New files go in the location dictated by §3, matching the existing feature's `data/domain/presentation` (Flutter) or `api/services/repositories` (FastAPI) shape.
4. **Refactor instead of duplicating.** If existing code is close but not quite right, the correct action is to refactor it (with care for existing call sites), not to copy-paste a near-identical variant.
5. **Keep APIs replaceable.** Never hardcode a specific implementation (mock, vendor SDK, model) into business logic. Always code against the abstraction defined in the domain layer.
6. **Preserve Clean Architecture boundaries.** Never let presentation-layer code import data-layer concretions directly, and never let backend route handlers contain business logic.
7. **Respect the single upload workflow.** Never introduce a second upload path, screen, or button, regardless of how the request is phrased.
8. **Default to maintainability over speed.** When given an ambiguous instruction, choose the implementation that is easiest for the next contributor (human or AI) to understand and extend — even if a faster hack exists.
9. **No scope creep.** Do not implement anything listed under §17 "Future Features" unless explicitly instructed to promote it into active scope.
10. **Flag conflicts, don't silently resolve them.** If a user request conflicts with this Constitution, the agent should surface the conflict explicitly rather than silently picking a side.
11. **Every generated file should look like it was written by the same disciplined team** — consistent naming, consistent structure, consistent style, regardless of which model or session produced it.

---

*End of Constitution. This document is the contract every contributor — human or AI — agrees to uphold for the duration of the TrueLens AI project.*