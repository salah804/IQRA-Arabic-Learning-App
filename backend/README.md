# IQRA — PHP/MySQL backend showcase

This is a **portfolio-safe subset** of the IQRA API for a Flutter Arabic-language learning application. It showcases MySQL prepared statements, quiz/question/option queries, structured JSON responses, and Base64 audio handling.

## Included

- `backend/fetch_quiz1.php` — Quiz 1 API
- `backend/fetch_quiz2.php` — Quiz 2 API
- `backend/fetch_quiz3.php` — Quiz 3 API
- `backend/cors.php` — Flutter Web origin handling
- `backend/db_connect.example.php` — example DB connection using environment variables, **no actual credentials**

The existing production `db_connect.php`, admin panel, database contents, and user uploads are **not included**.

## Integration notes

The included quiz endpoints use the existing IQRA MySQL tables (`quiz`, `question`, `options`) and depend on `db_connect.php` to supply a MySQLi `$conn`. To run on your own server, configure database environment variables and create a private `backend/db_connect.php` from the example. Do **not** commit that real connection file.

The endpoints are intended to demonstrate existing quiz-delivery logic. They may expose answer flags to clients and are **not designed for secure high-stakes grading**.

## Security limitations

This ZIP does not include the user-account API because an earlier audit found significant issues in the live backend: password reset without proof of email ownership, plaintext-equivalent password handling, password logging, and missing authorization checks on user-specific endpoints. **Those issues require changes to the running server**, not merely removing code from GitHub. Do not use this subset as a complete or audited production backend.

## Git ignore

With the Flutter project's existing `**/*.php` rule, whitelist only these reviewed showcase files:

```gitignore
**/*.php
!backend/cors.php
!backend/fetch_quiz1.php
!backend/fetch_quiz2.php
!backend/fetch_quiz3.php
!backend/db_connect.example.php
```

Keep the project's existing ignore rules for signing keys, secrets, build artifacts, etc. Verify staged files with `git diff --cached --name-only` before committing, and do not stage any private file.

No files on HelioHost were modified to create this showcase copy.
