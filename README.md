# mindflasher_4

Flutter client for Mindflasher with Provider-based state, Laravel backend integration, Telegram Mini App support, and web/app startup flow.

## Current architecture

- Startup route resolution is isolated in `lib/app/app_bootstrap_route.dart`.
- HTTP access goes through `lib/services/app_http_client.dart`.
- Auth is split into `lib/services/auth/auth_api.dart` and `lib/services/auth/auth_local_store.dart`.
- `ProviderUserLogin` orchestrates auth/session bootstrap instead of talking directly to storage and HTTP.

## Logs for manual testing

- Structured local logs are written through `lib/services/logging/app_logger.dart`.
- Important bootstrap/auth/http events are printed in the debug console with a format like: `[12:34:56] INFO [auth] Email login succeeded`.
- Remote backend logging still goes through `lib/services/api_logger.dart`, but local logs remain available even if the backend log endpoint is down.
- Telegram flow now logs whether Telegram is unavailable, waiting for language selection, or authenticating successfully.

## Test coverage added during recovery

- `test/widget_test.dart`: startup route resolution.
- `test/services/app_http_client_test.dart`: HTTP client timeouts and headers.
- `test/providers/data_providers_test.dart`: deck/template providers.
- `test/providers/flashcard_provider_test.dart`: flashcard provider network behavior.
- `test/providers/provider_user_login_test.dart`: auth bootstrap, email login, and Telegram resume after language selection.

## Recovery direction

- Next step is removing token prop-drilling from screens and moving session access into a dedicated session layer.
- After that, Telegram web/app/mini-app behavior can be finalized around one session entry point instead of screen-specific logic.

