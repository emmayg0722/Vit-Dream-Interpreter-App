# CLAUDE.md — Claude Code Entrypoint

Product truth lives in **`PDD.md`**. Do not duplicate it here.

## Session start

1. Read `PDD.md` Section 0 (Agent Operating Contract) and Section 1 (Product Core).
2. Check Section 5 (Current State) and Section 6 (Active Plan) for the current task.
3. Use Section 4 (Repository Map) to locate files — do not scan the repo.
4. Before writing code, reply with the "Standard task response" block from PDD Section 0.

## Tool-specific rules

- Verify work with the commands in PDD Section 8.2 (xcodebuild build/test) and fix failures before presenting.
- For any UI task, read the matching section of `design/prototype.jsx` and PDD Section 9 first; match the prototype, don't restyle.
- One task from PDD 6.2 per session-chunk; end each with a commit and, if product truth changed, a minimal PDD update.
- Never print or log dream text in debug output (PDD NFR-005).
- Mark anything unknown as `TBD` and surface it as a question — do not invent requirements.
