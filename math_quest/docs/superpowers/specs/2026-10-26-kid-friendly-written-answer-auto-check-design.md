# Kid-Friendly Written Answer Auto-Check

## Intent

Make Write mode feel more playful and effortless for children while keeping its theme support, accessibility, and one-submission safety.

## Goals

- Give digit controls colorful, raised, kid-friendly surfaces derived from the active theme and the supplied accent color.
- Automatically check an answer about 450 ms after the final required digit is entered so the child can see the completed value first.
- Preserve the existing manual confirmation control as a clear fallback and show a friendly in-progress state while checking.
- Apply the behavior consistently to standard Active Game and compact Buddy Challenge layouts.
- Keep `WrittenAnswerPad` free of providers, persistence, repositories, and platform services.

## Non-goals and anti-goals

- Do not add fixed palette colors that break visual themes or dark mode.
- Do not add a new settings preference for auto-check.
- Do not permit duplicate submissions or remove the existing failure-retry behavior.
- Do not turn the number keys into an overly animated or distracting interface.

## Approaches considered

1. **Recommended and selected: delayed automatic check with a manual fallback.** Submit 450 ms after the final digit. This feels fast for children, still lets them perceive the entered answer, and retains an explicit button for accessibility and recovery.
2. **Manual check with a pulsing button.** Safer against accidental final taps, but adds an unnecessary interaction to every written answer.
3. **Immediate automatic check.** Fastest, but abrupt and gives no visual confirmation window; rejected.

## Design

- Digit buttons use theme/accent-tinted backgrounds, high-contrast foregrounds, stronger rounded borders, and a small lower shadow/elevation for a toy-button feel.
- Standard mode keeps the labeled confirmation button; compact mode keeps the icon confirmation control.
- Entering the final digit schedules one auto-check after 450 ms. Delete, disable, widget disposal, problem replacement, or a manual check cancels it.
- The submission lock remains authoritative, preventing auto-check and manual taps from submitting twice.
- During submission, confirmation presents an in-progress visual and all answer controls remain locked.
- Existing correct/incorrect colors, haptics callback, and parent screen/controller contracts remain unchanged.

## Testing

- Verify colorful controls are derived from the supplied theme/accent rather than fixed colors.
- Verify a complete answer auto-submits once after the delay and not before it.
- Verify manual confirmation before the delay cancels automatic submission.
- Verify deleting before the delay cancels submission.
- Verify failed submission unlocks the pad for retry.
- Re-run Active Game and Buddy Challenge responsive/integration coverage and the full suite.
