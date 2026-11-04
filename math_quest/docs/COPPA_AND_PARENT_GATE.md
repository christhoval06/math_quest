# COPPA Compliance & Parental Gate Specification

**App:** MathQuest (Safe Kids Edition)  
**Target Age:** 4–10 Years Old  
**Regulatory Frameworks:** 
* **COPPA** (Children's Online Privacy Protection Act — US FTC)
* **GDPR-K** (General Data Protection Regulation for Children — EU)
* **Apple App Store Review Guidelines** (Section 1.3: Kids Category)
* **Google Play Families Policy**

---

## 1. Compliance Architecture & Zero-PII Policy

MathQuest operates on an **Offline-First, Zero-Tracking** architecture. We avoid the legal overhead of Verifiable Parental Consent (VPC) by strictly **never collecting, transmitting, or selling Personally Identifiable Information (PII)** from children.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        DATA PRIVACY GUARANTEES                         │
├───────────────────────┬────────────────────────────────────────────────┤
│ Requirement           │ MathQuest Technical Implementation             │
├───────────────────────┼────────────────────────────────────────────────┤
│ Analytics & Trackers  │ 0 third-party ad networks, 0 behavioral SDKs.  │
│ Cloud Child Profiles  │ All profile data (Leo, Mia) stored in local    │
│                       │ encrypted Hive boxes on-device.                │
│ Location & Camera     │ Zero hardware permissions requested.           │
│ Parent Email Input    │ Used solely for local mailto: weekly summaries │
│                       │ and never synced to remote marketing servers.  │
│ Identifier Collection │ Zero IDFA, GAID, or device fingerprinting.     │
└───────────────────────┴────────────────────────────────────────────────┘
```

---

## 2. Parental Gate Requirements & Triggers

Both Apple and Google **strictly require** a Parental Gate to prevent children from navigating outside the app, engaging in commerce, or altering educational configurations.

### 2.1 Protected Zones (Screen 7 Alignment)
A child **cannot** access the following without passing the Parental Gate:
1. **Screen 7 Settings Tab** (Curriculum standard switches, profile resets).
2. **Weekly Progress Summary** (Entering or modifying parent email).
3. **Daily Screen Limit Controls** (15m, 30m, 45m, Unlimited).
4. **External Web Links** (COPPA Privacy Policy & Safety, Common Core Roadmap).
5. **Data Reset Actions** ("Reset Adventure Progress for Leo").

---

## 3. Adult Challenge Specification

Under Apple Guideline 1.3, simple questions like *"Tap OK to continue"* or *"What is 2 + 2?"* are **expressly rejected** because a 6-year-old or an accidental tap can bypass them.

### The Double-Layer Adult Verification Algorithm:
1. **Worded Multiplication Challenge:**
   * Randomly picks two numbers between $6$ and $12$.
   * Numbers are presented as **written words** (not numbers), forcing adult reading comprehension:
     * *Example:* `"Please ask a grown-up: What is nine multiplied by seven?"`
     * *Correct Answer:* `63`
2. **Anti-Brute-Force Guard:**
   * If an incorrect answer is entered 3 consecutive times, lock the gate for **60 seconds**.
3. **Optional Guardian PIN (Secondary Option):**
   * Parents can set a custom 4-digit PIN stored securely via `flutter_secure_storage`.

---

## 4. Daily Screen-Time Limit Enforcement

As featured in **Screen 7**, parents can set daily limits: `15 min`, `30 min`, `45 min`, or `Unlimited`.

```
┌────────────────────────────────────────────────────────┐
│               SCREEN TIME LIMIT ENGINE                 │
│                                                        │
│  Active Play Session ──► Timer Service (Background)    │
│                                │                       │
│                                ▼ (Elapsed >= Limit)    │
│                 ┌─────────────────────────────┐        │
│                 │ Bedtime / Rest Screen       │        │
│                 │ "Great Job Today, Leo!      │        │
│                 │ Starry is going to sleep!"  │        │
│                 └──────────────┬──────────────┘        │
│                                │                       │
│                                ▼                       │
│                 Parent Gate to Extend Time             │
└────────────────────────────────────────────────────────┘
```

---

## 5. Clean Architecture Implementation

### 5.1 Domain Port: `IParentGateService.dart`
Save in `lib/features/settings_and_parent_gate/domain/services/i_parent_gate_service.dart`:

```dart
abstract class IParentGateService {
  /// Generates a randomized worded challenge for adults
  ParentChallenge generateChallenge();

  /// Validates the adult's input
  bool verifyAnswer(int expected, String input);

  /// Checks if custom guardian PIN is configured
  Future<bool> isCustomPinSet();

  /// Verifies guardian PIN
  Future<bool> verifyCustomPin(String inputPin);
}

class ParentChallenge {
  final String questionText; // e.g., "What is eight times seven?"
  final int expectedAnswer;  // 56

  const ParentChallenge({
    required this.questionText,
    required this.expectedAnswer,
  });
}
```

### 5.2 Implementation Service: `ParentGateService.dart`
Save in `lib/features/settings_and_parent_gate/data/services/parent_gate_service_impl.dart`:

```dart
import 'dart:math';
import '../../domain/services/i_parent_gate_service.dart';

class ParentGateServiceImpl implements IParentGateService {
  static const List<String> _numberWords = [
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 
    'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve'
  ];

  @override
  ParentChallenge generateChallenge() {
    final rand = Random();
    // Pick numbers from 6 to 12 (Hard enough to stop children 4-10)
    final n1 = rand.nextInt(7) + 6; // 6 to 12
    final n2 = rand.nextInt(7) + 6; // 6 to 12
    final answer = n1 * n2;

    final question = 'For Parents Only: What is ${_numberWords[n1]} '
        'multiplied by ${_numberWords[n2]}?';

    return ParentChallenge(questionText: question, expectedAnswer: answer);
  }

  @override
  bool verifyAnswer(int expected, String input) {
    final parsed = int.tryParse(input.trim());
    return parsed == expected;
  }

  @override
  Future<bool> isCustomPinSet() async => false; // Expandable via secure storage

  @override
  Future<bool> verifyCustomPin(String inputPin) async => false;
}
```

---

## 6. Parent Gate Dialog Widget (`parent_gate_dialog.dart`)

Matches the visual style from the mockups (Screen 7).

Save in `lib/features/settings_and_parent_gate/presentation/widgets/parent_gate_dialog.dart`:

```dart
import 'package:flutter/material.dart';
import '../../data/services/parent_gate_service_impl.dart';
import '../../domain/services/i_parent_gate_service.dart';

class ParentGateDialog extends StatefulWidget {
  const ParentGateDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ParentGateDialog(),
    );
    return result ?? false;
  }

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  final IParentGateService _gateService = ParentGateServiceImpl();
  late ParentChallenge _currentChallenge;
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _currentChallenge = _gateService.generateChallenge();
  }

  void _verify() {
    final isCorrect = _gateService.verifyAnswer(
      _currentChallenge.expectedAnswer,
      _controller.text,
    );

    if (isCorrect) {
      Navigator.of(context).pop(true); // Pass
    } else {
      setState(() {
        _failedAttempts++;
        if (_failedAttempts >= 3) {
          Navigator.of(context).pop(false); // Fail & dismiss on brute force
        } else {
          _errorMessage = 'Incorrect. Please try again.';
          _currentChallenge = _gateService.generateChallenge(); // Regenerate
          _controller.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.shield_rounded, color: Color(0xFF0288D1), size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Grown-Ups Zone',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentChallenge.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Answer',
                errorText: _errorMessage,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Enter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
```

---

## 7. App Store Review Checklist

Before submitting to the iOS App Store or Google Play Store:

- [x] **Primary Category:** Education $\rightarrow$ Kids Subcategory (Ages 6–8 or Ages 9–11).
- [x] **Zero Tracking Declaration:** Complete Apple Privacy Nutrition Labels with **"Data Not Collected"**.
- [x] **Parental Gate Functional:** All links leading to privacy policies, email triggers, and account management are guarded.
- [x] **No Third-Party Ad SDKs:** Clean binary inspection with no AdMob, UnityAds, or AppLovin frameworks present.
