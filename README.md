  **Chat GPT Clone Application**


A Frontend UI implementation of the ChatGPT interface built with Flutter.

This project focuses on replicating the look and feel of the ChatGPT mobile experience. It functions as a client-side wrapper that sends user input directly to the Gemini API and renders the response.

Note: This is a UI-centric project. It does not include a custom backend, database, or user authentication system. Chat history is stored locally in the app's memory during the session.

**📱 Features**

Real-time AI Chat: Connects directly to Google's Gemini API (gemini-1.5-flash or gemini-pro) to generate actual responses.

UI Clone: Replicates the clean, material design aesthetics of the ChatGPT mobile app.

Dark/Light Mode: fully responsive theme toggling.

In-Memory History: Sidebar drawer displays the current session's chat history (clears on app restart).

Quick Action Buttons: UI demonstrations for common prompts (e.g., "Summarize text", "Write code") that trigger API calls.



**🛠️ Tech Stack**

Frontend: Flutter (Dart)

Intelligence: Google Gemini API (Direct REST calls)

State Management: Local setState (No external database)

Packages:

http: For API communication.

**🚀 Prerequisites**

Flutter SDK installed.

A code editor (VS Code or Android Studio).

A Google Cloud API Key.

**🧩 Scope & Limitations**

No Persistent Database: Chats are lost when you close the app (unless you implement local storage or Firebase).

No User Accounts: The app works anonymously using the API key provided in the code.

Direct API Mode: The app communicates directly from the phone to Google servers.
