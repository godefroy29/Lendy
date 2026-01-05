# Lendy - Lending Tracker App MVP

## 🎯 Project Goal

Build a simple app to track items you've lent to others with reminder notifications. Core use case: "I lent X to Y, remind me later."

---

## 📋 MVP Scope

### ✅ Core Features
- Create "Item Lent" records with basic info
- List & search lent items
- Mark items as returned
- Photo attachments
- Reminder notifications

### ❌ Out of Scope (Post-MVP)
- Social sharing, public profiles, complex permissions
- Multi-user shared inventory
- Full analytics
- Complex tagging systems

---

## 🚀 MVP Development Steps (In Order)

### Step 1: Environment Setup

#### 1.1 Install Flutter SDK

**Windows Instructions:**

- [ ] **Download Flutter SDK:**
  - Go to [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
  - Download the latest stable Flutter SDK (ZIP file)
  - Extract the ZIP file to a location like `C:\src\flutter` (avoid spaces in path, avoid `C:\Program Files\`)

- [ ] **Add Flutter to PATH:**
  - Open "Environment Variables" (search in Windows Start menu)
  - Under "User variables", find "Path" and click "Edit"
  - Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
  - Click "OK" on all dialogs

- [ ] **Verify Flutter installation:**
  - Open a new PowerShell or Command Prompt window (important: must be new after PATH change)
  - Run: `flutter --version`
  - You should see Flutter version info (e.g., "Flutter 3.x.x")

- [ ] **Accept Flutter licenses:**
  - Run: `flutter doctor --android-licenses`
  - Accept all licenses by typing `y` when prompted

#### 1.2 Set up Android Build Environment

- [ ] **Install Android Studio:**
  - Download from [https://developer.android.com/studio](https://developer.android.com/studio)
  - Run the installer and follow the setup wizard
  - During installation, make sure "Android SDK", "Android SDK Platform", and "Android Virtual Device" are checked

- [ ] **Install Android SDK components:**
  - Open Android Studio
  - Go to: **Tools → SDK Manager** (or **More Actions → SDK Manager**)
  - In the "SDK Platforms" tab, check:
    - ✅ Android 13.0 (Tiramisu) or latest stable
    - ✅ Android SDK Platform 33 (or latest)
  - In the "SDK Tools" tab, check:
    - ✅ Android SDK Build-Tools
    - ✅ Android SDK Command-line Tools
    - ✅ Android SDK Platform-Tools
    - ✅ Android Emulator
    - ✅ Google Play services
    - ✅ Intel x86 Emulator Accelerator (HAXM installer) - if available
  - Click "Apply" and wait for installation

- [ ] **Set up Android environment variables:**
  - Open "Environment Variables" again
  - Create a new user variable:
    - Name: `ANDROID_HOME`
    - Value: `C:\Users\YourUsername\AppData\Local\Android\Sdk` (or your SDK location)
  - Add to Path:
    - `%ANDROID_HOME%\platform-tools`
    - `%ANDROID_HOME%\tools`
    - `%ANDROID_HOME%\tools\bin`

- [ ] **Verify Android setup:**
  - Open a new terminal
  - Run: `adb version` (should show Android Debug Bridge version)
  - Run: `flutter doctor` (check Android toolchain status)

#### 1.3 Set up iOS Build Environment (Optional - Only if you have a Mac)

**Note:** iOS development requires macOS. If you only have Windows, you can skip this and develop for Android only, or use a Mac later.

- [ ] **Install Xcode:**
  - Open App Store on macOS
  - Search for "Xcode" and install (this is large, ~10GB+)
  - After installation, open Xcode and accept the license agreement
  - Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

- [ ] **Install CocoaPods:**
  - Open Terminal
  - Run: `sudo gem install cocoapods`
  - Verify: `pod --version`

- [ ] **Install iOS Simulator:**
  - Open Xcode
  - Go to: **Xcode → Settings → Platforms** (or **Components**)
  - Download iOS Simulator for the latest iOS version

- [ ] **Verify iOS setup:**
  - Run: `flutter doctor` (check iOS toolchain status)

#### 1.4 Install Git (If not already installed)

- [ ] **Check if Git is installed:**
  - Run: `git --version`
  - If command not found, proceed to install

- [ ] **Install Git:**
  - Download from [https://git-scm.com/download/win](https://git-scm.com/download/win)
  - Run installer with default options
  - Verify: `git --version`

#### 1.5 Install VS Code (Recommended IDE)

- [ ] **Download VS Code:**
  - Go to [https://code.visualstudio.com/](https://code.visualstudio.com/)
  - Download and install VS Code

- [ ] **Install Flutter extension:**
  - Open VS Code
  - Go to Extensions (Ctrl+Shift+X)
  - Search for "Flutter" by Dart Code
  - Click "Install" (this also installs the Dart extension automatically)

- [ ] **Verify VS Code setup:**
  - Open VS Code
  - Press `Ctrl+Shift+P` to open command palette
  - Type "Flutter: New Project" - if it appears, extension is working

#### 1.6 Run Flutter Doctor

- [ ] **Check Flutter environment:**
  - Open a new terminal/PowerShell window
  - Run: `flutter doctor`
  - Review the output - you should see checkmarks (✓) for:
    - Flutter (the Flutter SDK itself)
    - Android toolchain (if Android Studio is set up)
    - VS Code (if installed)
    - Connected device (optional at this stage)

- [ ] **Fix any issues:**
  - If you see ✗ (crosses), read the error messages
  - Common fixes:
    - Missing Android licenses: `flutter doctor --android-licenses`
    - Android SDK not found: Check `ANDROID_HOME` environment variable
    - VS Code extension: Install from VS Code extensions marketplace

- [ ] **Expected output (Windows, Android only):**
  ```
  Doctor summary (to see all details, run flutter doctor -v):
  [✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows...)
  [✓] Android toolchain - develop for Android devices
  [✓] VS Code (version x.x.x)
  [✗] Chrome - develop for the web (optional)
  [✗] Windows - develop for Windows (optional)
  ```

#### 1.7 Create Flutter Project

- [ ] **Create project directory:**
  - Navigate to your desired project location (e.g., `I:\GitHub\`)
  - You should already be in `I:\GitHub\Lendy` based on your workspace

- [ ] **Initialize Flutter project:**
  - Open terminal in your project directory
  - Run: `flutter create .` (the dot means "current directory")
  - OR if you want a fresh project: `flutter create lendy` (creates new folder)
  
  **Note:** If you run `flutter create .` in an existing directory with files, Flutter will ask for confirmation. Type `y` to proceed.

- [ ] **Verify project structure:**
  - After creation, you should see:
    ```
    lib/
      └── main.dart
    android/
    ios/
    web/
    pubspec.yaml
    README.md
    ```
  - Check that `lib/main.dart` exists and has default Flutter code

- [ ] **Test the project:**
  - Run: `flutter pub get` (installs dependencies)
  - If you have an Android emulator or device connected:
    - Run: `flutter devices` (should list available devices)
    - Run: `flutter run` (launches the app)
  - You should see the default Flutter counter app

#### 1.8 Verify Everything Works

- [ ] **Final checklist:**
  - [ ] `flutter --version` works
  - [ ] `flutter doctor` shows no critical errors
  - [ ] `flutter create` works
  - [ ] `flutter pub get` works
  - [ ] VS Code Flutter extension is installed
  - [ ] Android Studio is installed (if developing for Android)
  - [ ] Project structure is created correctly

**✅ Step 1 Complete!** You now have a working Flutter development environment.

**Troubleshooting Tips:**
- If `flutter` command not found: Restart terminal, check PATH variable
- If Android SDK not found: Verify `ANDROID_HOME` is set correctly
- If VS Code Flutter commands don't work: Restart VS Code after installing extension
- For more help: Run `flutter doctor -v` for detailed diagnostics

---

### Step 2: Firebase Project Setup
- [ ] Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
- [ ] Enable **Firebase Authentication** (Email/Password provider)
- [ ] Enable **Cloud Firestore** (start in test mode, we'll add rules in Step 4)
- [ ] Enable **Firebase Storage** (for photos later)
- [ ] Register iOS app in Firebase console (get `GoogleService-Info.plist`)
- [ ] Register Android app in Firebase console (get `google-services.json`)
- [ ] Add Firebase config files to Flutter project

---

### Step 3: FlutterFire Integration
- [ ] Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
- [ ] Run `flutterfire configure` to link project
- [ ] Add dependencies to `pubspec.yaml`:
  - [ ] `firebase_core`
  - [ ] `firebase_auth`
  - [ ] `cloud_firestore`
  - [ ] `firebase_storage` (for later)
  - [ ] `firebase_messaging` (for later)
- [ ] Initialize Firebase in `main.dart`

---

### Step 4: Project Structure & State Management
- [ ] Set up folder structure:
  ```
  lib/
    ├── main.dart
    ├── presentation/
    │   ├── screens/
    │   └── widgets/
    ├── domain/
    │   ├── entities/
    │   └── use_cases/
    ├── data/
    │   └── repositories/
    └── services/
  ```
- [ ] Choose state management (Riverpod recommended)
  - [ ] Add `flutter_riverpod` to dependencies
  - [ ] Set up ProviderScope in main.dart

---

### Step 5: Data Model Definition
- [ ] Create `Item` entity class:
  - [ ] title (string, required)
  - [ ] description (string)
  - [ ] borrowerName (string, required)
  - [ ] borrowerContact (string, optional)
  - [ ] lentAt (timestamp)
  - [ ] dueAt (timestamp, nullable)
  - [ ] reminderAt (timestamp, nullable)
  - [ ] status (enum: "lent", "returned")
  - [ ] returnedAt (timestamp, nullable)
  - [ ] photoUrls (array of strings)
  - [ ] createdAt, updatedAt (timestamps)
- [ ] Create `User` entity class (minimal for now)
- [ ] Create Firestore converters (toMap/fromMap)

---

### Step 6: Firebase Security Rules
- [ ] Write Firestore security rules:
  ```javascript
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      match /users/{userId}/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
  ```
- [ ] Deploy rules to Firebase
- [ ] Test rules (only authenticated users can access their own data)

---

### Step 7: Authentication Service
- [ ] Create `AuthService` class
- [ ] Implement `signUp(email, password)`
- [ ] Implement `signIn(email, password)`
- [ ] Implement `signOut()`
- [ ] Implement `getCurrentUser()`
- [ ] Create auth state provider (Riverpod)

---

### Step 8: Authentication Screens
- [ ] Create `LoginScreen`:
  - [ ] Email input field
  - [ ] Password input field
  - [ ] Login button
  - [ ] "Sign up" link/button
- [ ] Create `RegisterScreen`:
  - [ ] Email input field
  - [ ] Password input field
  - [ ] Confirm password field
  - [ ] Register button
  - [ ] "Already have account?" link
- [ ] Add navigation between login/register
- [ ] Handle auth state (redirect to home if logged in)

---

### Step 9: Items Repository
- [ ] Create `FirestoreItemRepository` class
- [ ] Implement `createItem(userId, item)` → writes to `users/{userId}/items/{itemId}`
- [ ] Implement `getItems(userId, status)` → reads items, filters by status
- [ ] Implement `getItem(userId, itemId)` → gets single item
- [ ] Implement `updateItem(userId, itemId, updates)` → updates item
- [ ] Implement `markAsReturned(userId, itemId)` → sets status to "returned", adds returnedAt
- [ ] Add query ordering by `dueAt` / `lentAt`

---

### Step 10: Items List Screen
- [ ] Create `ItemsListScreen`:
  - [ ] App bar with "Lent Items" title
  - [ ] Floating action button (FAB) to add item
  - [ ] List view showing items with status "lent"
  - [ ] Display: item title, borrower name, date lent, due date (if set)
  - [ ] Tap item → navigate to detail screen
- [ ] Create `ItemCard` widget for list items
- [ ] Add loading state
- [ ] Add empty state ("No items lent yet")

---

### Step 11: Create Item Screen
- [ ] Create `CreateItemScreen`:
  - [ ] Form with fields:
    - [ ] Item name (required, text input)
    - [ ] Borrower name (required, text input)
    - [ ] Borrower contact (optional, text input)
    - [ ] Date lent (date picker, default today)
    - [ ] Due date (optional, date picker)
    - [ ] Notes (optional, text area)
  - [ ] Save button
  - [ ] Cancel button
- [ ] Form validation (required fields)
- [ ] On save: create item in Firestore, navigate back
- [ ] Show success/error messages

---

### Step 12: Item Detail Screen
- [ ] Create `ItemDetailScreen`:
  - [ ] Display all item fields
  - [ ] "Mark as Returned" button
  - [ ] "Edit" button (optional for MVP)
  - [ ] "Delete" button (optional for MVP)
- [ ] Implement mark as returned functionality
- [ ] Navigate back to list after marking returned

---

### Step 13: Basic Search
- [ ] Add search bar to `ItemsListScreen`
- [ ] Implement client-side search:
  - [ ] Filter by item title
  - [ ] Filter by borrower name
- [ ] Update list in real-time as user types

---

### Step 14: Returned Items List (Optional but Useful)
- [ ] Add tab/segment control to switch between "Lent" and "Returned"
- [ ] Create `ReturnedItemsScreen` or reuse `ItemsListScreen` with filter
- [ ] Display returned items with return date
- [ ] Show both lists in tabs or separate screens

---

### Step 15: Firebase Storage Setup
- [ ] Configure Firebase Storage security rules:
  ```javascript
  match /b/{bucket}/o {
    match /users/{userId}/items/{itemId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
  ```
- [ ] Add `image_picker` package to dependencies
- [ ] Create `StorageRepository` class:
  - [ ] Implement `uploadPhoto(userId, itemId, file)`
  - [ ] Implement `deletePhoto(url)`

---

### Step 16: Photo Upload Feature
- [ ] Add photo section to `CreateItemScreen`:
  - [ ] "Add Photo" button
  - [ ] Image picker (camera or gallery)
  - [ ] Display selected image(s)
  - [ ] Remove photo option
- [ ] Upload photos to Firebase Storage on save
- [ ] Store photo URLs in item document
- [ ] Add photo display to `ItemDetailScreen`
- [ ] Add photo display to `ItemCard` (thumbnail)

---

### Step 17: FCM Setup
- [ ] Add `firebase_messaging` configuration
- [ ] Request notification permissions (iOS/Android)
- [ ] Create `NotificationTokenService`:
  - [ ] Get FCM token
  - [ ] Store token in `users/{userId}/devices/{deviceId}`
  - [ ] Update token on app start
- [ ] Handle token refresh

---

### Step 18: Reminder UI
- [ ] Add reminder date picker to `CreateItemScreen`
- [ ] Add reminder date picker to `ItemDetailScreen` (edit)
- [ ] Store `reminderAt` timestamp in item document
- [ ] Display reminder info in item cards/details

---

### Step 19: Cloud Functions for Reminders
- [ ] Set up Firebase Cloud Functions:
  - [ ] Install Firebase CLI
  - [ ] Initialize functions: `firebase init functions`
  - [ ] Choose TypeScript or JavaScript
- [ ] Create scheduled function:
  - [ ] Runs every 15 minutes
  - [ ] Queries items where `reminderAt <= now` and `status == "lent"` and `reminderSentAt` doesn't exist
  - [ ] Gets user's FCM tokens from `users/{userId}/devices`
  - [ ] Sends push notification via FCM
  - [ ] Marks `reminderSentAt` on item to avoid duplicates
- [ ] Deploy function: `firebase deploy --only functions`

---

### Step 20: Testing & Polish
- [ ] Test on iOS physical device
- [ ] Test on Android physical device
- [ ] Test notification delivery
- [ ] Test offline behavior (Firestore offline persistence)
- [ ] Fix any bugs
- [ ] Add error handling throughout
- [ ] Add loading indicators
- [ ] Polish UI/UX

---

## 📊 Data Model Reference

### Firestore Collections

#### `users/{userId}`
```
- createdAt (timestamp)
- locale (string, optional)
- notificationPrefs (object, optional)
```

#### `users/{userId}/items/{itemId}`
```
- title (string, required)
- description (string)
- borrowerName (string, required)
- borrowerContact (string)
- lentAt (timestamp)
- dueAt (timestamp, nullable)
- reminderAt (timestamp, nullable)
- status (string enum: "lent", "returned")
- returnedAt (timestamp, nullable)
- photoUrls (array of strings)
- reminderSentAt (timestamp, nullable) // for Cloud Functions
- createdAt (timestamp)
- updatedAt (timestamp)
```

#### `users/{userId}/devices/{deviceId}`
```
- fcmToken (string)
- platform (string)
- createdAt (timestamp)
```

---

## ⚠️ Common Pitfalls to Avoid

- ❌ Don't implement "sharing with others" immediately (permissions explode)
- ❌ Don't rely only on local notifications for reminders
- ❌ Don't over-model borrowers (keep as strings initially)
- ❌ Don't build complex tag/category system before usage data
- ❌ Don't skip security rules (do them early!)

---

## 🎯 Quick MVP Milestones

**Milestone 1 (Steps 1-8):** Working authentication
**Milestone 2 (Steps 9-13):** Core CRUD working - you can track loans!
**Milestone 3 (Steps 14-16):** Photos added - complete record keeping
**Milestone 4 (Steps 17-19):** Notifications working - MVP complete!

---

## 🌐 Website (Post-MVP)

- [ ] Decide: Flutter Web app or separate marketing site
- [ ] If Flutter Web: adapt mobile screens for web
- [ ] If separate: build simple landing page
