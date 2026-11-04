# Written Answer Pad Visual Refresh

## Intent

Make Write mode feel polished and professional while preserving its current behavior, accessibility, haptics, and responsive compact mode.

## Goals

- Present the answer slots and keypad as one cohesive answer surface.
- Improve hierarchy through theme-derived colors, borders, elevation, and button states.
- Make the confirm action visually primary and deletion visually secondary.
- Preserve clear neutral, correct, incorrect, disabled, filled, and pressed states.
- Keep the standard Active Game and compact Buddy Challenge layouts responsive.

## Non-goals

- No changes to answer validation, submission timing, haptics, response modes, or gameplay logic.
- No new dependency or platform-specific styling.
- No hardcoded feature palette that bypasses the selected MathQuest theme.

## Selected Direction

Use a soft-professional answer console. The component receives the active theme accent already supplied by its composition boundary and derives translucent surfaces, borders, shadows, number-key colors, and disabled states from that color plus Material theme surface tokens. Existing semantic success and error colors remain the only result-specific colors.

The answer slots use a soft surface fill, a restrained border at rest, and a stronger theme-colored border when filled. The keypad sits within a subtle rounded panel. Number keys use clean tonal surfaces and consistent rounded borders. Delete remains a secondary tonal action. Confirm becomes a wider labeled primary action—`Check Answer` in standard mode and a compact check action in Buddy mode—using the active theme accent. Disabled controls retain visible shape and contrast without appearing interactive.

## Considered Approaches

- **Soft professional — selected:** balanced hierarchy, theme alignment, and compact-mode readability.
- **Bold game style:** stronger gradients and borders, rejected because it would compete with the problem and feel crowded in Buddy Challenge.
- **Minimal modern:** thinner and flatter, rejected because it would weaken the playful MathQuest character and action hierarchy.

## Constraints and Verification

- Keep `WrittenAnswerPad` provider-free and reusable.
- Use existing theme inputs and `Theme.of(context)`; do not access Riverpod inside the widget.
- Maintain minimum practical touch targets, semantics, keyboard behavior, and existing widget keys.
- Extend widget tests for theme-derived styling, labeled standard confirmation, compact confirmation, disabled states, feedback colors, and phone-width overflow.
