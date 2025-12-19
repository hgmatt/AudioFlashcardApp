# AudioFlashcardApp

SwiftUI-based flashcard trainer for Spanish verb conjugations with audio-only or written practice modes.

## Features
- Toggle between **audio response** prompts and **written response** prompts.
- Filter deck by verb ending, tense, subject pronoun, and regularity (regular, irregular, stem-change, spelling-change, highly irregular).
- Latin American friendly mode that hides `vosotros` forms.
- Includes a local JSON dataset with **1,000** high-frequency Spanish verbs and starter irregular forms.
- Dynamic conjugation generator for regular tenses (present, preterite, imperfect, future) with overrides for key irregular verbs.

## Running
1. Open the package in Xcode 15+ on macOS/iOS 17 SDK.
2. Select the `AudioFlashcardApp` scheme and run on an iOS simulator or device.

## Dataset
The file `Sources/AudioFlashcardApp/Resources/verbs_top_1000.json` is generated via `scripts/generate_verb_dataset.py`. Run the script if you need to refresh or adjust metadata:

```bash
python scripts/generate_verb_dataset.py
```
