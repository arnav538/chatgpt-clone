# API Key Setup Guide

This project uses the Google Gemini API. To run the app locally, you need to configure your own API key.

## Local Development Setup

### Step 1: Get a Gemini API Key

1. Visit [Google AI Studio](https://aistudio.google.com)
2. Sign in with your Google account
3. Click on "Get API Key" or "Create API Key"
4. Copy your API key

### Step 2: Configure the API Key

1. In the project root, navigate to `lib/`
2. Copy the example config file:
   ```bash
   cp lib/config.dart.example lib/config.dart
   ```
   
   Or on Windows PowerShell:
   ```powershell
   Copy-Item lib\config.dart.example lib\config.dart
   ```

3. Open `lib/config.dart` and replace `YOUR_API_KEY_HERE` with your actual API key:
   ```dart
   class Config {
     static const String geminiApiKey = 'your-actual-api-key-here';
   }
   ```

### Step 3: Run the App

```bash
flutter pub get
flutter run
```

## Important Security Notes

- ✅ `lib/config.dart` is gitignored and will NOT be committed to the repository
- ✅ Never commit your actual API key to version control
- ✅ The `lib/config.dart.example` file is a template with placeholder values only

## GitHub Actions / CI/CD

This project includes a GitHub Actions workflow that automatically builds the app using the `GEMINI_KEY` repository secret.

The secret is already configured in your repository settings at:
**Settings → Secrets and variables → Actions → Repository secrets → GEMINI_KEY**

The workflow automatically creates `lib/config.dart` during the build process using this secret.

## Troubleshooting

**Error: "Cannot find 'config.dart'"**
- Make sure you've created `lib/config.dart` from the example file
- Verify the file exists in the `lib/` directory

**Error: "API Key invalid"**
- Double-check your API key is correct
- Ensure you've enabled the Generative Language API in Google Cloud Console
- Try creating a new API key at [Google AI Studio](https://aistudio.google.com)
