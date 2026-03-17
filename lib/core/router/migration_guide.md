# Navigation Migration Guide

## Current State
- Existing `AppRouter.generateRoute` system is active
- All `Navigator.push` calls work unchanged
- GoRouter system is ready but not activated

## Safe Migration Steps

### 1. Test GoRouter System
Uncomment in `main.dart`:
```dart
routerConfig: AppGoRouter.router,
```
Comment out:
```dart
initialRoute: '/login',
onGenerateRoute: AppRouter.generateRoute,
```

### 2. Replace Navigator.push Calls Gradually

#### Before (Current):
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
);
```

#### After (GoRouter):
```dart
context.pushNamed('editProfile');
// OR using helper:
NavigationHelper.navigateTo(context, 'editProfile');
```

### 3. Route Arguments Migration

#### Before:
```dart
Navigator.pushNamed(context, AppRouter.checkout, arguments: {
  "day": 'Monday', 
  "date": date, 
  "time": time
});
```

#### After:
```dart
context.pushNamed('checkout', extra: {
  "day": 'Monday', 
  "date": date, 
  "time": time
});
```

### 4. Query Parameters for Simple Data

#### Before:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => OtpScreen(phone: phone)),
);
```

#### After:
```dart
context.pushNamed('otp', queryParameters: {'phone': phone});
```

## Safety Features

### NavigationHelper Class
- Provides fallback to existing navigation if GoRouter fails
- Context mounting checks prevent crashes
- Route existence validation

### Extension Methods
```dart
// Safe navigation with automatic fallback
context.safeNavigate('editProfile');

// Clear stack navigation
context.navigateAndClearStack('/home');
```

## Migration Priority

1. **High Priority**: Profile navigation (simple, no arguments)
2. **Medium Priority**: Booking flow (has arguments)
3. **Low Priority**: Complex navigation with multiple parameters

## Testing Checklist

- [ ] All existing routes work unchanged
- [ ] Deep linking works
- [ ] Browser navigation works
- [ ] Route arguments preserved
- [ ] Error handling works

## Rollback Plan

If issues occur, simply revert main.dart changes:
```dart
// Rollback to this:
initialRoute: '/login',
onGenerateRoute: AppRouter.generateRoute,
```
