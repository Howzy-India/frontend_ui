# Howzy Flutter Conversion

This folder contains a Flutter conversion of the React app in this repository.

## Implemented Flow

- Splash screen
- Login screen with Firebase email/password auth
- Greetings screen
- Role-based dashboards:
	- Agent dashboard with tabbed data views
	- Admin summary dashboard
	- Super Admin dashboard with tabbed management views

## Firebase Foundation Added

- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions`
- Role resolution from custom claims (`super_admin`, `admin`, `agent`) with Firestore fallback (`users/{uid}`)
- Builder workflow services (draft, update, agreement upload, submit/approve/reject)
- User management callable service scaffold for super admin

## Configure Firebase

From repository root:

```bash
flutterfire configure --project <your-project-id> --out flutter_app/lib/firebase/firebase_options.dart
firebase deploy --only functions,firestore:rules,storage
```

If you use GitHub Actions deploy, add secrets:

- `FIREBASE_TOKEN`
- `FIREBASE_PROJECT_ID`

The app uses Flutter mock data modeled from `src/data/mockData.ts` in the React project.

## Run

From this folder:

```bash
flutter pub get
flutter run -d chrome
```

Or run on macOS desktop:

```bash
flutter run -d macos
```

## Validation

```bash
flutter analyze
flutter test
```
