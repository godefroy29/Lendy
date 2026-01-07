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

- [x] **Download Flutter SDK:**
  - Go to [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
  - Download the latest stable Flutter SDK (ZIP file)
  - Extract the ZIP file to a location like `C:\src\flutter` (avoid spaces in path, avoid `C:\Program Files\`)

- [x] **Add Flutter to PATH:**
  - Open "Environment Variables" (search in Windows Start menu)
  - Under "User variables", find "Path" and click "Edit"
  - Click "New" and add: `C:\src\flutter\bin` (or your Flutter installation path)
  - Click "OK" on all dialogs

- [x] **Verify Flutter installation:**
  - Open a new PowerShell or Command Prompt window (important: must be new after PATH change)
  - Run: `flutter --version`
  - You should see Flutter version info (e.g., "Flutter 3.x.x")

- [x] **Accept Flutter licenses:**
  - Run: `flutter doctor --android-licenses`
  - Accept all licenses by typing `y` when prompted

#### 1.2 Set up Android Build Environment

- [x] **Install Android Studio:**
  - Download from [https://developer.android.com/studio](https://developer.android.com/studio)
  - Run the installer and follow the setup wizard
  - During installation, make sure "Android SDK", "Android SDK Platform", and "Android Virtual Device" are checked

- [x] **Install Android SDK components:**
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

- [x] **Fix cmdline-tools issue (if flutter doctor shows error):**
  - Open Android Studio
  - Go to: **Tools → SDK Manager**
  - In the "SDK Tools" tab, look for "Android SDK Command-line Tools"
  - **Important:** Make sure you check the **latest version** (e.g., "Android SDK Command-line Tools (latest)")
  - If it's already checked, uncheck it, click "Apply", then check it again and click "Apply"
  - Wait for installation to complete
  - Close Android Studio completely
  - Open a new terminal/PowerShell window
  - Run: `flutter doctor` again to verify

- [x] **Accept Android licenses:**
  - Open a terminal/PowerShell window
  - Run: `flutter doctor --android-licenses`
  - You'll be prompted to accept multiple licenses
  - Type `y` and press Enter for each license agreement
  - Continue until all licenses are accepted
  - If you get an error about `sdkmanager` not found:
    - Make sure `ANDROID_HOME` is set correctly (see next step)
    - Try: `%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager --licenses`
  - Verify: Run `flutter doctor` - Android license status should now show as accepted

- [x] **Set up Android environment variables:**
  - Open "Environment Variables" again
  - Create a new user variable:
    - Name: `ANDROID_HOME`
    - Value: `C:\Users\YourUsername\AppData\Local\Android\Sdk` (or your SDK location)
      - **To find your SDK location:** Open Android Studio → **Tools → SDK Manager** → Look at "Android SDK Location" at the top
  - Add to Path (edit the "Path" variable under User variables):
    - `%ANDROID_HOME%\platform-tools`
    - `%ANDROID_HOME%\cmdline-tools\latest\bin` ← **Add this for cmdline-tools**
    - `%ANDROID_HOME%\tools` (if it exists)
    - `%ANDROID_HOME%\tools\bin` (if it exists)
  - Click "OK" on all dialogs
  - **Important:** Close and reopen your terminal/PowerShell window for changes to take effect

- [-] **Verify Android setup:**
  - Open a new terminal
  - Run: `adb version` (should show Android Debug Bridge version)
  - Run: `flutter doctor` (check Android toolchain status)

#### 1.3 Create Flutter Project

- [x] **Create project directory:**
  - Navigate to your desired project location (e.g., `I:\GitHub\`)
  - You should already be in `I:\GitHub\Lendy` based on your workspace

- [x] **Initialize Flutter project:**
  - Open terminal in your project directory
  - Run: `flutter create .` (the dot means "current directory")
  - OR if you want a fresh project: `flutter create lendy` (creates new folder)
  
  **Note:** If you run `flutter create .` in an existing directory with files, Flutter will ask for confirmation. Type `y` to proceed.

- [x] **Verify project structure:**
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

- [x] **Test the project:**
  - Run: `flutter pub get` (installs dependencies)
  - If you have an Android emulator or device connected:
    - Run: `flutter devices` (should list available devices)
    - Run: `flutter run` (launches the app)
  - You should see the default Flutter counter app

#### 1.4 Verify Everything Works

- [x] **Final checklist:**
  - [x] `flutter --version` works
  - [x] `flutter doctor` shows no critical errors
  - [x] `flutter create` works
  - [x] `flutter pub get` works
  - [x] VS Code Flutter extension is installed
  - [x] Android Studio is installed (if developing for Android)
  - [x] Project structure is created correctly


---

### Step 2: Supabase Project Setup


#### 2.1 Create Supabase Account and Project

- [x] **Sign up for Supabase:**
  - Go to [https://supabase.com](https://supabase.com)
  - Click **"Start your project"** or **"Sign up"**
  - Sign up with your GitHub account (recommended) or email
  - Verify your email if required

- [x] **Create a new Supabase project:**
  - After signing in, click **"New Project"** button
  - **Project details:**
    - **Name:** Enter `lendy` (or `lendy-app`, `lendy-tracker`, etc.)
    - **Database Password:** Create a strong password (save this - you'll need it!)
      - **Important:** Save this password securely - you won't be able to see it again
    - **Region:** Select the closest region to your users
      - Options: US East, US West, EU West, EU Central, Asia Pacific, etc.
  - Click **"Create new project"**
  - Wait for Supabase to create your project (2-3 minutes)
  - You'll see a loading screen - wait until it says "Project is ready"

- [x] **Verify project creation:**
  - You should now see your project dashboard
  - Note your project name at the top
  - You'll see various sections: Database, Authentication, Storage, etc.

#### 2.2 Get Your Supabase Credentials

- [x] **Navigate to Project Settings:**
  - Click the **gear icon** (⚙️) in the left sidebar
  - Click **"API"** or **"Project Settings"** → **"API"**

- [x] **Copy your project credentials:**
  - You'll see several important values:
    - **Project URL:** Something like `https://xxxxxxxxxxxxx.supabase.co`
    - **anon/public key:** A long string starting with `eyJ...` (this is safe to use in client apps)
    - **service_role key:** Another long string (keep this secret - never use in client apps!)
  - **Copy the Project URL and anon key** - you'll need these in Step 3
  - Save them in a safe place (text file, notes app, etc.)

- [x] **Verify credentials:**
  - Make sure you have:
    - ✅ Project URL
    - ✅ anon/public key
  - These are the only credentials you need for the Flutter app

#### 2.3 Enable Email Authentication

- [x] **Navigate to Authentication:**
  - In the Supabase dashboard, click **"Authentication"** in the left sidebar
  - Click **"Providers"** tab

- [x] **Configure Email provider:**
  - Find **"Email"** in the list of providers
  - Email is enabled by default, but verify:
    - **Enable Email provider:** Should be ON (toggle if needed)
    - **Confirm email:** You can leave this ON (recommended for security)
    - **Secure email change:** Leave ON
  - Click **"Save"** if you made changes

- [ ] **Configure email templates (optional for MVP):**
  - Go to **"Email Templates"** tab
  - Supabase provides default templates - these work fine for MVP
  - You can customize them later if needed

- [x] **Verify Authentication is ready:**
  - Go to **"Users"** tab
  - It will be empty (no users yet - that's normal)
  - Authentication is ready to use

#### 2.4 Set Up Database Tables

- [x] **Navigate to Table Editor:**
  - In Supabase dashboard, click **"Table Editor"** in the left sidebar
  - You'll see an empty database

- [-] **Create users table (optional - Supabase handles this automatically):**
  - Supabase automatically creates an `auth.users` table for authentication
  - You don't need to create this manually
  - We'll create our custom tables in Step 5 (Data Model)

- [x] **Verify database is ready:**
  - You should see the Table Editor interface
  - The database is ready - we'll create tables in Step 5

#### 2.5 Set Up Storage Bucket

- [x] **Navigate to Storage:**
  - In Supabase dashboard, click **"Storage"** in the left sidebar
  - Click **"New bucket"** button

- [x] **Create photos bucket:**
  - **Bucket name:** `item-photos` (or `photos`, `images`, etc.)
  - **Public bucket:** Toggle ON (so photos can be accessed via URL)
    - **Note:** For MVP, public is fine. We'll add proper security in Step 6
  - Click **"Create bucket"**

- [x] **Verify Storage is ready:**
  - You should see your bucket listed
  - It will be empty (no files yet - that's normal)
  - Storage is ready for photo uploads

#### 2.6 Verify Supabase Project Setup

- [x] **Check all services are ready:**
  - In Supabase dashboard, verify:
    - ✅ **Authentication** - Email provider enabled
    - ✅ **Database** - PostgreSQL database ready
    - ✅ **Storage** - Bucket created
  - All services should be active

- [x] **Verify project settings:**
  - Go to Settings → API
  - Check that you have:
    - ✅ Project URL
    - ✅ anon/public key
  - Note your **Project Reference ID** (you'll see it in the URL)

- [x] **Test Supabase connection (optional):**
  - You can't fully test until Step 3, but verify:
    - Supabase dashboard loads without errors
    - All services show as ready
    - You can access Table Editor, Authentication, and Storage

---

### Step 3: Supabase Integration

#### 3.1 Add Supabase Dependencies to pubspec.yaml

- [x] **Open pubspec.yaml:**
  - Navigate to: `lendy/pubspec.yaml`
  - Open it in VS Code or your text editor

- [x] **Add Supabase dependencies:**
  - Find the `dependencies:` section (usually around line 30-40)
  - Add the following packages under `dependencies:`:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      
      # Supabase packages
      supabase_flutter: ^2.0.0
      
      # Other dependencies (keep existing ones like cupertino_icons)
      cupertino_icons: ^1.0.2
    ```
  - **Note:** Version numbers may vary - use the latest stable version
  - **Tip:** Check latest version at [pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter)

- [x] **Save pubspec.yaml:**
  - Save the file (Ctrl+S)

- [x] **Install dependencies:**
  - In terminal, run: `flutter pub get`
  - Wait for packages to download and install
  - You should see: "Got dependencies!" or similar success message
  - If you see errors, check:
    - Internet connection
    - Version numbers are correct
    - You're in the correct directory

- [x] **Verify dependencies installed:**
  - Check `pubspec.lock` file was updated (don't edit this file)
  - You can also run: `flutter pub deps` to see dependency tree

#### 3.2 Create Supabase Configuration File

- [x] **Create config file:**
  - In your Flutter project, create a new file: `lib/config/supabase_config.dart`
  - Create the `config` folder if it doesn't exist

- [x] **Add Supabase credentials:**
  - Open `lib/config/supabase_config.dart`
  - Add your Supabase configuration:
    ```dart
    class SupabaseConfig {
      // Replace these with your actual Supabase credentials from Step 2.2
      static const String supabaseUrl = 'YOUR_SUPABASE_URL';
      static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
    }
    ```
  - **Important:** Replace `YOUR_SUPABASE_URL` with your Project URL from Step 2.2
  - **Important:** Replace `YOUR_SUPABASE_ANON_KEY` with your anon/public key from Step 2.2
  - Example:
    ```dart
    static const String supabaseUrl = 'https://xxxxxxxxxxxxx.supabase.co';
    static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
    ```

- [x] **Save the config file:**
  - Save the file (Ctrl+S)
  - **Security Note:** For production, consider using environment variables or a secrets file

#### 3.3 Initialize Supabase in main.dart

- [x] **Open main.dart:**
  - Navigate to: `lendy/lib/main.dart`
  - Open it in VS Code

- [x] **Import Supabase packages:**
  - At the top of the file, add these imports:
    ```dart
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'config/supabase_config.dart';
    ```

- [x] **Make main() function async:**
  - Find the `main()` function
  - Change it from `void main()` to `Future<void> main() async`
  - Add `async` keyword

- [x] **Initialize Supabase:**
  - Before `runApp()`, add Supabase initialization:
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      
      runApp(const MyApp());
    }
    ```
  - **Important:** `WidgetsFlutterBinding.ensureInitialized()` must be called before Supabase initialization

- [x] **Your main.dart should look like:**
    ```dart
    import 'package:flutter/material.dart';
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'config/supabase_config.dart';

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Lendy',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Lendy Home'),
        );
      }
    }
    // ... rest of your code
    ```

- [x] **Save main.dart:**
  - Save the file (Ctrl+S)

#### 3.4 Test Supabase Connection

- [x] **Clean and rebuild:**
  - In terminal, run: `flutter clean`
  - Then run: `flutter pub get`
  - This ensures a fresh build

- [x] **Check for errors:**
  - Run: `flutter analyze`
  - Fix any errors that appear
  - Common issues:
    - Missing imports
    - Syntax errors in main.dart
    - Missing dependencies
    - Incorrect Supabase URL or key

- [x] **Test on Android (if emulator/device available):**
  - Start an Android emulator or connect a device
  - Run: `flutter devices` to see available devices
  - Run: `flutter run`
  - The app should launch without Supabase errors
  - Check the console for any Supabase-related errors

- [x] **Verify Supabase initialization:**
  - The app should start without crashing
  - No Supabase-related errors in console
  - If you see errors, check:
    - Supabase URL and key are correct in `supabase_config.dart`
    - `main()` is async and calls `Supabase.initialize()`
    - `WidgetsFlutterBinding.ensureInitialized()` is called first

#### 3.5 Verify Supabase Integration

- [x] **Check configuration file:**
  - Verify `lib/config/supabase_config.dart` exists
  - Verify it contains your correct Supabase URL and anon key
  - Make sure there are no typos in the credentials

- [x] **Verify dependencies:**
  - Run: `flutter pub deps | grep supabase`
  - You should see `supabase_flutter` listed

- [x] **Test Supabase connection (optional):**
  - You can't fully test until Step 7 (Authentication), but verify:
    - App compiles without errors
    - No Supabase initialization errors
    - Credentials are correctly set


---

### Step 4: Project Structure & State Management

#### 4.1 Set Up Folder Structure

- [x] **Create presentation folder:**
  - Navigate to: `lendy/lib/`
  - Create folder: `presentation`
  - Inside `presentation`, create:
    - `screens/` folder (for full-screen UI components)
    - `widgets/` folder (for reusable UI components)

- [x] **Create domain folder:**
  - In `lib/`, create folder: `domain`
  - Inside `domain`, create:
    - `entities/` folder (for data models/entities)
    - `use_cases/` folder (for business logic)

- [x] **Create data folder:**
  - In `lib/`, create folder: `data`
  - Inside `data`, create:
    - `repositories/` folder (for data access layer)

- [x] **Create services folder:**
  - In `lib/`, create folder: `services`
  - This will contain service classes (AuthService, etc.)

- [x] **Verify folder structure:**
  - Your `lib/` folder should now look like:
    ```
    lib/
      ├── main.dart
      ├── config/
      │   └── supabase_config.dart
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
  - **Note:** The `config/` folder already exists from Step 3

#### 4.2 Choose and Set Up State Management (Riverpod)

- [x] **Why Riverpod?**
  - Riverpod is recommended for Flutter apps
  - Provides dependency injection
  - Type-safe state management
  - Easy to test
  - Works well with Supabase

- [x] **Add Riverpod dependency:**
  - Open `lendy/pubspec.yaml`
  - Find the `dependencies:` section
  - Add:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      
      # State management
      flutter_riverpod: ^3.1.0
      
      # Existing dependencies
      supabase_flutter: ^2.0.0
      cupertino_icons: ^1.0.2
    ```
  - **Note:** Check for latest version at [pub.dev/packages/flutter_riverpod](https://pub.dev/packages/flutter_riverpod)

- [x] **Save and install:**
  - Save `pubspec.yaml` (Ctrl+S)
  - Run: `flutter pub get`
  - Wait for installation to complete

- [ ] **Set up ProviderScope in main.dart:**
  - Open `lendy/lib/main.dart`
  - Import Riverpod:
    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    ```
  - Wrap your `MaterialApp` with `ProviderScope`:
    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    }
    ```

- [x] **Update MyApp to ConsumerWidget (optional but recommended):**
  - Change `MyApp` from `StatelessWidget` to `ConsumerWidget`:
    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    
    class MyApp extends ConsumerWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        return MaterialApp(
          title: 'Lendy',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Lendy Home'),
        );
      }
    }
    ```
  - **Note:** `WidgetRef ref` gives you access to providers throughout your app

- [x] **Verify Riverpod setup:**
  - Save `main.dart`
  - Run: `flutter analyze` to check for errors
  - The app should compile without errors

#### 4.3 Create Placeholder Files (Optional but Helpful)

- [x] **Create placeholder files to maintain structure:**
  - In `lib/presentation/screens/`, create: `.gitkeep` (empty file to keep folder in git)
  - In `lib/presentation/widgets/`, create: `.gitkeep`
  - In `lib/domain/entities/`, create: `.gitkeep`
  - In `lib/domain/use_cases/`, create: `.gitkeep`
  - In `lib/data/repositories/`, create: `.gitkeep`
  - In `lib/services/`, create: `.gitkeep`
  - **Note:** `.gitkeep` files are just empty files to ensure folders are tracked by git

**✅ Step 4 Complete!** Your project structure is organized and Riverpod is set up for state management.

---

### Step 5: Data Model Definition

#### 5.1 Create `items` Table in Supabase

- [x] **Navigate to Table Editor:**
  - Go to your Supabase dashboard
  - Click **"Table Editor"** in the left sidebar
  - You should see an empty database (or the default `_prisma_migrations` table)

- [x] **Create new table:**
  - Click **"New Table"** button (top right)
  - **Table name:** Enter `items` (lowercase, no spaces)
  - **Enable Row Level Security:** Check this box ✅
    - **Important:** This ensures users can only access their own items
  - Click **"Save"** or **"Create table"**

- [x] **Add `id` column (Primary Key):**
  - Click **"Add Column"** button
  - **Name:** `id`
  - **Type:** Select `uuid`
  - **Is Primary Key:** Check ✅
  - **Default value:** Enter `gen_random_uuid()`
  - **Is Nullable:** Uncheck (must not be null)
  - Click **"Save"**

- [x] **Add `user_id` column (Foreign Key):**
  - Click **"Add Column"**
  - **Name:** `user_id`
  - **Type:** Select `uuid`
  - **Is Nullable:** Uncheck (must not be null)
  - **Foreign Key:** Click **"Add Foreign Key"**
    - **Referenced Schema:** `auth`
    - **Referenced Table:** `users`
    - **Referenced Column:** `id`
    - **On Delete:** Select `CASCADE` (optional, but recommended)
  - Click **"Save"**

- [x] **Add `title` column:**
  - Click **"Add Column"**
  - **Name:** `title`
  - **Type:** Select `text`
  - **Is Nullable:** Uncheck (required field)
  - Click **"Save"**

- [x] **Add `description` column:**
  - Click **"Add Column"**
  - **Name:** `description`
  - **Type:** Select `text`
  - **Is Nullable:** Check ✅ (optional field)
  - Click **"Save"**

- [x] **Add `borrower_name` column:**
  - Click **"Add Column"**
  - **Name:** `borrower_name`
  - **Type:** Select `text`
  - **Is Nullable:** Uncheck (required field)
  - Click **"Save"**

- [x] **Add `borrower_contact` column:**
  - Click **"Add Column"**
  - **Name:** `borrower_contact`
  - **Type:** Select `text`
  - **Is Nullable:** Check ✅ (optional field)
  - Click **"Save"**

- [x] **Add `lent_at` column:**
  - Click **"Add Column"**
  - **Name:** `lent_at`
  - **Type:** Select `timestamptz` (timestamp with timezone)
  - **Is Nullable:** Uncheck
  - **Default value:** Enter `now()`
  - Click **"Save"**

- [x] **Add `due_at` column:**
  - Click **"Add Column"**
  - **Name:** `due_at`
  - **Type:** Select `timestamptz`
  - **Is Nullable:** Check ✅ (optional field)
  - Click **"Save"**

- [x] **Add `reminder_at` column:**
  - Click **"Add Column"**
  - **Name:** `reminder_at`
  - **Type:** Select `timestamptz`
  - **Is Nullable:** Check ✅ (optional field)
  - Click **"Save"**

- [x] **Add `status` column:**
  - Click **"Add Column"**
  - **Name:** `status`
  - **Type:** Select `text`
  - **Is Nullable:** Uncheck
  - **Default value:** Enter `'lent'`
  - **Check constraint:** Click **"Add Check"**
    - **Constraint name:** `status_check`
    - **Check expression:** `status IN ('lent', 'returned')`
  - Click **"Save"**

- [x] **Add `returned_at` column:**
  - Click **"Add Column"**
  - **Name:** `returned_at`
  - **Type:** Select `timestamptz`
  - **Is Nullable:** Check ✅ (only set when item is returned)
  - Click **"Save"**

- [x] **Add `photo_urls` column:**
  - Click **"Add Column"**
  - **Name:** `photo_urls`
  - **Type:** Select `text[]` (array of text) or `array` → `text`
  - **Is Nullable:** Check ✅ (optional field)
  - Click **"Save"**

- [x] **Add `created_at` column:**
  - Click **"Add Column"**
  - **Name:** `created_at`
  - **Type:** Select `timestamptz`
  - **Is Nullable:** Uncheck
  - **Default value:** Enter `now()`
  - Click **"Save"**

- [x] **Add `updated_at` column:**
  - Click **"Add Column"**
  - **Name:** `updated_at`
  - **Type:** Select `timestamptz`
  - **Is Nullable:** Uncheck
  - **Default value:** Enter `now()`
  - Click **"Save"**

- [x] **Verify table structure:**
  - Review all columns in the table
  - Make sure all required fields are not nullable
  - Verify foreign key relationship is set correctly

#### 5.2 Create Item Entity Class in Flutter

- [x] **Create entity file:**
  - Navigate to: `lendy/lib/domain/entities/`
  - Create new file: `item.dart`

- [x] **Define Item class:**
  - Open `item.dart`
  - Add the following code:
    ```dart
    class Item {
      final String id;
      final String userId;
      final String title;
      final String? description;
      final String borrowerName;
      final String? borrowerContact;
      final DateTime lentAt;
      final DateTime? dueAt;
      final DateTime? reminderAt;
      final String status; // 'lent' or 'returned'
      final DateTime? returnedAt;
      final List<String>? photoUrls;
      final DateTime createdAt;
      final DateTime updatedAt;

      Item({
        required this.id,
        required this.userId,
        required this.title,
        this.description,
        required this.borrowerName,
        this.borrowerContact,
        required this.lentAt,
        this.dueAt,
        this.reminderAt,
        required this.status,
        this.returnedAt,
        this.photoUrls,
        required this.createdAt,
        required this.updatedAt,
      });

      // Convert from JSON (Supabase response)
      factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
          id: json['id'] as String,
          userId: json['user_id'] as String,
          title: json['title'] as String,
          description: json['description'] as String?,
          borrowerName: json['borrower_name'] as String,
          borrowerContact: json['borrower_contact'] as String?,
          lentAt: DateTime.parse(json['lent_at'] as String),
          dueAt: json['due_at'] != null 
              ? DateTime.parse(json['due_at'] as String) 
              : null,
          reminderAt: json['reminder_at'] != null 
              ? DateTime.parse(json['reminder_at'] as String) 
              : null,
          status: json['status'] as String,
          returnedAt: json['returned_at'] != null 
              ? DateTime.parse(json['returned_at'] as String) 
              : null,
          photoUrls: json['photo_urls'] != null 
              ? List<String>.from(json['photo_urls'] as List) 
              : null,
          createdAt: DateTime.parse(json['created_at'] as String),
          updatedAt: DateTime.parse(json['updated_at'] as String),
        );
      }

      // Convert to JSON (for Supabase insert/update)
      Map<String, dynamic> toJson() {
        return {
          'id': id,
          'user_id': userId,
          'title': title,
          'description': description,
          'borrower_name': borrowerName,
          'borrower_contact': borrowerContact,
          'lent_at': lentAt.toIso8601String(),
          'due_at': dueAt?.toIso8601String(),
          'reminder_at': reminderAt?.toIso8601String(),
          'status': status,
          'returned_at': returnedAt?.toIso8601String(),
          'photo_urls': photoUrls,
          'created_at': createdAt.toIso8601String(),
          'updated_at': updatedAt.toIso8601String(),
        };
      }

      // Create a copy with updated fields (useful for updates)
      Item copyWith({
        String? id,
        String? userId,
        String? title,
        String? description,
        String? borrowerName,
        String? borrowerContact,
        DateTime? lentAt,
        DateTime? dueAt,
        DateTime? reminderAt,
        String? status,
        DateTime? returnedAt,
        List<String>? photoUrls,
        DateTime? createdAt,
        DateTime? updatedAt,
      }) {
        return Item(
          id: id ?? this.id,
          userId: userId ?? this.userId,
          title: title ?? this.title,
          description: description ?? this.description,
          borrowerName: borrowerName ?? this.borrowerName,
          borrowerContact: borrowerContact ?? this.borrowerContact,
          lentAt: lentAt ?? this.lentAt,
          dueAt: dueAt ?? this.dueAt,
          reminderAt: reminderAt ?? this.reminderAt,
          status: status ?? this.status,
          returnedAt: returnedAt ?? this.returnedAt,
          photoUrls: photoUrls ?? this.photoUrls,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
        );
      }
    }
    ```

- [x] **Save the file:**
  - Save `item.dart` (Ctrl+S)

- [x] **Verify entity class:**
  - Run: `flutter analyze`
  - Fix any errors that appear
  - Common issues:
    - Missing imports (usually none needed for basic class)
    - Type mismatches

#### 5.3 Create Item Status Enum (Optional but Recommended)

- [x] **Create enum file:**
  - Create: `lendy/lib/domain/entities/item_status.dart`
  - Add:
    ```dart
    enum ItemStatus {
      lent('lent'),
      returned('returned');

      final String value;
      const ItemStatus(this.value);

      static ItemStatus fromString(String value) {
        return ItemStatus.values.firstWhere(
          (status) => status.value == value,
          orElse: () => ItemStatus.lent,
        );
      }
    }
    ```

- [x] **Update Item class to use enum (optional):**
  - You can update `Item` class to use `ItemStatus` instead of `String` for the status field
  - This provides better type safety

#### 5.4 Verify Data Model

- [-] **Test JSON serialization:**
  - Create a simple test or verify in your code:
    ```dart
    // Example usage
    final item = Item(
      id: 'test-id',
      userId: 'user-id',
      title: 'Test Item',
      borrowerName: 'John Doe',
      lentAt: DateTime.now(),
      status: 'lent',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final json = item.toJson();
    final itemFromJson = Item.fromJson(json);
    ```

- [-] **Verify database columns match entity:**
  - Check that all columns in Supabase table match the fields in your `Item` class
  - Column names in database use snake_case (`user_id`)
  - Field names in Dart use camelCase (`userId`)
  - The `fromJson` and `toJson` methods handle this conversion

**✅ Step 5 Complete!** Your data model is defined in both Supabase and Flutter.

**Note on User Entity:**
- Supabase automatically manages the `auth.users` table
- You don't need to create a User entity class
- Access current user via: `Supabase.instance.client.auth.currentUser`
- The user ID (uuid) is what you'll use in `user_id` foreign key

---

### Step 6: Supabase Row Level Security (RLS)

- [x] **Enable Row Level Security:**
  - In Supabase dashboard, go to **"Table Editor"**
  - We'll enable RLS when we create tables in Step 5
  - RLS ensures users can only access their own data

- [x] **Set up RLS policies (after creating tables in Step 5):**
  - Go to **"Authentication"** → **"Policies"** in Supabase dashboard
  - Or go to your table → **"Policies"** tab
  - Click **"New Policy"**

- [x] **Create policy for items table:**
  - **Policy name:** `Users can manage their own items`
  - **Allowed operation:** SELECT, INSERT, UPDATE, DELETE (or choose specific ones)
  - **Policy definition:** 
    ```sql
    (auth.uid() = user_id)
    ```
  - This ensures users can only access rows where `user_id` matches their authenticated user ID
  - Click **"Review"** then **"Save policy"**

- [x] **Create policy for storage bucket:**
  - Go to **"Storage"** → Select your bucket → **"Policies"**
  - Click **"New Policy"**
  - **Policy name:** `Users can manage their own photos`
  - **Allowed operation:** SELECT, INSERT, UPDATE, DELETE
  - **Policy definition:**
    ```sql
    (bucket_id = 'item-photos' AND auth.uid()::text = (storage.foldername(name))[1])
    ```
  - This ensures users can only access files in folders named with their user ID
  - Click **"Review"** then **"Save policy"**

- [ ] **Test RLS policies:**
  - After implementing authentication (Step 7), test that:
    - Users can only see their own items
    - Users cannot access other users' data
    - Unauthenticated users cannot access any data


---

### Step 7: Authentication Service

#### 7.1 Create AuthService Class

- [ ] **Create service file:**
  - Navigate to: `lendy/lib/services/`
  - Create new file: `auth_service.dart`

- [ ] **Import required packages:**
  - Open `auth_service.dart`
  - Add imports at the top:
    ```dart
    import 'package:supabase_flutter/supabase_flutter.dart';
    ```

- [ ] **Create AuthService class:**
  - Add the class structure:
    ```dart
    class AuthService {
      final SupabaseClient _supabase = Supabase.instance.client;
      
      // We'll add methods here
    }
    ```
  - **Note:** `_supabase` is private (starts with `_`) to encapsulate the Supabase client

#### 7.2 Implement Sign Up Method

- [ ] **Add signUp method:**
  - Inside `AuthService` class, add:
    ```dart
    Future<AuthResponse> signUp({
      required String email,
      required String password,
    }) async {
      try {
        final response = await _supabase.auth.signUp(
          email: email,
          password: password,
        );
        return response;
      } catch (e) {
        // Re-throw to let caller handle the error
        rethrow;
      }
    }
    ```
  - **Note:** This returns `AuthResponse` which contains the user and session

- [ ] **Handle email confirmation (if enabled):**
  - If email confirmation is enabled in Supabase, the user will need to verify their email
  - The `signUp` response will have `user?.emailConfirmedAt == null` if not confirmed
  - You can check this in your UI to show a "Check your email" message

#### 7.3 Implement Sign In Method

- [ ] **Add signIn method:**
  - Inside `AuthService` class, add:
    ```dart
    Future<AuthResponse> signIn({
      required String email,
      required String password,
    }) async {
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        return response;
      } catch (e) {
        // Re-throw to let caller handle the error
        rethrow;
      }
    }
    ```

- [ ] **Error handling:**
  - Supabase throws exceptions for invalid credentials
  - Common errors:
    - `InvalidLoginCredentialsException` - wrong email/password
    - `EmailNotConfirmedException` - email not verified (if confirmation enabled)
  - These will be caught and re-thrown for the UI to handle

#### 7.4 Implement Sign Out Method

- [ ] **Add signOut method:**
  - Inside `AuthService` class, add:
    ```dart
    Future<void> signOut() async {
      try {
        await _supabase.auth.signOut();
      } catch (e) {
        // Re-throw to let caller handle the error
        rethrow;
      }
    }
    ```

- [ ] **What signOut does:**
  - Clears the current session
  - Removes the user from `currentUser`
  - Triggers auth state change listeners

#### 7.5 Implement Get Current User Method

- [ ] **Add getCurrentUser method:**
  - Inside `AuthService` class, add:
    ```dart
    User? getCurrentUser() {
      return _supabase.auth.currentUser;
    }
    ```

- [ ] **Understanding currentUser:**
  - Returns `User?` (nullable) - `null` if not authenticated
  - Contains user info: `id`, `email`, `createdAt`, etc.
  - Automatically updated when user signs in/out

- [ ] **Get user ID:**
  - Access user ID: `getCurrentUser()?.id`
  - This is the UUID you'll use for `user_id` in your `items` table

#### 7.6 Create Auth State Stream (Optional but Recommended)

- [ ] **Add auth state stream method:**
  - Inside `AuthService` class, add:
    ```dart
    Stream<AuthState> get authStateChanges {
      return _supabase.auth.onAuthStateChange;
    }
    ```

- [ ] **What this provides:**
  - Real-time updates when user signs in/out
  - Useful for automatically updating UI when auth state changes
  - Returns `AuthState` which contains the current session and user

#### 7.7 Create Riverpod Providers for Authentication

- [ ] **Create providers file:**
  - Navigate to: `lendy/lib/services/`
  - Create new file: `auth_providers.dart`

- [ ] **Import required packages:**
  - Add imports:
    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'auth_service.dart';
    ```

- [ ] **Create AuthService provider:**
  - Add:
    ```dart
    final authServiceProvider = Provider<AuthService>((ref) {
      return AuthService();
    });
    ```
  - This provides a singleton instance of `AuthService`

- [ ] **Create current user provider:**
  - Add:
    ```dart
    final currentUserProvider = StreamProvider<User?>((ref) {
      final authService = ref.watch(authServiceProvider);
      return authService.authStateChanges.map((authState) => authState.session?.user);
    });
    ```
  - This provides the current user as a stream
  - Automatically updates when auth state changes

- [ ] **Alternative: Simple current user provider (if not using stream):**
  - If you prefer a simpler approach:
    ```dart
    final currentUserProvider = Provider<User?>((ref) {
      final authService = ref.watch(authServiceProvider);
      return authService.getCurrentUser();
    });
    ```
  - **Note:** This won't automatically update - you'd need to refresh manually

#### 7.8 Create Auth State Provider (For UI State Management)

- [ ] **Create auth state provider:**
  - In `auth_providers.dart`, add:
    ```dart
    final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
      return AuthStateNotifier(ref);
    });

    class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
      final Ref _ref;
      StreamSubscription<AuthState>? _authSubscription;

      AuthStateNotifier(this._ref) : super(const AsyncValue.loading()) {
        _init();
      }

      void _init() {
        final authService = _ref.read(authServiceProvider);
        
        // Set initial state
        state = AsyncValue.data(authService.getCurrentUser());
        
        // Listen to auth state changes
        _authSubscription = authService.authStateChanges.listen(
          (authState) {
            state = AsyncValue.data(authState.session?.user);
          },
          onError: (error, stackTrace) {
            state = AsyncValue.error(error, stackTrace);
          },
        );
      }

      @override
      void dispose() {
        _authSubscription?.cancel();
        super.dispose();
      }
    }
    ```

- [ ] **Add required imports:**
  - Add to top of `auth_providers.dart`:
    ```dart
    import 'dart:async';
    ```

- [ ] **What this provides:**
  - `AsyncValue<User?>` - loading, data, or error states
  - Automatically updates when auth state changes
  - Easy to use in UI with `ref.watch(authStateProvider)`

#### 7.9 Verify AuthService Implementation

- [ ] **Save all files:**
  - Save `auth_service.dart`
  - Save `auth_providers.dart`

- [ ] **Run analysis:**
  - Run: `flutter analyze`
  - Fix any errors that appear
  - Common issues:
    - Missing imports
    - Type mismatches
    - Undefined classes

- [ ] **Test the service (optional - can test in Step 8):**
  - You can test authentication once you create the UI screens in Step 8
  - For now, verify the code compiles without errors

**✅ Step 7 Complete!** Your authentication service is ready to use.

**Summary:**
- `AuthService` class with sign up, sign in, sign out, and get current user methods
- Riverpod providers for accessing auth state throughout your app
- Stream-based auth state updates for reactive UI
- Error handling ready for UI integration

---

### Step 8: Authentication Screens

#### 8.1 Create LoginScreen

- [ ] **Create screen file:**
  - Navigate to: `lendy/lib/presentation/screens/`
  - Create new file: `login_screen.dart`

- [ ] **Set up basic screen structure:**
  - Open `login_screen.dart`
  - Add imports and create the screen:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../services/auth_service.dart';
    import '../../services/auth_providers.dart';
    import 'register_screen.dart';
    // We'll create home screen later, for now use a placeholder

    class LoginScreen extends ConsumerStatefulWidget {
      const LoginScreen({super.key});

      @override
      ConsumerState<LoginScreen> createState() => _LoginScreenState();
    }

    class _LoginScreenState extends ConsumerState<LoginScreen> {
      final _formKey = GlobalKey<FormState>();
      final _emailController = TextEditingController();
      final _passwordController = TextEditingController();
      bool _isLoading = false;
      String? _errorMessage;

      @override
      void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // We'll add form fields here
                ],
              ),
            ),
          ),
        );
      }
    }
    ```

- [ ] **Add email input field:**
  - Inside the `Column` children, add:
    ```dart
    TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add password input field:**
  - Add after email field:
    ```dart
    TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 12) {
          return 'Password must be at least 12 characters';
        }
        return null;
      },
    ),
    const SizedBox(height: 24),
    ```

