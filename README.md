# healthcare

A new Flutter project.


hello world

## API keys

The app calls Geoapify (clinics), USDA FoodData Central (food search) and RapidAPI
(health news). The keys are not stored in the code. Copy `env.example.json` to `env.json`,
fill in your keys, and run with:

```
flutter run --dart-define-from-file=env.json
```

In Android Studio, add it to the run configuration instead: Run > Edit Configurations,
select `main.dart`, and put `--dart-define-from-file=env.json` in **Additional run args**.

`env.json` is in `.gitignore`, so it stays on your machine.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
