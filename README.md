q1
# 🌌 Celestial Explorer - Astronomy Learning App

Celestial Explorer is an interactive learning application that teaches users about astronomy through visuals, quizzes, and AR-based sky scanning. Built using Flutter and Firebase, the app integrates real-time data from NASA APIs, educational YouTube videos, and Unity AR to provide an engaging experience.

---

## 🚀 Features

- 📖 **Structured Learning Topics** – Solar System, Galaxies, Black Holes, Space Missions, and more.
- 🧠 **Quiz Module** – Topic-based quizzes with instant feedback and Firestore result tracking.
- 🪐 **APOD and NASA Image Gallery** – Fetches latest Astronomy Picture of the Day and Mars Rover photos.
- 🎥 **YouTube Video Integration** – Educational space videos directly inside the app.
- 🌠 **Sky Map** – A digital sky view map which gives insightful space experience.
- 🌠 **AR Sky Scanner** – Point your camera to the night sky to view constellation overlays (Unity AR).
- 👤 **User Profiles** – Tracks user progress, quiz scores, and learning summaries.
- 🔐 **Firebase Authentication** – Secure login and profile setup with image upload.

---

## 🛠 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Authentication, Firestore, Storage)
- **APIs Used:** NASA APIs, YouTube Data API
- **AR Engine:** Unity with AR Foundation
- **IDE:** Visual Studio Code + Unity Hub

---

## 🧑‍🏫 How to Use

### 1. **Install Dependencies**

Ensure you have:

- Flutter SDK
- Firebase CLI
- Unity with AR Foundation
- Visual Studio Code
- An Android or iOS device/emulator

- open the code on the VS code and the run the application on a android studio emulator or a physical device using ' flutter run ' .

### 2. **Firebase Configuration**

- Create a Firebase project
- Enable Email/Password Authentication
- Set up Firestore with a `quiz_questions` collection
- Enable Firebase Storage for profile pictures
- Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) to the project

### 3. **Running the App**

```bash
flutter run
```

You can also use Android Studio or VS Code to launch the app on a simulator or device.


## 📂 Firestore Data Structure

### `quiz_questions`

```json
{
  "question": "What planet is known as the Red Planet?",
  "options": ["Earth", "Mars", "Jupiter", "Venus"],
  "correctAnswerIndex": 1,
  "topic": "Solar System",
  "explanation": "Mars is called the Red Planet due to its reddish appearance.",
  "imageUrl": "https://example.com/image.jpg"
}
```

### `user_progress`

```json
{
  "userId": "UID123",
  "Solar System": {
    "completed": true,
    "score": 8,
    "lastAccessed": "2025-05-25"
  }
}
```

---

## 🧪 Testing

- All pages tested on Android emulator and real devices
- Real-time API response handled with error boundaries
- Unity AR tested on physical Android device

---

## 🌍 Future Improvements

- Offline mode with downloadable content
- Multilingual support
- Voice narration for learning topics
- Telescope integration



