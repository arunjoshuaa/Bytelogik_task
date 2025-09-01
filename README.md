# ByteLogik Task

A Flutter project for demonstrating authentication and user management using **SQLite** as the local database.

## Features

- User Registration (sign up with name, email, password, etc.)
- User Login (with SQLite validation)
- Session Management (remembers the logged-in user even after closing the app)
- Logout functionality
- Local persistence using SQLite(mobile) and Hive(web)
- Simple and clean project structure

## Requirements

- Flutter SDK (>=3.0.0 recommended)
- Dart (>=3.0.0 recommended)
- Android Studio / VS Code
- Emulator or physical of web device for testing

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

## Screenshots
1. Login page
   ![Image Alt](https://github.com/arunjoshuaa/Bytelogik_task/blob/26be485ecfb9ec5c2d88f9c306bad13cd50152a5/loginbytelogik.jpg)
2. Register page
   ![Image Alt](https://github.com/arunjoshuaa/Bytelogik_task/blob/99c0c058f01a0ac79d0176c9b071f3a9564fcdf7/registrebytlogic.jpg)
3. Counter page
   ![Image Alt](https://github.com/arunjoshuaa/Bytelogik_task/blob/46647e1e27f88a781b1905af1e356b7db21cf467/home_bytelogic.jpg)