- [ ] **Add error message display:**
  - Add after password field (before button):
    ```dart
    if (_errorMessage != null)
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ```

- [ ] **Add login button:**
  - Add:
    ```dart
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Login'),
      ),
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add "Sign up" link:**
  - Add:
    ```dart
    TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
      },
      child: const Text("Don't have an account? Sign up"),
    ),
    ```

- [ ] **Implement _handleLogin method:**
  - Add method before `build`:
    ```dart
    Future<void> _handleLogin() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = ref.read(authServiceProvider);
        await authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Navigation will be handled by auth state listener
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
          // Or use: Navigator.pushReplacement(context, MaterialPageRoute(...))
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Login failed: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
    ```

#### 8.2 Create RegisterScreen

- [ ] **Create screen file:**
  - Navigate to: `lendy/lib/presentation/screens/`
  - Create new file: `register_screen.dart`

- [ ] **Set up basic screen structure:**
  - Similar to LoginScreen, but with additional confirm password field:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../services/auth_service.dart';
    import '../../services/auth_providers.dart';
    import 'login_screen.dart';

    class RegisterScreen extends ConsumerStatefulWidget {
      const RegisterScreen({super.key});

      @override
      ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
    }

    class _RegisterScreenState extends ConsumerState<RegisterScreen> {
      final _formKey = GlobalKey<FormState>();
      final _emailController = TextEditingController();
      final _passwordController = TextEditingController();
      final _confirmPasswordController = TextEditingController();
      bool _isLoading = false;
      String? _errorMessage;

      @override
      void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        _confirmPasswordController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Form fields will go here
                ],
              ),
            ),
          ),
        );
      }
    }
    ```

