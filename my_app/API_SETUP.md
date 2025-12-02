# API Key Setup Guide

This project uses the Google Gemini API for the chatbot functionality.

## 🔑 Setting Up Your API Key

### Step 1: Get Your API Key

1. Visit [Google AI Studio](https://aistudio.google.com)
2. Sign in with your Google account
3. Click **"Get API Key"** in the left sidebar
4. Click **"Create API key"**
5. Select **"Create API key in new project"** or choose an existing project
6. Copy the generated API key

### Step 2: Configure the App

1. Copy the template file:
   ```bash
   cp lib/config.template.dart lib/config.dart
   ```
   
   Or on Windows:
   ```cmd
   copy lib\config.template.dart lib\config.dart
   ```

2. Open `lib/config.dart`

3. Replace `YOUR_GOOGLE_API_KEY_HERE` with your actual API key:
   ```dart
   class Config {
     static const String googleApiKey = 'YOUR_ACTUAL_API_KEY';
   }
   ```

4. Save the file

### Step 3: Run the App

```bash
flutter run
```

## 🔒 Security Notes

- ✅ `lib/config.dart` is in `.gitignore` and will **NOT** be committed to Git
- ✅ `lib/config.template.dart` is safe to commit (contains no real API key)
- ✅ Your API key remains private and secure
- ⚠️ **Never share your API key publicly**
- ⚠️ **Never commit `lib/config.dart` to version control**

## 📝 For Other Developers

If you clone this repository:

1. Copy `lib/config.template.dart` to `lib/config.dart`
2. Add your own Google API key
3. Run the app

## 🆘 Troubleshooting

### Error 403: Forbidden
Your API key doesn't have permission. Create a new API key at [Google AI Studio](https://aistudio.google.com).

### Error 404: Not Found
The Generative Language API might not be enabled. Check your Google Cloud Console.

### Missing config.dart
Copy `config.template.dart` to `config.dart` and add your API key.
