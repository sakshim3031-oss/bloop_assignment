# Bloop Assignment 

This project is developed as part of the assignment submission.  
It demonstrates Flutter development skills including data modeling, caching, state management, and debugging.

---

## Flutter & Dart Version

- Flutter: 3.x
- Dart: >=3.0.0 <4.0.0

---

##  How to Run the Project

1. Clone the repository:
   git clone https://github.com/sakshim3031-oss/bloop_assignment.git
   cd bloop_assignment

2. Install dependencies:
   flutter pub get

3. Run the app:
   flutter run

---

## Task 1 — Data Modeling & Caching

- Created a `Collection` model for handling data
- Implemented local caching using Hive
- Used Riverpod (AsyncNotifier) for state management

### Implemented Flow:
- Load cached data first
- Fetch fresh data in background
- Pull-to-refresh support

---

## Task 2 — Debug & Fix

- Fixed incorrect Hive directory usage
- Added null safety in cache to prevent crashes
- Avoided performance issues caused by repeated Future creation
- Handled safe data modification approach for Firestore

---

## Technical Decisions

- Used mock data instead of Firestore for simplicity
- Followed clean architecture (models, provider, services, UI)
- Focused on stability and performance

---

## Project Structure

lib/
├── models/
├── provider/
├── services/
├── ui/
└── main.dart

---

## Author

Sakshi Mishra