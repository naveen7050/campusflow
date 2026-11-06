# CampusFlow 🎓

> **Organize • Study • Share**  
> *Your college life, all in one place.*

CampusFlow is a full-stack academic companion mobile application designed for students and faculty. It centralizes course subjects, revision notes, question banks, assignments, and study materials into a clean, unified platform.

---

## 🎨 Design System & Color Palette

CampusFlow follows a modern, card-based interface crafted for mobile, tablet, and desktop screens:

| Role | Color Name | Hex Code | Visual Preview |
| :--- | :--- | :--- | :--- |
| **Primary Brand** | Forest Green | `#0F5132` | 🟩 |
| **Secondary Accent** | Emerald Green | `#2E7D32` | 🟢 |
| **Subtle Tint / Chips** | Light Sage | `#EBF5E9` | 🩵 |
| **Primary Text** | Dark Slate | `#1F2937` | ⬛ |
| **Secondary Text** | Neutral Grey | `#6B7280` | ◽ |
| **Card / Surface** | Pure White & Off-White | `#FFFFFF` / `#F1F5F9` | ⬜ |

---

## ✨ Key Features

- **🔐 Secure Authentication**
  - Registration with Student ID, Department, and Semester selection.
  - JWT token-based authentication with encrypted on-device storage.
  - Automatic session restore with route protection gates.

- **📚 Subject Management**
  - Semester-based subject filtering (`Sem 1` to `Sem 8`).
  - Custom color-coded subject cards with dedicated academic icons.
  - Instant search across subject names, codes, and departments.
  - Adaptive interface: list view on phones, responsive grid on tablets/desktops.

- **📝 Notes & Materials Repository**
  - Subject-linked revision notes with search and tags.
  - Study materials repository tracking file formats (PDF, DOCX) and file sizes.
  - Shared vs. private filters (`All`, `My Notes / Files`, `Shared`).

- **❓ Question Bank & Assignments**
  - Practice question collection organized by subject category.
  - Assignment tracking with deadlines and submission statuses.

- **📊 Home Academic Dashboard**
  - Personalized dynamic greetings and quick profile chip.
  - Real-time counters for questions, notes, and study materials.
  - Fast-access "Recent Activity" cards.
  - 5-tab docked bottom navigation bar (`Home`, `Explore`, `+ Create`, `Shared`, `Profile`).

---

## 🏗️ Architecture & Technology Stack

```text
campusflow/
├── backend/            # Express.js REST API & PostgreSQL database
│   ├── migrations/     # Versioned SQL migration files
│   ├── src/
│   │   ├── config/     # Database pool & environment variables
│   │   ├── controllers/# Business logic & request handlers
│   │   ├── middleware/ # JWT authentication verification
│   │   ├── models/     # Database queries & SQL interactions
│   │   ├── routes/     # Express route definitions
│   │   └── server.js   # Application entry point
│   └── tests/
│
├── mobile/             # Flutter Mobile Application
│   ├── lib/
│   │   ├── app/        # Theme, routes, and global constants
│   │   ├── core/       # Networking (ApiClient) and secure storage
│   │   └── features/   # Feature-based clean architecture
│   │       ├── auth/   # Login, Register, Splash, Onboarding
│   │       ├── home/   # Dashboard & bottom navigation
│   │       ├── subjects/# Subject model, repository, viewmodel, views
│   │       ├── notes/  # Notes model & repository
│   │       └── materials/# Material model & repository
│
└── docs/               # Architecture diagrams, SRS, and API documentation
    └── api/            # Complete REST API documentation
```

### Tech Stack
- **Frontend**: Flutter (Dart 3.x), Provider state management, Flutter Secure Storage
- **Backend**: Node.js, Express.js, PostgreSQL (`pg` connection pool), JWT, Bcrypt
- **API Spec**: RESTful JSON architecture

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24+ recommended)
- [Node.js](https://nodejs.org/) (v18+ recommended)
- [PostgreSQL](https://www.postgresql.org/) (running on port `5432`)

---

### 1. Backend Setup

1. Open your terminal and navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables in `.env`:
   ```env
   PORT=5000
   NODE_ENV=development

   DB_HOST=localhost
   DB_PORT=5432
   DB_USER=postgres
   DB_PASSWORD=your_postgres_password
   DB_NAME=campusflow_db

   JWT_SECRET=campusflow_super_secret_jwt_key_2026
   JWT_EXPIRES_IN=7d
   ```

4. Run the database migrations:
   ```bash
   node src/scripts/migrate.js
   ```

5. Start the backend development server:
   ```bash
   npm run dev
   ```
   The API will listen on `http://localhost:5000`.

---

### 2. Mobile App Setup

1. Open a new terminal and navigate to the mobile folder:
   ```bash
   cd mobile
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

> **Note for Android Testing**:
> - **Emulator**: Connects automatically to `http://10.0.2.2:5000/api`.
> - **Physical Android Phone (USB)**: Forward port 5000 using ADB:
>   ```bash
>   adb reverse tcp:5000 tcp:5000
>   ```

---

## 📖 API Documentation

Detailed documentation for all authentication, subject, note, and material endpoints is located at:
- [docs/api/api.md](docs/api/api.md)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
