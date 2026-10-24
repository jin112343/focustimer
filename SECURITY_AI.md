# Remote AI containment

The Gemini credential in public Git history was revoked on 2026-10-25. It must not be restored or replaced with another credential inside the application. The previous `gemini-1.0-pro` target already returns `NOT_FOUND`.

The client now keeps its previous unavailable-AI behavior (no generated analysis/insights/timing, existing score fallback 75) without making a provider request or reading an untracked API-key file. Timer and local storage code is unchanged. The fallback score is not an AI assessment. Existing store binaries are not replaced by this source change; provider-side key revocation protects the exposed credential immediately.

Restoring remote AI requires an authenticated server endpoint, server-side secret storage, authorization, quotas, rate limits, bounded request size, timeouts, and a reviewed data-processing policy. App binaries, Dart defines and bundled dotenv files cannot keep a service credential secret. A compatible current model and store release must be verified before re-enabling the feature.

Validation uses Flutter 3.47.8 / Dart 3.13.7. The phone smoke test uses 390×844. An existing 800×600 tablet layout overflow remains a separate release blocker; this containment change does not claim a new store binary is ready. Existing analyzer warnings and infos remain, but analyzer errors fail CI.
