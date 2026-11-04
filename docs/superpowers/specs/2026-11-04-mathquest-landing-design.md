# MathQuest promotional website

## Intent

Create a separate Flutter website at `/Users/alfamedic/Developer/apps/math_quest/web` that introduces MathQuest to parents and educators. Show how the app teaches arithmetic through visual practice and daily challenges, using actual app screenshots.

## Chosen approach

The user selected a standalone Flutter website with a Dart landing feature. An additional route inside the existing app would reuse infrastructure but would couple the marketing site to gameplay startup. A separate HTML website would suit search indexing but would require a different implementation language. The selected Flutter project keeps the site independent and the feature in Dart.

## Structure and SOLID responsibilities

- Put the feature in the new project's `lib/features/landing`, with a small page composition, individual section widgets, shared design widgets, and screenshot metadata.
- Keep design tokens in a dedicated theme; keep copy in generated ARB localization resources.
- Keep outgoing links and platform launching behind an injected interface so widgets do not implement URL handling.
- Keep asset paths and screenshot captions separate from presentation layout. Avoid speculative repositories or empty architecture layers.
- Do not change existing mobile app behavior or its project configuration.

## Visual design

Use the supplied `DESIGN.md`, `code.html`, and screenshot as visual references. Use the soft lavender canvas, navy headings, orange tactile buttons, sky blue and mint accents, rounded white panels, and generous spacing. Target a centered 1080px content area, with stacked sections on phones and paired text/image layouts on larger screens. Use Plus Jakarta Sans if it can be bundled; otherwise document the font limitation before delivery.

Sections: responsive navigation; hero with two overlapping app screenshots; core operation statistics; visual Base-10 teaching panel; game mode cards; rewards and progress; parent diagnostic reports and controls; a horizontal screenshot gallery; a closing action panel; and a compact footer. Navigation scrolls to the relevant sections. The gallery has working previous/next controls. Respect text scaling and reduced motion, with accessible labels and keyboard focus.

Use the real icon from `math_quest/assets/images/branding` and screenshot files from `math_quest/assets/screens`. Bundle copies in the standalone project so its release build does not rely on sibling directories. Select screenshots after inspecting their content, and preserve their proportions.

## Localization

Provide English, Spanish, and Portuguese ARB resources using Flutter's generated localization tooling. Localize page copy, buttons, navigation, image descriptions, and accessibility labels. Include a visible language selector and use the browser locale initially. Keep the language choice for the current session; persistent storage is not required.

## Actions and content accuracy

No verified store URLs were supplied. Builder decision: make the primary action scroll to the closing panel, where a localized button opens the existing support address (`me@christhoval.dev`) to request availability. Explain availability plainly instead of adding fake store links. Make the action service replaceable when store URLs arrive.

Use supported app features from existing code and project documentation. Do not reproduce unverified ratings, download counts, testimonials, or certification claims from the mockup. Do not generate a QR code without a real download destination.

## Validation and delivery

Run localization generation, formatting, Flutter analysis, meaningful widget tests for responsive layouts/language switching/section actions, and a release web build. Inspect the page in a browser at desktop and mobile widths when browser tooling is available. Document run/build commands in the new project's README.

## Scope boundaries

No hosting, domain setup, app-store publishing, gameplay duplication, analytics, accounts, or backend. This delivers the standalone site source and a locally verified build. The remaining inputs are real store URLs and any approved social proof; neither blocks building the site with the availability action above.
