# To-Do App

A simple and elegant Flutter to-do list app with task categorization, progress tracking, and a smooth UI.  
Built using **Flutter**, **Provider** for state management, and **Firebase** for authentication & persistence.

---

## Project Link

[GitHub Repository](https://github.com/Sujin14/todo_app.git)

---

## Features

- Create, edit, delete tasks  
- Categorize tasks into **To-do**, **Pending**, **Completed**  
- Search & filter tasks  
- Visual progress indicator (completion progress)  
- Display Lottie animation when there are no tasks    
- Firebase Auth (Email/Password)  
- Firestore as the backend database  

---

## Tech Stack

| Component        | Technology / Package                               |
|------------------|----------------------------------------------------|
| Framework        | Flutter                                            |
| State Management | Provider                                           |
| Backend          | Firebase Authentication & Cloud Firestore          |
| UI Enhancements  | Lottie, Shimmer                                    |

---

## Project Structure

```text
todo_app/
├── android/
├── ios/
├── assets/
│   └── animations/         # Lottie animations (e.g. no_data.json)
├── lib/
│   ├── models/             # Data models (e.g. Task)
│   ├── services/           # Communication with Firebase etc.
│   ├── view/               # Screens (UI pages)
│   ├── viewmodels/         # Business logic, state
│   ├── widgets/            # Reusable widgets
│   ├── utils/              # Helper functions / validators etc.
│   └── main.dart           # App entry point
├── pubspec.yaml            # Dependencies, asset declarations
└── README.md               