- [ ] **Add form fields:**
  - Add email, password, and confirm password fields (similar to LoginScreen)
  - For confirm password, add validation:
    ```dart
    TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    ),
    ```

- [ ] **Add register button and navigation:**
  - Similar to login screen, but call `_handleRegister` method
  - Add link to go back to login screen

- [ ] **Implement _handleRegister method:**
  - Add:
    ```dart
    Future<void> _handleRegister() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = ref.read(authServiceProvider);
        await authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          // Show success message or navigate
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please check your email.'),
            ),
          );
          Navigator.pop(context); // Go back to login
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Registration failed: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
    ```

#### 8.3 Set Up Navigation and Auth State Handling

- [ ] **Update main.dart to handle initial route:**
  - Open `lendy/lib/main.dart`
  - Add route configuration:
    ```dart
    MaterialApp(
      title: 'Lendy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(), // We'll create this
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(), // Placeholder for now
      },
    )
    ```

- [ ] **Create AuthWrapper widget:**
  - Create: `lendy/lib/presentation/screens/auth_wrapper.dart`
  - Add:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../services/auth_providers.dart';
    import 'login_screen.dart';
    // import 'home_screen.dart'; // We'll create this later

    class AuthWrapper extends ConsumerWidget {
      const AuthWrapper({super.key});

      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final authState = ref.watch(authStateProvider);

        return authState.when(
          data: (user) {
            if (user != null) {
              // User is logged in, show home screen
              return const Scaffold(
                body: Center(child: Text('Home Screen (Coming Soon)')),
              );
              // Later: return const HomeScreen();
            } else {
              // User is not logged in, show login screen
              return const LoginScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error: $error')),
          ),
        );
      }
    }
    ```

- [ ] **Update main.dart to use AuthWrapper:**
  - Change `home` to use `AuthWrapper`:
    ```dart
    home: const AuthWrapper(),
    ```

#### 8.4 Add Loading and Error States

- [ ] **Improve error handling:**
  - In both LoginScreen and RegisterScreen, show user-friendly error messages
  - Handle specific Supabase errors:
    ```dart
    catch (e) {
      String errorMessage = 'An error occurred';
      if (e.toString().contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password';
      } else if (e.toString().contains('Email not confirmed')) {
        errorMessage = 'Please verify your email before logging in';
      } else {
        errorMessage = e.toString();
      }
      setState(() {
        _errorMessage = errorMessage;
        _isLoading = false;
      });
    }
    ```

---

### Step 9: Items Repository

#### 9.1 Create SupabaseItemRepository Class

- [ ] **Create repository file:**
  - Navigate to: `lendy/lib/data/repositories/`
  - Create new file: `supabase_item_repository.dart`

- [ ] **Import required packages:**
  - Open `supabase_item_repository.dart`
  - Add imports:
    ```dart
    import 'package:supabase_flutter/supabase_flutter.dart';
    import '../../domain/entities/item.dart';
    ```

- [ ] **Create repository class structure:**
  - Add:
    ```dart
    class SupabaseItemRepository {
      final SupabaseClient _supabase = Supabase.instance.client;

      // Methods will be added here
    }
    ```

#### 9.2 Implement Create Item Method

- [ ] **Add createItem method:**
  - Inside the class, add:
    ```dart
    Future<Item> createItem({
      required String userId,
      required Item item,
    }) async {
      try {
        // Convert Item to JSON for Supabase
        final itemJson = item.toJson();
        
        // Remove id, created_at, updated_at as they're auto-generated
        itemJson.remove('id');
        itemJson.remove('created_at');
        itemJson.remove('updated_at');
        
        // Ensure user_id matches the authenticated user
        itemJson['user_id'] = userId;
        
        // Insert into Supabase
        final response = await _supabase
            .from('items')
            .insert(itemJson)
            .select()
            .single();
        
        // Convert response back to Item entity
        return Item.fromJson(response);
      } catch (e) {
        // Re-throw to let caller handle the error
        rethrow;
      }
    }
    ```

- [ ] **Understanding the insert:**
  - `.insert(itemJson)` - inserts the data
  - `.select()` - returns the inserted row
  - `.single()` - expects exactly one row back
  - Supabase automatically sets `id`, `created_at`, `updated_at`

#### 9.3 Implement Get Items Method (with filtering)

- [ ] **Add getItems method:**
  - Add:
    ```dart
    Future<List<Item>> getItems({
      required String userId,
      String? status, // 'lent' or 'returned', null for all
    }) async {
      try {
        // Start building query
        var query = _supabase
            .from('items')
            .select()
            .eq('user_id', userId); // Filter by user_id
        
        // Add status filter if provided
        if (status != null) {
          query = query.eq('status', status);
        }
        
        // Order by due_at (nulls last), then by lent_at (newest first)
        query = query
            .order('due_at', ascending: true)
            .order('lent_at', ascending: false);
        
        // Execute query
        final response = await query;
        
        // Convert list of JSON to list of Items
        return (response as List)
            .map((json) => Item.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        rethrow;
      }
    }
    ```


#### 9.4 Implement Get Single Item Method

- [ ] **Add getItem method:**
  - Add:
    ```dart
    Future<Item?> getItem({
      required String userId,
      required String itemId,
    }) async {
      try {
        final response = await _supabase
            .from('items')
            .select()
            .eq('id', itemId)
            .eq('user_id', userId) // Ensure user owns this item
            .maybeSingle(); // Returns null if not found
        
        if (response == null) {
          return null;
        }
        
        return Item.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **Understanding maybeSingle:**
  - `.maybeSingle()` - returns null if no row found (instead of throwing error)
  - `.single()` - would throw error if no row found
  - Always filter by `user_id` for security (RLS also enforces this)

#### 9.5 Implement Update Item Method

- [ ] **Add updateItem method:**
  - Add:
    ```dart
    Future<Item> updateItem({
      required String userId,
      required String itemId,
      required Map<String, dynamic> updates,
    }) async {
      try {
        // Add updated_at timestamp
        updates['updated_at'] = DateTime.now().toIso8601String();
        
        // Update in Supabase
        final response = await _supabase
            .from('items')
            .update(updates)
            .eq('id', itemId)
            .eq('user_id', userId) // Ensure user owns this item
            .select()
            .single();
        
        return Item.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **Update method notes:**
  - Only include fields you want to update in the `updates` map
  - Always set `updated_at` manually (Supabase doesn't auto-update it)
  - Filter by both `id` and `user_id` for security

#### 9.6 Implement Mark As Returned Method

- [ ] **Add markAsReturned method:**
  - Add:
    ```dart
    Future<Item> markAsReturned({
      required String userId,
      required String itemId,
    }) async {
      try {
        final now = DateTime.now();
        
        final response = await _supabase
            .from('items')
            .update({
              'status': 'returned',
              'returned_at': now.toIso8601String(),
              'updated_at': now.toIso8601String(),
            })
            .eq('id', itemId)
            .eq('user_id', userId)
            .select()
            .single();
        
        return Item.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **What this does:**
  - Sets `status` to 'returned'
  - Records `returned_at` timestamp
  - Updates `updated_at` timestamp

#### 9.7 Implement Delete Item Method (Optional)

- [ ] **Add deleteItem method:**
  - Add:
    ```dart
    Future<void> deleteItem({
      required String userId,
      required String itemId,
    }) async {
      try {
        await _supabase
            .from('items')
            .delete()
            .eq('id', itemId)
            .eq('user_id', userId);
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **Delete method notes:**
  - `.delete()` doesn't return data, just deletes
  - Always filter by `user_id` for security

#### 9.8 Implement Search Items Method (Optional but Useful)

- [ ] **Add searchItems method:**
  - Add:
    ```dart
    Future<List<Item>> searchItems({
      required String userId,
      required String searchQuery,
      String? status,
    }) async {
      try {
        var query = _supabase
            .from('items')
            .select()
            .eq('user_id', userId);
        
        // Search in title or borrower_name
        query = query.or(
          'title.ilike.%$searchQuery%,borrower_name.ilike.%$searchQuery%'
        );
        
        // Add status filter if provided
        if (status != null) {
          query = query.eq('status', status);
        }
        
        // Order results
        query = query
            .order('lent_at', ascending: false);
        
        final response = await query;
        
        return (response as List)
            .map((json) => Item.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        rethrow;
      }
    }
    ```


#### 9.9 Create Repository Provider (Riverpod)

- [ ] **Create provider file:**
  - Navigate to: `lendy/lib/data/repositories/`
  - Create new file: `item_repository_providers.dart`

- [ ] **Add provider:**
  - Add:
    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'supabase_item_repository.dart';

    final itemRepositoryProvider = Provider<SupabaseItemRepository>((ref) {
      return SupabaseItemRepository();
    });
    ```

- [ ] **Usage in widgets:**
  - Access repository: `ref.read(itemRepositoryProvider)`
  - Example:
    ```dart
    final repository = ref.read(itemRepositoryProvider);
    final items = await repository.getItems(userId: userId, status: 'lent');
    ```


---

### Step 10: Items List Screen

#### 10.1 Create ItemsListScreen

- [ ] **Create screen file:**
  - Navigate to: `lendy/lib/presentation/screens/`
  - Create new file: `items_list_screen.dart`

- [ ] **Set up basic screen structure:**
  - Open `items_list_screen.dart`
  - Add imports and create the screen:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../data/repositories/item_repository_providers.dart';
    import '../../domain/entities/item.dart';
    import '../../services/auth_providers.dart';
    import 'create_item_screen.dart';
    import 'item_detail_screen.dart';
    import '../widgets/item_card.dart';

    class ItemsListScreen extends ConsumerStatefulWidget {
      const ItemsListScreen({super.key});

      @override
      ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
    }

    class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Lent Items'),
          ),
          body: const Center(child: Text('Items will appear here')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateItemScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      }
    }
    ```

#### 10.2 Create Items Provider (Riverpod)

- [ ] **Create provider for items list:**
  - Create: `lendy/lib/presentation/providers/items_provider.dart`
  - Add:
    ```dart
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import '../../data/repositories/item_repository_providers.dart';
    import '../../data/repositories/supabase_item_repository.dart';
    import '../../domain/entities/item.dart';
    import '../../services/auth_providers.dart';

    final lentItemsProvider = FutureProvider<List<Item>>((ref) async {
      final repository = ref.watch(itemRepositoryProvider);
      final authState = ref.watch(authStateProvider);
      
      final user = authState.value;
      if (user == null) {
        return [];
      }
      
      return repository.getItems(userId: user.id, status: 'lent');
    });
    ```

- [ ] **Create folder if needed:**
  - Create `lendy/lib/presentation/providers/` folder if it doesn't exist

#### 10.3 Implement Items List Display

- [ ] **Update ItemsListScreen to fetch and display items:**
  - Replace the body in `build` method:
    ```dart
    @override
    Widget build(BuildContext context) {
      final itemsAsync = ref.watch(lentItemsProvider);
      
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lent Items'),
        ),
        body: itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No items lent yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the + button to add an item',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(lentItemsProvider);
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: items[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(itemId: items[index].id),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(lentItemsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateItemScreen(),
              ),
            );
            // Refresh list after returning from create screen
            ref.invalidate(lentItemsProvider);
          },
          child: const Icon(Icons.add),
        ),
      );
    }
    ```

#### 10.4 Create ItemCard Widget

- [ ] **Create widget file:**
  - Navigate to: `lendy/lib/presentation/widgets/`
  - Create new file: `item_card.dart`

- [ ] **Implement ItemCard widget:**
  - Add:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:intl/intl.dart';
    import '../../domain/entities/item.dart';

    class ItemCard extends StatelessWidget {
      final Item item;
      final VoidCallback onTap;

      const ItemCard({
        super.key,
        required this.item,
        required this.onTap,
      });

      @override
      Widget build(BuildContext context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Borrower: ${item.borrowerName}'),
                const SizedBox(height: 4),
                Text(
                  'Lent: ${DateFormat('MMM d, y').format(item.lentAt)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (item.dueAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${DateFormat('MMM d, y').format(item.dueAt!)}',
                    style: TextStyle(
                      color: _isOverdue(item.dueAt!) 
                          ? Colors.red 
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        );
      }

      bool _isOverdue(DateTime dueDate) {
        return dueDate.isBefore(DateTime.now());
      }
    }
    ```

