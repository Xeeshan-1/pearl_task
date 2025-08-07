# Flutter Items List App

A Flutter application that displays a list of items with favorite functionality and search capabilities.

## Version Information

- Flutter Version: 3.32.3

## Features

- Display a list of items from a mock API
- Toggle favorite state for items (persisted locally)
- Search items by title
- Display time since item was added
- Color-coded tags (New, Hot, Old)
- Favorite items counter in the app bar
- Material 3 design
- Skeleton loading animation

## Technical Decisions

### State Management: BLoC with Single State

I chose to use BLoC (Business Logic Component) pattern with a single state approach for the following reasons:

1. **Separation of Concerns**
   - Clear separation between UI, business logic, and data layers
   - Easy to test each component independently
   - Better code organization and maintainability

2. **Single State Approach**
   - Predictable state updates
   - Easier to debug and track state changes
   - Reduced complexity in state management
   - Efficient rebuilds with Equatable

3. **Reactive Programming**
   - Built-in support for streams and reactive programming
   - Efficient handling of async operations
   - Easy to implement real-time features

### Local Storage: SharedPreferences

Used SharedPreferences for storing favorite items because:
- Lightweight and easy to implement
- Perfect for small key-value data
- Fast access and persistence
- Built into Flutter

### Mock API Service

Created a mock API service that:
- Simulates network delay
- Generates random data with realistic variations
- Easy to replace with real API implementation later

### UI Optimization

1. **List Optimization**
   - Using ListView.builder for efficient item rendering
   - Only rebuilding necessary widgets with BlocBuilder
   - Proper use of const constructors

2. **Search Implementation**
   - Real-time search with debouncing
   - Efficient filtering using state computed properties
   - Case-insensitive search

3. **Loading State**
   - Skeleton loading animation using Skeletonizer
   - Smooth transitions between states
   - Maintains layout consistency during loading

## Project Structure

```
lib/
├── bloc/
│   ├── items_bloc.dart
│   ├── items_event.dart
│   └── items_state.dart
├── models/
│   └── item.dart
├── services/
│   ├── mock_api_service.dart
│   └── storage_service.dart
├── widgets/
│   └── item_tile.dart
└── main.dart
```

## Dependencies

- flutter_bloc: ^8.1.3 - State management
- equatable: ^2.0.5 - Value equality
- shared_preferences: ^2.5.3 - Local storage
- timeago: ^3.6.0 - Relative time formatting
- dio: ^5.4.0 - HTTP client
- skeletonizer: ^2.1.0+1 - Loading animations

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## Development Environment

### Android Setup
- Minimum SDK Version: 21
- Target SDK Version: 34

### Flutter Setup
- Flutter Version: 3.32.3
- Channel: stable