# my_app

A Frontend UI implementation of the ChatGPT interface built with Flutter, powered by Google's Gemini AI.

This project focuses on replicating the look and feel of the ChatGPT mobile experience. It functions as a client-side wrapper that sends user input directly to the Gemini API and renders the response.

 # Features

Real-time AI Chat: Connects directly to Google's Gemini API (gemini-1.5-flash or gemini-pro) to generate actual responses.

UI Clone: Replicates the clean, material design aesthetics of the ChatGPT mobile app.

Dark/Light Mode: fully responsive theme toggling.

In-Memory History: Sidebar drawer displays the current session's chat history (clears on app restart).

Quick Action Buttons: UI demonstrations for common prompts (e.g., "Summarize text", "Write code") that trigger API calls.

Markdown Rendering: Displays code blocks and structured text returned by the AI.

#  🛠️ Tech Stack

Frontend: Flutter (Dart)

Intelligence: Google Gemini API (Direct REST calls)

State Management: Local setState (No external database)

Packages: http: For API communication.

# Getting Started

This is for the front end of Chat GPT clone app with basic chat bot integration.

**Prerequisites**

Flutter SDK installed.

A code editor (VS Code or Android Studio).

A Google Cloud API Key.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