- [ ] **Add intl package for date formatting:**
  - Add to `pubspec.yaml`:
    ```yaml
    intl: ^0.19.0
    ```
  - Run: `flutter pub get`

#### 10.5 Add Pull-to-Refresh

- [ ] **RefreshIndicator is already added:**
  - The `RefreshIndicator` in the list view allows pull-to-refresh
  - `ref.invalidate(lentItemsProvider)` refreshes the data

**✅ Step 10 Complete!** Your items list screen is ready with loading, empty, and error states.

---

### Step 11: Create Item Screen

#### 11.1 Create CreateItemScreen

- [ ] **Create screen file:**
  - Navigate to: `lendy/lib/presentation/screens/`
  - Create new file: `create_item_screen.dart`

- [ ] **Set up basic screen structure:**
  - Open `create_item_screen.dart`
  - Add imports and create the screen:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:intl/intl.dart';
    import '../../data/repositories/item_repository_providers.dart';
    import '../../domain/entities/item.dart';
    import '../../services/auth_providers.dart';

    class CreateItemScreen extends ConsumerStatefulWidget {
      const CreateItemScreen({super.key});

      @override
      ConsumerState<CreateItemScreen> createState() => _CreateItemScreenState();
    }

    class _CreateItemScreenState extends ConsumerState<CreateItemScreen> {
      final _formKey = GlobalKey<FormState>();
      final _titleController = TextEditingController();
      final _descriptionController = TextEditingController();
      final _borrowerNameController = TextEditingController();
      final _borrowerContactController = TextEditingController();
      
      DateTime _lentAt = DateTime.now();
      DateTime? _dueAt;
      DateTime? _reminderAt;
      
      bool _isLoading = false;

      @override
      void dispose() {
        _titleController.dispose();
        _descriptionController.dispose();
        _borrowerNameController.dispose();
        _borrowerContactController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Item'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form fields will go here
                ],
              ),
            ),
          ),
        );
      }
    }
    ```

#### 11.2 Add Form Fields

- [ ] **Add item title field:**
  - Inside the `Column` children, add:
    ```dart
    TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Item Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.inventory_2),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter item name';
        }
        return null;
      },
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add description field:**
  - Add:
    ```dart
    TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add borrower name field:**
  - Add:
    ```dart
    TextFormField(
      controller: _borrowerNameController,
      decoration: const InputDecoration(
        labelText: 'Borrower Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter borrower name';
        }
        return null;
      },
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add borrower contact field:**
  - Add:
    ```dart
    TextFormField(
      controller: _borrowerContactController,
      decoration: const InputDecoration(
        labelText: 'Borrower Contact (optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 16),
    ```

