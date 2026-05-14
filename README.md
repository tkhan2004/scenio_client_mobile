# Scenio Mobile

Flutter client for Scenio.

## Current status

- `lib/app/core/constants` and `lib/app/core/theme` are implemented and define the current visual system.
- `main.dart` currently boots a themed `GetMaterialApp`, but route wiring is still scaffold-level.
- `lib/app/modules`, `lib/app/core/network`, and `lib/app/domain/entities` contain placeholder files for the planned MVVM + GetX structure.

## Related project docs

- Root overview: [`../OVERVIEW.md`](../OVERVIEW.md)
- Architecture: [`../SCENIO_ARCHITECTURE.md`](../SCENIO_ARCHITECTURE.md)
- System design: [`../SYSTEM_DESIGN.md`](../SYSTEM_DESIGN.md)

## Run locally

```bash
flutter pub get
flutter run
```

The app is not feature-complete yet, so expect scaffold behavior rather than the full product flow described in the project documents.

## Google Sign-In setup

Scenio keeps the real auth/session flow in the backend. Firebase is only used as the easiest
way to obtain the correct Google Sign-In credentials for iOS.

### Flow

1. User taps Google Sign-In in mobile.
2. Mobile receives a Google `idToken`.
3. Mobile sends that token to backend `POST /api/auth/google`.
4. Backend verifies the token and then creates or updates the user in Scenio database.
5. Backend returns Scenio `accessToken` and `refreshToken` like normal auth.

### What to configure

Fill [`.env`](./.env) with:

```env
SCENIO_GOOGLE_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
SCENIO_GOOGLE_SERVER_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

Fill [`ios/Flutter/GoogleSignIn.xcconfig`](./ios/Flutter/GoogleSignIn.xcconfig) with:

```xcconfig
SCENIO_IOS_GOOGLE_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
SCENIO_IOS_GOOGLE_SERVER_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
SCENIO_IOS_GOOGLE_REVERSED_CLIENT_ID=com.googleusercontent.apps.your-ios-client-id
```

### Credential mapping

- `SCENIO_GOOGLE_CLIENT_ID`: iOS OAuth client ID
- `SCENIO_GOOGLE_SERVER_CLIENT_ID`: Web OAuth client ID
- `scenio_be/.env -> GOOGLE_CLIENT_ID`: the same Web OAuth client ID above

### Recommended setup path

1. Create or open a Firebase project.
2. Add the iOS app using the current bundle id:
   `com.example.scenioClientMobile`
3. Enable Google Sign-In.
4. Download `GoogleService-Info.plist`.
5. Copy these values from that file:
   - `CLIENT_ID` -> iOS client ID
   - `REVERSED_CLIENT_ID` -> iOS reversed client ID
6. In Google Cloud / Firebase Auth, also create or locate the Web client ID.
7. Put the Web client ID into both:
   - mobile `.env`
   - backend `GOOGLE_CLIENT_ID`
