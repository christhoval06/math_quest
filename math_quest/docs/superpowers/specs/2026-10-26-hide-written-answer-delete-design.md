# Simplify Written-Answer Controls by Default

## Intent

Simplify the child-facing Write-mode keypad by hiding both backspace and manual confirmation during normal play, while preserving reusable opt-ins and a failure-safe retry path.

## Goals

- Add `showDeleteButton`, defaulting to `false`, to `WrittenAnswerPad`.
- Add `showCheckButton`, defaulting to `false`, to `WrittenAnswerPad`.
- When hidden in standard mode, give the **0** key the full centered bottom row instead of leaving an empty backspace space.
- When hidden in compact Buddy mode, preserve a balanced two-row layout without rendering, focusing, or announcing a delete action.
- Rely on the existing 450 ms automatic check during normal play and omit the manual confirmation control entirely.
- If submission throws, reveal a themed **Try Again** control so a child cannot become trapped with a complete answer and no action.
- Preserve the existing 450 ms auto-check, one-submission lock, theme styling, accessibility, haptics callback, and provider-free boundary.
- When `showDeleteButton` or `showCheckButton` is explicitly `true`, retain the corresponding existing behavior and layout.

## Approaches considered

1. **Selected: optional flags, both controls hidden by default, balanced layout, failure-only retry.** Keeps the shared widget reusable, makes auto-check the clear primary interaction, and prevents a dead end after technical failure.
2. **Remove delete and confirmation permanently.** Simpler internally but prevents future screens from opting into explicit correction or confirmation.
3. **Hide the controls visually but retain their space.** Minimizes layout changes but leaves unexplained gaps and risks invisible accessibility targets.

## Constraints and non-goals

- Do not change automatic submission timing or answer validation.
- Do not add a settings preference or provider dependency.
- Do not render an invisible interactive backspace control.
- Do not render an invisible interactive confirmation control.
- Do not automatically loop retries after submission failure; retry requires the visible failure fallback.
- Do not change Choice mode.

## Testing

- Verify default standard and compact pads contain no delete widget, tooltip, or semantics action.
- Verify the default standard **0** key occupies the centered full-width bottom row.
- Verify `showDeleteButton: true` restores backspace behavior and cancels pending automatic submission when used.
- Verify default standard and compact pads contain no confirmation control before submission.
- Verify successful automatic checking never reveals a confirmation control.
- Verify a failed automatic check reveals one accessible **Try Again** control and pressing it submits exactly once.
- Verify `showCheckButton: true` restores the existing standard and compact confirmation controls.
- Re-run widget, Active Game, Buddy Challenge, analyzer, and full regression coverage.
