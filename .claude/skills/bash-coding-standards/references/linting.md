# Linting

Run `shellcheck` on every script — it catches quoting bugs, unsafe expansions,
and portability problems that strict mode alone won't.

```bash
shellcheck myscript.sh
```

## Handling findings

- **Prefer fixing** the offense over disabling it.
- If you believe a finding is a false positive, or you're unsure, ask the user
  before disabling.
- When you do disable, justify it in a comment immediately above an inline
  directive scoped to the single line:

```bash
# NOTE: ${MAVEN_CLI_OPTS} must stay unquoted to split into separate args
# shellcheck disable=2086
mvn -U ${MAVEN_CLI_OPTS}
```

Never blanket-disable a check for a whole file to silence one line.