#### 11.3 Add Date Pickers

- [ ] **Add date lent picker:**
  - Add:
    ```dart
    ListTile(
      title: const Text('Date Lent'),
      subtitle: Text(DateFormat('MMM d, y').format(_lentAt)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _lentAt,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _lentAt = date;
          });
        }
      },
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add due date picker:**
  - Add:
    ```dart
    ListTile(
      title: const Text('Due Date (optional)'),
      subtitle: Text(
        _dueAt != null 
            ? DateFormat('MMM d, y').format(_dueAt!) 
            : 'Not set',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_dueAt != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _dueAt = null;
                });
              },
            ),
          const Icon(Icons.calendar_today),
        ],
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueAt ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _dueAt = date;
          });
        }
      },
    ),
    const SizedBox(height: 16),
    ```

- [ ] **Add reminder date picker (optional):**
  - Similar to due date picker, but for `_reminderAt`

#### 11.4 Add Action Buttons

- [ ] **Add save and cancel buttons:**
  - At the end of the Column children, add:
    ```dart
    const SizedBox(height: 24),
    Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    ),
    ```

#### 11.5 Implement Save Handler

- [ ] **Add _handleSave method:**
  - Add before `build` method:
    ```dart
    Future<void> _handleSave() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        
        // Create Item entity
        final item = Item(
          id: '', // Will be generated by database
          userId: user.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          borrowerName: _borrowerNameController.text.trim(),
          borrowerContact: _borrowerContactController.text.trim().isEmpty 
              ? null 
              : _borrowerContactController.text.trim(),
          lentAt: _lentAt,
          dueAt: _dueAt,
          reminderAt: _reminderAt,
          status: 'lent',
          returnedAt: null,
          photoUrls: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await repository.createItem(userId: user.id, item: item);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    ```

**✅ Step 11 Complete!** Your create item screen is ready with form validation and save functionality.

---

### Step 12: Item Detail Screen

#### 12.1 Create ItemDetailScreen

- [ ] **Create screen file:**
  - Navigate to: `lendy/lib/presentation/screens/`
  - Create new file: `item_detail_screen.dart`

- [ ] **Set up basic screen structure:**
  - Open `item_detail_screen.dart`
  - Add imports and create the screen:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:intl/intl.dart';
    import '../../data/repositories/item_repository_providers.dart';
    import '../../domain/entities/item.dart';
    import '../../services/auth_providers.dart';

    class ItemDetailScreen extends ConsumerStatefulWidget {
      final String itemId;

      const ItemDetailScreen({
        super.key,
        required this.itemId,
      });

      @override
      ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
    }

    class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
      @override
      Widget build(BuildContext context) {
        final authState = ref.watch(authStateProvider);
        final user = authState.value;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Not authenticated')),
          );
        }

        final itemFuture = ref.watch(itemDetailProvider(widget.itemId));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Item Details'),
          ),
          body: itemFuture.when(
            data: (item) => _buildItemDetails(item),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(itemDetailProvider(widget.itemId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      Widget _buildItemDetails(Item item) {
        // Details will be built here
        return const Center(child: Text('Item details'));
      }
    }
    ```

#### 12.2 Create Item Detail Provider

- [ ] **Add provider for single item:**
  - In `items_provider.dart`, add:
    ```dart
    final itemDetailProvider = FutureProvider.family<Item, String>((ref, itemId) async {
      final repository = ref.watch(itemRepositoryProvider);
      final authState = ref.watch(authStateProvider);
      
      final user = authState.value;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      
      final item = await repository.getItem(userId: user.id, itemId: itemId);
      if (item == null) {
        throw Exception('Item not found');
      }
      
      return item;
    });
    ```

#### 12.3 Build Item Details Display

- [ ] **Implement _buildItemDetails method:**
  - Replace the placeholder with:
    ```dart
    Widget _buildItemDetails(Item item) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Title
            Text(
              item.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Status Badge
            Chip(
              label: Text(
                item.status.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: item.status == 'lent' 
                  ? Colors.orange.shade100 
                  : Colors.green.shade100,
            ),
            const SizedBox(height: 24),
            
            // Borrower Information
            _buildInfoRow('Borrower', item.borrowerName),
            if (item.borrowerContact != null)
              _buildInfoRow('Contact', item.borrowerContact!),
            
            const Divider(height: 32),
            
            // Dates
            _buildInfoRow(
              'Date Lent',
              DateFormat('MMM d, y').format(item.lentAt),
            ),
            if (item.dueAt != null)
              _buildInfoRow(
                'Due Date',
                DateFormat('MMM d, y').format(item.dueAt!),
                valueColor: _isOverdue(item.dueAt!) ? Colors.red : null,
              ),
            if (item.reminderAt != null)
              _buildInfoRow(
                'Reminder',
                DateFormat('MMM d, y').format(item.reminderAt!),
              ),
            if (item.returnedAt != null) ...[
              const Divider(height: 32),
              _buildInfoRow(
                'Returned On',
                DateFormat('MMM d, y').format(item.returnedAt!),
              ),
            ],
            
            // Description
            if (item.description != null) ...[
              const Divider(height: 32),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(item.description!),
            ],
            
            const SizedBox(height: 32),
            
            // Action Buttons
            if (item.status == 'lent') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _handleMarkAsReturned(item.id),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark as Returned'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: valueColor != null ? FontWeight.w500 : null,
                ),
              ),
            ),
          ],
        ),
      );
    }

    bool _isOverdue(DateTime dueDate) {
      return dueDate.isBefore(DateTime.now());
    }
    ```

#### 12.4 Implement Mark as Returned

- [ ] **Add _handleMarkAsReturned method:**
  - Add:
    ```dart
    Future<void> _handleMarkAsReturned(String itemId) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mark as Returned'),
          content: const Text('Are you sure this item has been returned?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        await repository.markAsReturned(
          userId: user.id,
          itemId: itemId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item marked as returned!')),
          );
          // Refresh the item detail
          ref.invalidate(itemDetailProvider(itemId));
          // Navigate back
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    ```

#### 12.5 Add Delete Functionality (Optional)

- [ ] **Add delete button (if implementing delete):**
  - Add after mark as returned button:
    ```dart
    const SizedBox(height: 8),
    SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _handleDelete(item.id),
        icon: const Icon(Icons.delete, color: Colors.red),
        label: const Text(
          'Delete',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
    ```

- [ ] **Implement _handleDelete method:**
  - Add:
    ```dart
    Future<void> _handleDelete(String itemId) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        await repository.deleteItem(
          userId: user.id,
          itemId: itemId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    ```

**✅ Step 12 Complete!** Your item detail screen is ready with mark as returned and optional delete functionality.

---

### Step 13: Basic Search

#### 13.1 Add Search Bar to ItemsListScreen

- [ ] **Update ItemsListScreen to include search:**
  - Add search controller and state:
    ```dart
    class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
      final _searchController = TextEditingController();
      String _searchQuery = '';

      @override
      void dispose() {
        _searchController.dispose();
        super.dispose();
      }
    ```

- [ ] **Add search bar in AppBar:**
  - Update the AppBar in `build` method:
    ```dart
    AppBar(
      title: _searchQuery.isEmpty 
          ? const Text('Lent Items')
          : Text('Search: $_searchQuery'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Search Items'),
                content: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by title or borrower name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
      ],
    ),
    ```

#### 13.2 Implement Client-Side Search

- [ ] **Update items provider to support search:**
  - Modify `lentItemsProvider` in `items_provider.dart`:
    ```dart
    final lentItemsProvider = FutureProvider.family<List<Item>, String?>((ref, searchQuery) async {
      final repository = ref.watch(itemRepositoryProvider);
      final authState = ref.watch(authStateProvider);
      
      final user = authState.value;
      if (user == null) {
        return [];
      }
      
      List<Item> items;
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // Use repository search method if available
        items = await repository.searchItems(
          userId: user.id,
          searchQuery: searchQuery,
          status: 'lent',
        );
      } else {
        // Get all lent items
        items = await repository.getItems(
          userId: user.id,
          status: 'lent',
        );
      }
      
      return items;
    });
    ```

#### 13.3 Alternative: Client-Side Filtering (Simpler)

- [ ] **If you prefer client-side filtering (no server search):**
  - Keep original provider, filter in UI:
    ```dart
    // In ItemsListScreen build method
    final itemsAsync = ref.watch(lentItemsProvider(null));
    
    return itemsAsync.when(
      data: (allItems) {
        // Filter items client-side
        final filteredItems = _searchQuery.isEmpty
            ? allItems
            : allItems.where((item) {
                final query = _searchQuery.toLowerCase();
                return item.title.toLowerCase().contains(query) ||
                    item.borrowerName.toLowerCase().contains(query);
              }).toList();
        
        // Use filteredItems instead of allItems
        if (filteredItems.isEmpty) {
          return const Center(
            child: Text('No items found'),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(lentItemsProvider(null));
          },
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ItemCard(
                item: filteredItems[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(
                        itemId: filteredItems[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      // ... rest of when clauses
    );
    ```

#### 13.4 Add Search Bar in AppBar (Better UX)

- [ ] **Alternative: Use AppBar search field directly:**
  - Replace AppBar with:
    ```dart
    AppBar(
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search items...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
      ],
    ),
    ```

**✅ Step 13 Complete!** Your search functionality is ready with real-time filtering.

---

### Step 14: Returned Items List (Optional but Useful)

#### 14.1 Create Tab-Based Navigation

- [ ] **Update ItemsListScreen to support tabs:**
  - Modify `ItemsListScreen` to use `DefaultTabController`:
    ```dart
    class ItemsListScreen extends ConsumerStatefulWidget {
      const ItemsListScreen({super.key});

      @override
      ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
    }

    class _ItemsListScreenState extends ConsumerState<ItemsListScreen>
        with SingleTickerProviderStateMixin {
      late TabController _tabController;

      @override
      void initState() {
        super.initState();
        _tabController = TabController(length: 2, vsync: this);
      }

      @override
      void dispose() {
        _tabController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('My Items'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Lent', icon: Icon(Icons.inventory_2)),
                  Tab(text: 'Returned', icon: Icon(Icons.check_circle)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildLentItemsTab(),
                _buildReturnedItemsTab(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateItemScreen(),
                  ),
                );
                // Refresh both tabs
                ref.invalidate(lentItemsProvider);
                ref.invalidate(returnedItemsProvider);
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      }
    }
    ```

#### 14.2 Create Returned Items Provider

- [ ] **Add returned items provider:**
  - In `items_provider.dart`, add:
    ```dart
    final returnedItemsProvider = FutureProvider<List<Item>>((ref) async {
      final repository = ref.watch(itemRepositoryProvider);
      final authState = ref.watch(authStateProvider);
      
      final user = authState.value;
      if (user == null) {
        return [];
      }
      
      return repository.getItems(userId: user.id, status: 'returned');
    });
    ```

#### 14.3 Build Lent Items Tab

- [ ] **Implement _buildLentItemsTab method:**
  - Add:
    ```dart
    Widget _buildLentItemsTab() {
      final itemsAsync = ref.watch(lentItemsProvider);
      
      return itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No items currently lent',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(lentItemsProvider);
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  item: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(
                          itemId: items[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(lentItemsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    ```

#### 14.4 Build Returned Items Tab

- [ ] **Implement _buildReturnedItemsTab method:**
  - Add:
    ```dart
    Widget _buildReturnedItemsTab() {
      final itemsAsync = ref.watch(returnedItemsProvider);
      
      return itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No returned items yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(returnedItemsProvider);
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ReturnedItemCard(
                  item: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(
                          itemId: items[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(returnedItemsProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    ```

#### 14.5 Create ReturnedItemCard Widget

- [ ] **Create widget for returned items:**
  - Create: `lendy/lib/presentation/widgets/returned_item_card.dart`
  - Add:
    ```dart
    import 'package:flutter/material.dart';
    import 'package:intl/intl.dart';
    import '../../domain/entities/item.dart';

    class ReturnedItemCard extends StatelessWidget {
      final Item item;
      final VoidCallback onTap;

      const ReturnedItemCard({
        super.key,
        required this.item,
        required this.onTap,
      });

      @override
      Widget build(BuildContext context) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.green.shade50,
          child: ListTile(
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Borrower: ${item.borrowerName}'),
                const SizedBox(height: 4),
                Text(
                  'Lent: ${DateFormat('MMM d, y').format(item.lentAt)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (item.returnedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Returned: ${DateFormat('MMM d, y').format(item.returnedAt!)}',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            onTap: onTap,
          ),
        );
      }
    }
    ```

#### 14.6 Alternative: Separate Screens Approach

- [ ] **If you prefer separate screens instead of tabs:**
  - Create `ReturnedItemsScreen` similar to `ItemsListScreen`
  - Add navigation button in `ItemsListScreen`:
    ```dart
    AppBar(
      title: const Text('Lent Items'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReturnedItemsScreen(),
              ),
            );
          },
          tooltip: 'View returned items',
        ),
      ],
    ),
    ```

**✅ Step 14 Complete!** Your returned items list is ready with tab navigation or separate screen option.

---

### Step 15: Supabase Storage Setup

- [x] **Verify storage bucket exists:**
  - In Supabase dashboard → **"Storage"**
  - Verify your `item-photos` bucket exists (created in Step 2.5)
  - If not, create it now (public bucket)

- [x] **Add `image_picker` package to dependencies:**
  - Add to `pubspec.yaml`:
    ```yaml
    image_picker: ^1.0.0
    ```
  - Run: `flutter pub get`

#### 15.3 Create StorageRepository Class

- [ ] **Create repository file:**
  - Navigate to: `lendy/lib/data/repositories/`
  - Create new file: `storage_repository.dart`

- [ ] **Import required packages:**
  - Open `storage_repository.dart`
  - Add imports:
    ```dart
    import 'dart:io';
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'package:path/path.dart' as path;
    ```

- [ ] **Add path package to dependencies:**
  - Add to `pubspec.yaml`:
    ```yaml
    path: ^1.8.3
    ```
  - Run: `flutter pub get`

- [ ] **Create StorageRepository class structure:**
  - Add:
    ```dart
    class StorageRepository {
      final SupabaseClient _supabase = Supabase.instance.client;
      final String _bucketName = 'item-photos';

      // Methods will be added here
    }
    ```

#### 15.4 Implement Upload Photo Method

- [ ] **Add uploadPhoto method:**
  - Inside the class, add:
    ```dart
    Future<String> uploadPhoto({
      required String userId,
      required String itemId,
      required File imageFile,
    }) async {
      try {
        // Generate unique filename
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
        
        // Storage path: userId/itemId/filename
        final storagePath = '$userId/$itemId/$fileName';
        
        // Read file as bytes
        final fileBytes = await imageFile.readAsBytes();
        
        // Upload to Supabase Storage
        await _supabase.storage
            .from(_bucketName)
            .uploadBinary(
              storagePath,
              fileBytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: false, // Don't overwrite existing files
              ),
            );
        
        // Get public URL
        final publicUrl = _supabase.storage
            .from(_bucketName)
            .getPublicUrl(storagePath);
        
        return publicUrl;
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **Handle multiple photo uploads:**
  - Add method:
    ```dart
    Future<List<String>> uploadPhotos({
      required String userId,
      required String itemId,
      required List<File> imageFiles,
    }) async {
      final List<String> urls = [];
      
      for (final file in imageFiles) {
        try {
          final url = await uploadPhoto(
            userId: userId,
            itemId: itemId,
            imageFile: file,
          );
          urls.add(url);
        } catch (e) {
          // Log error but continue with other files
          print('Error uploading photo: $e');
        }
      }
      
      return urls;
    }
    ```

#### 15.5 Implement Delete Photo Method

- [ ] **Add deletePhoto method:**
  - Add:
    ```dart
    Future<void> deletePhoto(String photoUrl) async {
      try {
        // Extract path from URL
        // URL format: https://project.supabase.co/storage/v1/object/public/item-photos/userId/itemId/filename
        final uri = Uri.parse(photoUrl);
        final pathSegments = uri.pathSegments;
        
        // Find the index of 'public' and get everything after 'item-photos'
        final publicIndex = pathSegments.indexOf('public');
        if (publicIndex == -1 || publicIndex >= pathSegments.length - 1) {
          throw Exception('Invalid photo URL format');
        }
        
        // Get path after bucket name (item-photos)
        final bucketIndex = pathSegments.indexOf(_bucketName);
        if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
          throw Exception('Invalid photo URL format');
        }
        
        // Reconstruct storage path
        final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
        
        // Delete from storage
        await _supabase.storage
            .from(_bucketName)
            .remove([storagePath]);
      } catch (e) {
        rethrow;
      }
    }
    ```

- [ ] **Add delete multiple photos method:**
  - Add:
    ```dart
    Future<void> deletePhotos(List<String> photoUrls) async {
      for (final url in photoUrls) {
        try {
          await deletePhoto(url);
        } catch (e) {
          // Log error but continue with other files
          print('Error deleting photo: $e');
        }
      }
    }
    ```

#### 15.6 Create Storage Repository Provider

- [ ] **Add provider:**
  - In `item_repository_providers.dart` (or create new file), add:
    ```dart
    final storageRepositoryProvider = Provider<StorageRepository>((ref) {
      return StorageRepository();
    });
    ```

- [ ] **Verify StorageRepository:**
  - Save all files
  - Run: `flutter analyze`
  - Fix any errors

**✅ Step 15 Complete!** Your storage repository is ready for photo uploads and deletions.

---

### Step 16: Photo Upload Feature

#### 16.1 Add Photo Selection to CreateItemScreen

- [ ] **Add image picker state:**
  - In `CreateItemScreen`, add state variables:
    ```dart
    class _CreateItemScreenState extends ConsumerState<CreateItemScreen> {
      // ... existing controllers and state
      List<File> _selectedImages = [];
      bool _isUploadingPhotos = false;
    ```

- [ ] **Add photo selection UI:**
  - After the date pickers, add:
    ```dart
    const Divider(height: 32),
    Text(
      'Photos (optional)',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    const SizedBox(height: 8),
    
    // Display selected images
    if (_selectedImages.isNotEmpty)
      SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImages[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    
    const SizedBox(height: 8),
    
    // Add photo button
    OutlinedButton.icon(
      onPressed: _pickImages,
      icon: const Icon(Icons.add_photo_alternate),
      label: const Text('Add Photos'),
    ),
    ```

#### 16.2 Implement Image Picker

- [ ] **Add _pickImages method:**
  - Add before `build` method:
    ```dart
    Future<void> _pickImages() async {
      try {
        // Show dialog to choose source
        final source = await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );

        if (source == null) return;

        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: source,
          imageQuality: 85, // Compress to 85% quality
          maxWidth: 1920, // Max width
        );

        if (image != null) {
          setState(() {
            _selectedImages.add(File(image.path));
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error picking image: $e')),
          );
        }
      }
    }
    ```

- [ ] **Add required imports:**
  - Add to top of `create_item_screen.dart`:
    ```dart
    import 'dart:io';
    import 'package:image_picker/image_picker.dart';
    import '../../data/repositories/storage_repository.dart';
    import '../../data/repositories/item_repository_providers.dart';
    ```

#### 16.3 Update Save Handler to Upload Photos

- [ ] **Modify _handleSave to upload photos:**
  - Update the `_handleSave` method:
    ```dart
    Future<void> _handleSave() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoading = true;
        _isUploadingPhotos = true;
      });

      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        final storageRepo = ref.read(storageRepositoryProvider);
        
        // Create item first (without photos)
        final item = Item(
          id: '',
          userId: user.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
          borrowerName: _borrowerNameController.text.trim(),
          borrowerContact: _borrowerContactController.text.trim().isEmpty 
              ? null 
              : _borrowerContactController.text.trim(),
          lentAt: _lentAt,
          dueAt: _dueAt,
          reminderAt: _reminderAt,
          status: 'lent',
          returnedAt: null,
          photoUrls: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final createdItem = await repository.createItem(
          userId: user.id,
          item: item,
        );

        // Upload photos if any
        List<String> photoUrls = [];
        if (_selectedImages.isNotEmpty) {
          photoUrls = await storageRepo.uploadPhotos(
            userId: user.id,
            itemId: createdItem.id,
            imageFiles: _selectedImages,
          );

          // Update item with photo URLs
          await repository.updateItem(
            userId: user.id,
            itemId: createdItem.id,
            updates: {
              'photo_urls': photoUrls,
            },
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item created successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
            _isUploadingPhotos = false;
          });
        }
      }
    }
    ```

#### 16.4 Add Photo Display to ItemDetailScreen

- [ ] **Add photo gallery to ItemDetailScreen:**
  - In `_buildItemDetails` method, add after description:
    ```dart
    // Photos section
    if (item.photoUrls != null && item.photoUrls!.isNotEmpty) ...[
      const Divider(height: 32),
      Text(
        'Photos',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: item.photoUrls!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  // Show full screen image
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _FullScreenImage(
                        imageUrl: item.photoUrls![index],
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.photoUrls![index],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
    ```

- [ ] **Add full screen image viewer:**
  - Add helper widget at the end of the file:
    ```dart
    class _FullScreenImage extends StatelessWidget {
      final String imageUrl;

      const _FullScreenImage({required this.imageUrl});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        );
      }
    }
    ```

#### 16.5 Add Photo Thumbnail to ItemCard

- [ ] **Update ItemCard to show thumbnail:**
  - In `item_card.dart`, modify the ListTile:
    ```dart
    ListTile(
      leading: item.photoUrls != null && item.photoUrls!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.photoUrls!.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, size: 50);
                },
              ),
            )
          : const Icon(Icons.inventory_2, size: 50),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      // ... rest of the card
    ),
    ```

- [ ] **Add cached_network_image package (optional but recommended):**
  - Add to `pubspec.yaml`:
    ```yaml
    cached_network_image: ^3.3.0
    ```
  - Use `CachedNetworkImage` instead of `Image.network` for better performance

**✅ Step 16 Complete!** Your photo upload and display features are ready.

---

### Step 17: Notification Setup (Optional - for Step 19)

**Note:** This step is only needed if you choose push notifications in Step 19. For MVP, local notifications (Option 2 in Step 19) don't require this.

#### 17.1 Choose Notification Approach

- [ ] **Decision: Local vs Push Notifications**
  - **Local Notifications (Recommended for MVP):**
    - Simpler to implement
    - Works offline
    - No server setup needed
    - Less reliable (can be cleared by system)
  - **Push Notifications (For Production):**
    - More reliable
    - Requires server-side setup
    - Better for cross-device sync
    - More complex implementation

#### 17.2 Setup Local Notifications (Option 1 - Recommended for MVP)

- [ ] **Add flutter_local_notifications package:**
  - Add to `pubspec.yaml`:
    ```yaml
    flutter_local_notifications: ^16.0.0
    timezone: ^0.9.0  # For scheduling notifications
    ```
  - Run: `flutter pub get`

- [ ] **Create LocalNotificationService:**
  - Create: `lendy/lib/services/local_notification_service.dart`
  - Add:
    ```dart
    import 'package:flutter_local_notifications/flutter_local_notifications.dart';
    import 'package:timezone/timezone.dart' as tz;
    import 'package:timezone/data/latest.dart' as tz;

    class LocalNotificationService {
      static final LocalNotificationService _instance = LocalNotificationService._internal();
      factory LocalNotificationService() => _instance;
      LocalNotificationService._internal();

      final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
      bool _initialized = false;

      Future<void> initialize() async {
        if (_initialized) return;

        // Initialize timezone
        tz.initializeTimeZones();

        // Android initialization settings
        const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
        
        // iOS initialization settings
        const iosSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

        const initSettings = InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        );

        await _notifications.initialize(
          initSettings,
          onDidReceiveNotificationResponse: _onNotificationTapped,
        );

        // Request permissions
        await _requestPermissions();

        _initialized = true;
      }

      Future<void> _requestPermissions() async {
        // Android 13+ requires permission
        await _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      void _onNotificationTapped(NotificationResponse response) {
        // Handle notification tap
        // You can navigate to specific screen based on payload
      }

      Future<void> scheduleReminder({
        required int id,
        required String title,
        required String body,
        required DateTime scheduledDate,
        String? payload,
      }) async {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminders',
              'Item Reminders',
              channelDescription: 'Notifications for item reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      }

      Future<void> cancelReminder(int id) async {
        await _notifications.cancel(id);
      }

      Future<void> cancelAllReminders() async {
        await _notifications.cancelAll();
      }
    }
    ```

#### 17.3 Setup Push Notifications (Option 2 - For Production)

- [ ] **Add Firebase Cloud Messaging (if using Firebase):**
  - This requires Firebase setup (which we replaced with Supabase)
  - Consider using OneSignal or similar service instead

- [ ] **Alternative: Use OneSignal:**
  - Add to `pubspec.yaml`:
    ```yaml
    onesignal_flutter: ^5.0.0
    ```
  - Create OneSignal account and get App ID
  - Initialize in `main.dart`:
    ```dart
    await OneSignal.shared.setAppId("YOUR_ONESIGNAL_APP_ID");
    ```

- [ ] **Create device_tokens table in Supabase:**
  - Go to Supabase Table Editor
  - Create table:
    ```sql
    CREATE TABLE device_tokens (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id uuid NOT NULL REFERENCES auth.users(id),
      device_token text NOT NULL,
      platform text NOT NULL, -- 'android' or 'ios'
      created_at timestamptz DEFAULT now(),
      updated_at timestamptz DEFAULT now(),
      UNIQUE(user_id, device_token)
    );
    ```

- [ ] **Create NotificationTokenService:**
  - Create: `lendy/lib/services/notification_token_service.dart`
  - Implement methods to:
    - Get device token from OneSignal/FCM
    - Store token in Supabase `device_tokens` table
    - Update token on app start
    - Handle token refresh

#### 17.4 Initialize Notifications in main.dart

- [ ] **For Local Notifications:**
  - In `main.dart`, after Supabase initialization:
    ```dart
    await LocalNotificationService().initialize();
    ```

- [ ] **For Push Notifications:**
  - Initialize OneSignal or FCM after Supabase initialization
  - Request permissions
  - Get and store device token

#### 17.5 Create Notification Provider (Riverpod)

- [ ] **Add notification service provider:**
  - In `auth_providers.dart` or new file:
    ```dart
    final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
      return LocalNotificationService();
    });
    ```

**✅ Step 17 Complete!** Your notification setup is ready (choose local or push based on your needs).

---

### Step 18: Reminder UI

#### 18.1 Add Reminder Date Picker to CreateItemScreen

- [ ] **The reminder picker is already added in Step 11:**
  - Check that you have the reminder date picker in `CreateItemScreen`
  - It should be similar to the due date picker

- [ ] **Enhance reminder picker with time selection:**
  - Update the reminder picker to include time:
    ```dart
    ListTile(
      title: const Text('Reminder (optional)'),
      subtitle: Text(
        _reminderAt != null 
            ? DateFormat('MMM d, y h:mm a').format(_reminderAt!) 
            : 'Not set',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_reminderAt != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _reminderAt = null;
                });
              },
            ),
          const Icon(Icons.notifications),
        ],
      ),
      onTap: () async {
        // Pick date first
        final date = await showDatePicker(
          context: context,
          initialDate: _reminderAt ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        
        if (date != null) {
          // Then pick time
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_reminderAt ?? DateTime.now()),
          );
          
          if (time != null) {
            setState(() {
              _reminderAt = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }
        }
      },
    ),
    ```

#### 18.2 Add Reminder Picker to ItemDetailScreen

- [ ] **Add reminder edit functionality:**
  - In `ItemDetailScreen`, add reminder section in `_buildItemDetails`:
    ```dart
    // Reminder section (editable)
    const Divider(height: 32),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              item.reminderAt != null
                  ? DateFormat('MMM d, y h:mm a').format(item.reminderAt!)
                  : 'Not set',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        Row(
          children: [
            if (item.reminderAt != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _handleRemoveReminder(item.id),
                tooltip: 'Remove reminder',
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _handleSetReminder(item.id, item.reminderAt),
              tooltip: 'Set reminder',
            ),
          ],
        ),
      ],
    ),
    ```

- [ ] **Implement _handleSetReminder method:**
  - Add:
    ```dart
    Future<void> _handleSetReminder(String itemId, DateTime? currentReminder) async {
      // Pick date
      final date = await showDatePicker(
        context: context,
        initialDate: currentReminder ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      
      if (date == null) return;
      
      // Pick time
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentReminder ?? DateTime.now()),
      );
      
      if (time == null) return;
      
      final reminderAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        await repository.updateItem(
          userId: user.id,
          itemId: itemId,
          updates: {
            'reminder_at': reminderAt.toIso8601String(),
          },
        );

        // Schedule local notification
        final notificationService = ref.read(localNotificationServiceProvider);
        await notificationService.scheduleReminder(
          id: itemId.hashCode, // Use item ID hash as notification ID
          title: 'Item Reminder',
          body: 'Don\'t forget: ${item.title}',
          scheduledDate: reminderAt,
          payload: itemId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder set!')),
          );
          ref.invalidate(itemDetailProvider(itemId));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    ```

- [ ] **Implement _handleRemoveReminder method:**
  - Add:
    ```dart
    Future<void> _handleRemoveReminder(String itemId) async {
      try {
        final authState = ref.read(authStateProvider);
        final user = authState.value;
        
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final repository = ref.read(itemRepositoryProvider);
        await repository.updateItem(
          userId: user.id,
          itemId: itemId,
          updates: {
            'reminder_at': null,
          },
        );

        // Cancel local notification
        final notificationService = ref.read(localNotificationServiceProvider);
        await notificationService.cancelReminder(itemId.hashCode);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reminder removed')),
          );
          ref.invalidate(itemDetailProvider(itemId));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    ```

#### 18.3 Schedule Notifications When Creating Items

- [ ] **Update CreateItemScreen _handleSave:**
  - After creating item, if reminder is set, schedule notification:
    ```dart
    // After item is created and photos uploaded
    if (_reminderAt != null) {
      final notificationService = ref.read(localNotificationServiceProvider);
      await notificationService.scheduleReminder(
        id: createdItem.id.hashCode,
        title: 'Item Reminder',
        body: 'Don\'t forget: ${createdItem.title}',
        scheduledDate: _reminderAt!,
        payload: createdItem.id,
      );
    }
    ```

#### 18.4 Display Reminder Info in ItemCard

- [ ] **Update ItemCard to show reminder:**
  - In `item_card.dart`, add reminder indicator:
    ```dart
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text('Borrower: ${item.borrowerName}'),
        const SizedBox(height: 4),
        Text(
          'Lent: ${DateFormat('MMM d, y').format(item.lentAt)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        if (item.dueAt != null) ...[
          const SizedBox(height: 4),
          Text(
            'Due: ${DateFormat('MMM d, y').format(item.dueAt!)}',
            style: TextStyle(
              color: _isOverdue(item.dueAt!) ? Colors.red : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (item.reminderAt != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.notifications_active, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                'Reminder: ${DateFormat('MMM d, h:mm a').format(item.reminderAt!)}',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ],
    ),
    ```

#### 18.5 Add Reminder Badge to List

- [ ] **Add visual indicator for items with reminders:**
  - In ItemCard, add badge:
    ```dart
    ListTile(
      // ... existing properties
      leading: Stack(
        children: [
          // Existing leading widget (icon or image)
          if (item.reminderAt != null)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      // ... rest of ListTile
    ),
    ```

**✅ Step 18 Complete!** Your reminder UI is ready with date/time pickers and notification scheduling.

---

### Step 19: Reminder Notifications

**Option 1: Supabase Edge Functions (Recommended for production):**
- [ ] Set up Supabase Edge Functions:
  - Install Supabase CLI: `npm install -g supabase`
  - Login: `supabase login`
  - Link project: `supabase link --project-ref YOUR_PROJECT_REF`
- [ ] Create scheduled function:
  - Create Edge Function that runs on a schedule (using pg_cron or external scheduler)
  - Queries `items` table where `reminder_at <= now()` and `status = 'lent'` and `reminder_sent_at IS NULL`
  - Sends notifications (via email, push, or in-app)
  - Updates `reminder_sent_at` on item to avoid duplicates
- [ ] Deploy function: `supabase functions deploy reminder-scheduler`

**Option 2: Local Notifications (Simpler for MVP):**
- [ ] Add `flutter_local_notifications` package:
  - Add to `pubspec.yaml`: `flutter_local_notifications: ^16.0.0`
  - Run: `flutter pub get`
- [ ] Create notification service:
  - Schedule local notifications when item is created/updated with `reminder_at`
  - Use `flutter_local_notifications` to schedule notifications
  - Check for due reminders on app startup
- [ ] **Note:** Local notifications work even when app is closed (on Android)
- [ ] **Limitation:** Less reliable than server-side, but simpler for MVP

**Option 3: Background Task (Alternative):**
- [ ] Use `workmanager` package for background tasks
- [ ] Schedule periodic checks for reminders
- [ ] Send local notifications when reminders are due

---

### Step 20: Testing & Polish
- [ ] Test on iOS physical device
- [ ] Test on Android physical device
- [ ] Test notification delivery
- [ ] Test offline behavior (Supabase has built-in offline support with Realtime)
- [ ] Fix any bugs
- [ ] Add error handling throughout
- [ ] Add loading indicators
- [ ] Polish UI/UX

---

## 📊 Data Model Reference

### Supabase Tables

#### `auth.users` (Managed by Supabase)
```
- id (uuid, primary key) - automatically managed
- email (text)
- created_at (timestamptz)
- ... other auth fields managed by Supabase
```

#### `items` table
```sql
CREATE TABLE items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id),
  title text NOT NULL,
  description text,
  borrower_name text NOT NULL,
  borrower_contact text,
  lent_at timestamptz DEFAULT now(),
  due_at timestamptz,
  reminder_at timestamptz,
  status text NOT NULL DEFAULT 'lent' CHECK (status IN ('lent', 'returned')),
  returned_at timestamptz,
  photo_urls text[],
  reminder_sent_at timestamptz,  -- for reminder notifications
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE items ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only access their own items
CREATE POLICY "Users can manage their own items"
  ON items FOR ALL
  USING (auth.uid() = user_id);
```

#### Storage: `item-photos` bucket
```
- Path structure: {user_id}/{item_id}/{filename}
- Public bucket for easy URL access
- RLS policies ensure users can only access their own photos
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
