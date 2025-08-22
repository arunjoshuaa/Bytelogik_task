# ByteLogik Task

A Flutter project for demonstrating authentication and user management using **SQLite** as the local database.

## Features

- User Registration (sign up with name, email, password, etc.)
- User Login (with SQLite validation)
- Session Management (remembers the logged-in user even after closing the app)
- Logout functionality
- Local persistence using SQLite
- Simple and clean project structure

## Requirements

- Flutter SDK (>=3.0.0 recommended)
- Dart (>=3.0.0 recommended)
- Android Studio / VS Code
- Emulator or physical device for testing

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/bytelogik_task.git
   cd bytelogik_task
2. Install dependencies:

flutter pub get


3. Run the app:

flutter run

Database

SQLite is used for storing:

Users (id, name, email, password, etc.)

Current logged-in user (to manage sessions)
