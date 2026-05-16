# Research AI Assistant

Research AI Assistant is a Flutter-based research productivity application designed to help students, researchers, and early-career developers organize academic workflows more efficiently.

The app supports AI-powered research paper summarization, PDF text extraction, experiment tracking, research notes, project documentation generation, and AI research chat.

---

## Features

### Authentication
- User signup and login
- Persistent login using local storage
- Logout support
- Reset app data option

### Dashboard
- Clean research workspace dashboard
- Quick action cards
- Statistics for summaries, favorites, experiments, and notes
- Recent activity section
- Clickable feature cards

### AI Summary Generator
- Generate structured research paper summaries from title and abstract
- Gemini API integration
- Local fallback summary system when API quota is unavailable
- Save generated summaries
- Edit, copy, search, and favorite saved summaries

### PDF Paper Upload
- Upload research paper PDF files
- Extract readable text from PDFs
- Generate AI-style summaries from extracted PDF content
- Save PDF summaries

### Saved Summaries
- View all saved summaries
- Search summaries
- Mark summaries as favorites
- Edit summary title and content
- Copy summaries to clipboard
- Delete saved summaries

### AI Research Chat
- Ask research-related questions
- Quick prompt chips for common academic tasks
- Persistent local chat history
- Clear chat option
- Useful for thesis ideas, methodology, abstract improvement, and future work suggestions

### Experiment Tracker
- Add experiment name, model name, result, and notes
- Search experiments
- Edit experiment records
- Copy experiment details
- Delete with confirmation
- Persistent local storage

### Research Notes
- Save research ideas and literature review notes
- Search notes
- Edit notes
- Copy notes
- Delete notes with confirmation
- Persistent local storage

### Project Docs Generator
- Generate GitHub-ready README documentation
- Copy generated documentation
- Useful for project submission and portfolio writing

### Profile
- User profile page
- Editable bio
- Profile image upload
- Local profile persistence

### Settings
- Help and guide screen
- About project screen
- Reset app data
- App version information

---

## Tech Stack

- Flutter
- Dart
- SharedPreferences
- HTTP package
- Gemini API
- Syncfusion Flutter PDF
- File Picker
- Image Picker

---

## Project Structure

```text
lib/
├── features/
│   ├── auth/
│   ├── chat/
│   ├── docs/
│   ├── experiment/
│   ├── help/
│   ├── home/
│   ├── navigation/
│   ├── notes/
│   ├── onboarding/
│   ├── paper/
│   ├── profile/
│   ├── settings/
│   └── summary/
│
├── models/
│   ├── chat_message_model.dart
│   ├── experiment_model.dart
│   ├── note_model.dart
│   └── summary_model.dart
│
├── services/
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── experiment_service.dart
│   ├── gemini_service.dart
│   ├── note_service.dart
│   └── summary_service.dart
│
└── main.dart