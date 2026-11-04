# Smooth Written-Answer Checking Status

## Intent

Remove the brief `Checking…` flicker after a child completes a written answer while preserving useful, accessible progress feedback for genuinely slow submissions.

## Selected approach

Add `showCheckingStatus`, defaulting to `true`, to `WrittenAnswerPad`. After automatic or manual submission starts, wait 250 ms before rendering or announcing the checking status. If submission completes before that delay, no status is shown. When `showCheckingStatus` is `false`, never render or announce the checking status, regardless of submission duration.

## Behavior

- Keep the existing 450 ms automatic-submission delay unchanged.
- Keep answer locking and duplicate-submission protection unchanged.
- Show no transient progress UI for submissions completing within 250 ms.
- For slower submissions, show the existing themed `Checking…` status and live accessibility announcement after 250 ms.
- `showCheckingStatus: false` suppresses both visible and semantic checking status.
- Submission failure must still reveal the existing accessible `Try Again` action even when checking status is hidden.
- Apply the behavior consistently to standard and compact modes and to explicitly enabled Check buttons.

## Alternatives considered

- Hide checking feedback permanently: simplest, but provides no feedback during slow work.
- Replace the text with slot animation: visually richer, but larger and unnecessary for fixing the flicker.

## Testing

- A fast submission never renders or announces `Checking…`.
- A pending submission remains quiet for 249 ms, then shows and announces status at 250 ms.
- `showCheckingStatus: false` keeps a slow submission silent.
- Failure still exposes `Try Again` with status disabled.
- Standard, compact, automatic, and explicit-check flows remain covered.
