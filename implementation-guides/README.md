# Implementation Guides

This directory contains detailed implementation guides for each feature, bug fix, and improvement listed in `todo.md`.

## File Naming Convention

Files are named using the pattern: `{category}.{number}-{feature-name}.md`

Examples:
- `1.1-edit-item-feature.md` - Feature 1.1: Edit Item Feature
- `2.3-photo-upload-errors-not-properly-handled.md` - Bug Fix 2.3
- `3.7-add-haptic-feedback.md` - UI/UX Improvement 3.7

## File Structure

Each implementation guide includes:

1. **Header Information**
   - Priority
   - Category
   - Status (Implemented/Not Implemented/Not Planned)
   - Difficulty (1-10 stars)
   - Modification Location

2. **Description**
   - Brief overview of what the feature does

3. **Implementation Details**
   - Step-by-step technical details
   - Specific requirements and considerations

4. **Files to Modify/Create**
   - List of files that need to be created or modified
   - Specific notes about what changes are needed

5. **Dependencies**
   - External packages or services required
   - Database migrations needed

6. **Implementation Steps**
   - High-level steps to implement the feature
   - Order of operations

## Categories

- **1.x** - New Functionality
- **2.x** - Bug Fixes
- **3.x** - UI/UX Improvements
- **4.x** - Performance & Technical Improvements
- **5.x** - Security & Privacy Improvements
- **6.x** - Accessibility Improvements

## Usage

When implementing a feature:

1. Read the corresponding implementation guide
2. Review the implementation details and steps
3. Check dependencies and add them to `pubspec.yaml` if needed
4. Follow the implementation steps
5. Update `todo.md` when the feature is complete

## Status Legend

- ✅ **Implemented** - Feature is fully implemented
- ❌ **Not Implemented** - Feature is planned but not yet implemented
- 🚫 **Not Planned** - Feature is not planned for implementation

## Modification Location Legend

- **Flutter Code** - Only Flutter/Dart code changes required
- **Flutter Code + Supabase** - Code changes + database schema modifications
- **Flutter Code + Config** - Code changes + configuration files
- **Flutter Code + External** - Code changes + external packages/services
- **Flutter Code + Supabase + External** - All of the above
