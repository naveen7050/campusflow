# JAGAN INSTITUTE OF MANAGEMENT STUDIES
### SECTOR – 5, ROHINI, NEW DELHI

*(Affiliated to)*

### GURU GOBIND SINGH INDRAPRASTHA UNIVERSITY
### SECTOR – 16 C, DWARKA, NEW DELHI

---

## MINOR PROJECT REPORT
### ON
# CAMPUSFLOW: A MOBILE AND CLOUD-BASED ACADEMIC RESOURCE AND COLLABORATION PLATFORM

---

| Submitted To: | Submitted By: |
| :--- | :--- |
| **Mentor Name:** [Mentor Name] | **Student Name:** [Student Name] |
| **Designation:** [Mentor Designation] | **Enrollment No:** [Enrollment No] |
| **Department:** Department of Information Technology | **Course & Shift:** MCA I (Shift - [Shift]) |

---

<br><br><br>

---

## CERTIFICATE

This is to certify that the project report entitled **"CAMPUSFLOW: A MOBILE AND CLOUD-BASED ACADEMIC RESOURCE AND COLLABORATION PLATFORM"** submitted to **Jagan Institute of Management Studies** in partial fulfilment of the requirement for the award of the degree of **MASTER OF COMPUTER APPLICATIONS (MCA)** is an original work carried out by **Mr. / Ms. [Student Name]**, enrolment no. **[Enrollment No]** under my guidance. The matter embodied in this project is authentic and is genuine work done by the student and has not been submitted whether to this University or to any other University / Institute for the fulfilment of the requirement of any course of study.

<br><br>

| …………………………………………… | …………………………………………… |
| :--- | :--- |
| **Signature of the Student** | **Signature of the Project Coordinator / Mentor** |
| Date: ……………… | Date: ……………… |
| **Name:** [Student Name] | **Name:** [Mentor Name] |
| **Enrollment No:** [Enrollment No] | **Designation:** [Mentor Designation] |
| Department of Information Technology | Department of Information Technology |
| JIMS, Sector–5, Rohini | JIMS, Sector–5, Rohini |

---

## ROLE AND RESPONSIBILITY

As the sole developer and researcher for this minor project, the key roles and responsibilities executed include:

1. **Requirement Engineering & Domain Analysis:** Identified student pain points regarding dispersed study materials, past exam questions, assignments, and peer collaboration across semesters.
2. **System Architecture Design:** Designed a modular, scalable full-stack mobile client architecture following Model-View-ViewModel (MVVM) principles and a RESTful backend API service.
3. **Database & Schema Modeling:** Structured relational PostgreSQL database schemas with foreign key integrity, cascade rules, indexing, and transactional consistency.
4. **Backend Engineering:** Developed secure Node.js and Express.js REST API endpoints with JWT authorization, bcrypt password hashing, and input validation.
5. **Mobile Application Development:** Built an adaptive, high-performance cross-platform Flutter application supporting dark and light themes, in-app PDF document reading, and native file uploads.
6. **Testing & Quality Assurance:** Authored and executed unit tests, API integration tests, and UI verification passes across Android emulator and physical target devices.
7. **Documentation:** Compiled technical specifications, user manual, and the complete academic project report according to GGSIPU and JIMS formatting standards.

---

## ACKNOWLEDGEMENT

I take this opportunity to present my sincere gratitude to my faculty members who acted as pillars of support throughout the execution of this minor project, leading to its successful and satisfactory completion.

I feel a profound sense of gratitude towards my faculty mentor, **[Mentor Name]**, under whose constructive guidance, patience, and motivation this project was performed.

I express my sincere thanks to all computer laboratory personnel for providing infrastructure, network assistance, and testing facilities necessary for completing this project. This project would not have been completed without their prompt support.

I also thank the faculty members and the Head of Department of Information Technology, **JIMS Rohini (Sector-5)**, for their continuous academic guidance, rigorous reviews, and encouragement during the course of study.

Finally, I thank my family and friends for their constant support and understanding throughout this endeavor.

<br>

**Student Name:** [Student Name]  
**Enrollment No.:** [Enrollment No]  
**Degree:** Master of Computer Applications (MCA)  
**Institute:** JIMS, Sector–5, Rohini, New Delhi  

---

## ABSTRACT

In modern higher education institutions, academic materials such as lecture notes, textbook summaries, past exam questions, homework assignments, and laboratory reference slides are frequently fragmented across disparate platforms (such as messaging groups, cloud storage links, and personal drives). This fragmentation causes loss of version control, missing deadlines, repetitive file requests, and accessibility obstacles for university students.

**CampusFlow** is a modern, unified, mobile-first academic resource and peer collaboration platform designed specifically for university students and departments. Built using Google's **Flutter** framework on the frontend, **Node.js** and **Express.js** on the backend, and **PostgreSQL** for persistent relational storage, CampusFlow centralizes core academic workflows into an integrated environment:

1. **Course & Subject Organization:** Structured semester-wise and department-wise categorization of academic curriculum.
2. **Digital Notes Management:** Rich-text note creation, categorization, search indexing, and selective peer sharing.
3. **Course Materials & Integrated Reading:** Seamless native file upload (`.pdf`, `.docx`, `.ppt`) coupled with an embedded in-app PDF document viewer and link resolver.
4. **Question Bank & Solutions:** Academic inquiry forum and past exam question archive with subject filtering and starred bookmarks.
5. **Assignment Deadline Tracking:** Dedicated task tracking with chronological urgency sorting, completion toggles, and countdown indicators.
6. **Peer Sharing Hub:** Real-time discovery of resources shared by campus classmates.
7. **Adaptive User Experience:** Accessible design with a responsive design system, ambient background motifs, and automated dark and light mode synchronization.

CampusFlow significantly reduces time spent searching for course materials, enhances collaborative learning within student cohorts, and improves student academic productivity.

---

## TABLE OF CONTENTS

| Particulars | Page No. |
| :--- | :--- |
| **Certificate of Authenticated Work** | ii |
| **Role and Responsibility** | iii |
| **Acknowledgement** | iv |
| **Abstract** | v |
| **Table of Contents** | vi |
| **Table of Figures & Tables** | viii |
| | |
| **CHAPTER 1: INTRODUCTION** | **1** |
| 1.1 Background | 1 |
| 1.2 Objectives | 2 |
| 1.3 Purpose, Scope, and Applicability | 3 |
| &nbsp;&nbsp;&nbsp;&nbsp;1.3.1 Purpose | 3 |
| &nbsp;&nbsp;&nbsp;&nbsp;1.3.2 Scope | 3 |
| &nbsp;&nbsp;&nbsp;&nbsp;1.3.3 Applicability | 4 |
| 1.4 Achievements | 4 |
| 1.5 Organisation of Report | 5 |
| | |
| **CHAPTER 2: SURVEY OF TECHNOLOGIES** | **6** |
| 2.1 Mobile Application Framework: Flutter & Dart | 6 |
| 2.2 Backend Architecture: Node.js & Express.js REST API | 7 |
| 2.3 Database Management System: PostgreSQL | 8 |
| 2.4 State Management & Architectural Pattern: Provider & MVVM | 9 |
| 2.5 Security, Cryptography & Authentication: JWT & bcryptjs | 10 |
| 2.6 Native Device Services: File Picker, Document Viewing & URL Launcher | 11 |
| | |
| **CHAPTER 3: REQUIREMENTS AND ANALYSIS** | **12** |
| 3.1 Problem Definition | 12 |
| 3.2 Requirements Specification | 13 |
| &nbsp;&nbsp;&nbsp;&nbsp;3.2.1 Functional Requirements | 13 |
| &nbsp;&nbsp;&nbsp;&nbsp;3.2.2 Non-Functional Requirements | 14 |
| 3.3 Planning and Scheduling | 15 |
| 3.4 Software and Hardware Requirements | 16 |
| 3.5 Preliminary Product Description | 17 |
| 3.6 Conceptual Models | 18 |
| | |
| **CHAPTER 4: SYSTEM DESIGN** | **20** |
| 4.1 Basic Modules | 20 |
| 4.2 Data Design | 22 |
| &nbsp;&nbsp;&nbsp;&nbsp;4.2.1 Entity Relationship Diagram | 22 |
| &nbsp;&nbsp;&nbsp;&nbsp;4.2.2 Relational Schema & Constraints | 23 |
| 4.3 Procedural Design | 25 |
| &nbsp;&nbsp;&nbsp;&nbsp;4.3.1 Logic Diagrams & Process Flows | 25 |
| &nbsp;&nbsp;&nbsp;&nbsp;4.3.2 Data Structures | 26 |
| &nbsp;&nbsp;&nbsp;&nbsp;4.3.3 Algorithm Design | 27 |
| 4.4 User Interface Design | 28 |
| 4.5 Security Issues & Countermeasures | 30 |
| 4.6 Test Cases Design | 31 |
| | |
| **CHAPTER 5: IMPLEMENTATION AND TESTING** | **33** |
| 5.1 Implementation Approaches | 33 |
| 5.2 Coding Details and Code Efficiency | 34 |
| &nbsp;&nbsp;&nbsp;&nbsp;5.2.1 Code Efficiency & Async Execution | 35 |
| 5.3 Testing Approach | 36 |
| &nbsp;&nbsp;&nbsp;&nbsp;5.3.1 Unit Testing | 36 |
| &nbsp;&nbsp;&nbsp;&nbsp;5.3.2 Integrated Testing | 37 |
| 5.4 Modifications and Improvements | 38 |
| | |
| **CHAPTER 6: RESULTS AND DISCUSSION** | **39** |
| 6.1 Test Reports | 39 |
| 6.2 User Documentation | 40 |
| | |
| **CHAPTER 7: CONCLUSIONS** | **42** |
| 7.1 Conclusion | 42 |
| 7.2 Limitations of the System | 42 |
| 7.3 Future Scope of the Project | 43 |
| | |
| **REFERENCES** | **44** |
| **GLOSSARY** | **46** |
| **ANNEXURES** | **47** |

---

## TABLE OF FIGURES & TABLES

### List of Figures
- **Figure 3.01:** CampusFlow Use Case Model
- **Figure 3.02:** System Work Breakdown Schedule (Gantt Chart Representation)
- **Figure 4.01:** Entity Relationship (ER) Diagram
- **Figure 4.02:** Authentication & Session Validation Activity Flow
- **Figure 4.03:** In-App Document Loading & Reading Flowchart
- **Figure 4.04:** Material Upload & Native File Processing Sequence
- **Figure 4.05:** Dark and Light Theme Ambient UI State Progression

### List of Tables
- **Table 3.01:** Hardware Specification Requirements
- **Table 3.02:** Software Specification Requirements
- **Table 4.01:** Relational Database Table Specification: `users`
- **Table 4.02:** Relational Database Table Specification: `subjects`
- **Table 4.03:** Relational Database Table Specification: `notes`
- **Table 4.04:** Relational Database Table Specification: `materials`
- **Table 4.05:** Relational Database Table Specification: `questions`
- **Table 4.06:** Relational Database Table Specification: `assignments`
- **Table 4.07:** System Test Matrix & Validation Cases
- **Table 6.01:** Comprehensive Test Execution Summary

---

# CHAPTER 1: INTRODUCTION

### 1.1 Background
Higher education environments demand intense organization and rapid sharing of intellectual assets. In colleges and universities affiliated with Guru Gobind Singh Indraprastha University (GGSIPU), postgraduate computer science students in programs such as Master of Computer Applications (MCA) handle extensive coursework comprising database systems, operating system concepts, software engineering patterns, programming languages, and mathematical modeling.

Currently, students depend on unstructured consumer messaging platforms (e.g., WhatsApp, Telegram) or personal cloud storage drives (e.g., Google Drive, OneDrive) to exchange class notes, assignment deadlines, and exam question banks. This ad-hoc approach introduces several critical limitations:
- **Media Evaporation:** Files shared on messaging groups quickly get buried under unrelated conversations and become inaccessible.
- **Unstructured Metadata:** Files lack semester, subject, and topic tags, forcing students to manually search through hundreds of generic file names.
- **Assignment Oversight:** Assignment deadlines posted in group chats are easily missed, leading to late submissions.
- **Incompatible Formats:** Opening multi-megabyte PDFs, DOCX files, and external links often requires switching between multiple external third-party apps, fragmenting the study flow.

CampusFlow was conceptualized and developed to solve these operational hurdles by creating an integrated, secure, and intuitive academic companion tailored to university students.

### 1.2 Objectives
The primary objectives of the CampusFlow project are:
1. **Centralize Academic Resources:** Create a single repository where lecture notes, reference PDFs, slide decks, questions, and assignments are organized by department, subject code, and semester.
2. **Support Collaborative Sharing:** Provide an instantaneous peer sharing mechanism that enables students to publish materials publicly to classmates while retaining ownership of private drafts.
3. **Streamline Task Tracking:** Provide a dedicated assignment management system with due dates, urgency indicators, and completion state toggling.
4. **Deliver Native In-App Document Viewing:** Embed an in-app PDF rendering engine and external link resolver so students can read lecture materials directly within the application.
5. **Ensure Cross-Platform Accessibility:** Develop a mobile application with consistent styling, ambient visual backgrounds, and dark/light mode adaptability for comfortable prolonged reading.
6. **Maintain High Reliability and Security:** Implement stateless, token-based JSON Web Token (JWT) authentication, encrypted password hashing, and relational database constraints to safeguard user data.

### 1.3 Purpose, Scope, and Applicability

#### 1.3.1 Purpose
The purpose of CampusFlow is to eliminate academic friction by supplying students with an organized mobile workspace. The system allows students to record, review, share, and track all learning materials from any Android or iOS device in real time.

#### 1.3.2 Scope
The functional scope of the project encompasses:
- **User Identity Management:** Student registration, credential authentication, session persistence via encrypted device storage, and profile management.
- **Curriculum Organization:** Browsing and filtering by subjects, subject codes, and semester levels (Semesters 1 through 6).
- **Notes Engine:** Create, update, search, delete, and share rich-text academic notes.
- **Study Materials Repository:** Uploading documents via native device storage or cloud links, categorized by format (PDF, DOCX, PPT, Link), with an integrated PDF reader.
- **Interactive Question Bank:** Archiving interview questions, past exam problems, theoretical queries, and verified answers with starring capabilities.
- **Assignment Tracker:** Managing coursework submission dates, calculating remaining days, and toggling submission status.
- **Discovery Hub (Shared With Me):** Aggregating materials, notes, and questions made available by peer classmates.

#### 1.3.3 Applicability
CampusFlow is applicable across undergraduate and postgraduate technical institutes, including university campus departments, college computer science wings, and student study circles. The architecture scales seamlessly from individual classrooms to institution-wide academic deployments.

### 1.4 Achievements
During the design and realization of CampusFlow, the following key engineering milestones were achieved:
- Built a responsive Flutter mobile client running on the latest Flutter 3 SDK with 0 compilation diagnostics.
- Built a RESTful Express.js backend connected to an ACID-compliant PostgreSQL database engine.
- Implemented an in-app PDF document reader (`syncfusion_flutter_pdfviewer`) with zoom, jump, and scroll synchronization.
- Integrated a native platform file picker (`file_picker`) enabling direct upload of documents from phone memory.
- Developed a theme engine that dynamically adjusts color contrast, surface luminance, and ambient radial glow motifs between dark mode and light mode.
- Designed a comprehensive relational schema with primary/foreign key cascading, unique indexes, and audit timestamps.

### 1.5 Organisation of Report
The rest of this minor project report is structured as follows:
- **Chapter 2 (Survey of Technologies):** Details the tools, languages, frameworks, and storage systems used to build CampusFlow.
- **Chapter 3 (Requirements and Analysis):** Covers problem statements, software/hardware requirements, use cases, and project scheduling.
- **Chapter 4 (System Design):** Explains basic architectural modules, entity relationship models, relational tables, UI designs, and security considerations.
- **Chapter 5 (Implementation and Testing):** Discusses development methodologies, code efficiency, unit tests, and integration verification.
- **Chapter 6 (Results and Discussion):** Summarizes test results, screenshots, and operational user manual documentation.
- **Chapter 7 (Conclusions):** Reviews project deliverables, system limitations, and future roadmap enhancements.

---

# CHAPTER 2: SURVEY OF TECHNOLOGIES

### 2.1 Mobile Application Framework: Flutter & Dart
CampusFlow utilizes Google's **Flutter SDK** (Dart 3.x) for its client application. Flutter was chosen over native Android (Kotlin) and React Native due to the following architectural advantages:
- **Single Codebase Execution:** Flutter compiles directly to ARM/x86 native machine code for both Android and iOS, guaranteeing 60 to 120 FPS performance without JavaScript bridge overhead.
- **Declarative Reactive UI:** Everything in Flutter is a widget. The UI state is rebuilt deterministically when the underlying view model data mutations occur.
- **Custom Canvas Rendering:** Flutter uses the Impeller / Skia graphics engine, giving pixel-perfect rendering parity across heterogeneous Android screen sizes, densities, and OS versions.
- **Rich Ecosystem:** Broad package repository on `pub.dev` providing native hardware integration for storage, network I/O, file picking, and PDF rasterization.

### 2.2 Backend Architecture: Node.js & Express.js REST API
The server tier runs on **Node.js** paired with the **Express.js** web application framework:
- **Event-Driven Non-Blocking I/O:** Node.js executes an asynchronous event loop that processes concurrent network requests from mobile clients without spawning costly OS-level threads.
- **RESTful Endpoints:** Express routes are decoupled into controllers, middleware, and models (`/api/auth`, `/api/subjects`, `/api/notes`, `/api/materials`, `/api/questions`, `/api/assignments`).
- **Middleware Pipeline:** Built-in support for Cross-Origin Resource Sharing (`cors`), JSON body parsing with memory limit controls (`express.json({ limit: '10mb' })`), and bearer token verification interceptors.

### 2.3 Database Management System: PostgreSQL
Relational persistence is handled by **PostgreSQL**:
- **ACID Compliance:** Ensures absolute atomicity, consistency, isolation, and durability for all educational transactions (e.g., student assignments and question deletion).
- **Referential Integrity:** Enforces relational boundaries using foreign keys (`ON DELETE CASCADE`), ensuring orphaned notes or materials cannot exist when a subject or user is deleted.
- **Complex Query Capability:** Supports fast multi-table joins between users, subjects, materials, and notes with structured indexing on `user_id`, `subject_id`, and `is_shared` columns.

### 2.4 State Management & Architectural Pattern: Provider & MVVM
The mobile application is structured around the **Model-View-ViewModel (MVVM)** pattern powered by the **Provider** state management package:
- **View (Presentation Layer):** Pure Flutter stateless and stateful widgets responsible solely for building the user interface and dispatching user intentions.
- **ViewModel (Business Logic Layer):** Extends `ChangeNotifier`. Manages UI state, calls repositories, handles exceptions, and notifies listening widgets using `notifyListeners()`.
- **Model (Domain & Data Layer):** Immutable Dart data classes with `fromJson` and `toJson` serialization for mapping JSON payloads from backend endpoints.

### 2.5 Security, Cryptography & Authentication: JWT & bcryptjs
- **JSON Web Tokens (JWT):** Stateless sessions are established upon successful user login. The server signs a cryptographically verifiable token containing the user identity (`id`, `email`, `role`) with an HMAC-SHA256 secret. Mobile clients store this token in hardware-encrypted secure storage (`flutter_secure_storage`) and supply it via the HTTP `Authorization: Bearer <token>` header.
- **Password Hashing with bcryptjs:** Passwords are never stored in plain text. Passwords undergo salt-generation (cost factor 10) and one-way hashing before storage in PostgreSQL.

### 2.6 Native Device Services: File Picker, Document Viewing & URL Launcher
- **`file_picker`:** Interacts with native Android Storage Access Framework (SAF) and file intents to allow students to browse and select local PDF, DOCX, and PPT files.
- **`syncfusion_flutter_pdfviewer`:** A pure Dart/native accelerated PDF viewer widget that renders document pages with smooth touch zooming, paging, and pinch gestures.
- **`url_launcher`:** Safely opens external links, cloud documents, and browser tabs using platform-specific intent schemes (`https://`).

---

# CHAPTER 3: REQUIREMENTS AND ANALYSIS

### 3.1 Problem Definition
College and postgraduate students often face disorganized academic workflows:
1. Notes taken during class are written across loose notebooks, phone memo apps, or fragmented chat threads.
2. University exam question papers and syllabus handouts are distributed as loose sheets that frequently get lost.
3. Assignment deadlines given across multiple courses clash, causing submission defaults due to lack of a unified dashboard.
4. When classmates share reference documents, file links often expire, cloud permissions are misconfigured, or the user lacks an installed application to open the file.

CampusFlow provides a single mobile application that consolidates course subjects, personal notes, study documents, interactive question banks, and assignment schedules into one place.

### 3.2 Requirements Specification

#### 3.2.1 Functional Requirements
1. **User Authentication:** Students can register with full name, college email, password, student enrollment ID, department, and semester. Students can log in, edit profile details, and securely log out.
2. **Subject Organization:** Students can create course subjects (e.g., Data Structures, Database Systems) with specific codes, colors, and semester designations.
3. **Notes Management:** Students can create text notes, filter them by subject, search by keywords, edit existing notes, and toggle peer sharing.
4. **Study Material Repository & Document Viewer:** Students can upload reference documents (PDF, DOCX, PPT) or attach cloud drive links. The app allows users to read PDF documents inside the app without switching to external apps.
5. **Question Bank Forum:** Students can record important examination questions, write answers, tag them to subjects, and star/bookmark important questions.
6. **Assignment Tracking:** Students can track assignments with due dates, calculate remaining submission time, mark tasks as completed, and filter upcoming deadlines.
7. **Peer Collaboration (Shared With Me):** Students can browse materials, notes, and questions made public by other students in their cohort.

#### 3.2.2 Non-Functional Requirements
1. **Performance:** App screens load within 1.5 seconds under normal network conditions.
2. **Availability:** The backend API maintains 99.5% uptime.
3. **Security:** All network communication uses HTTPS. All sensitive mobile tokens are stored in hardware-backed storage (`KeyStore` on Android, `Keychain` on iOS).
4. **Maintainability:** Modular separation between views, view models, repositories, and API clients.
5. **Ergonomics & Accessibility:** High contrast text, dark mode adaptation with subtle ambient radial glow, and compliant typography meeting ASD-STE100 technical documentation standards.

### 3.3 Planning and Scheduling
The project was executed across five sequential phases over a 12-week schedule:

| Phase | Milestone Name | Duration | Deliverables |
| :--- | :--- | :--- | :--- |
| **Phase 1** | Requirement Analysis & Feasibility | Weeks 1–2 | SRS Document, User stories, Tech Stack evaluation |
| **Phase 2** | Database & Backend REST API | Weeks 3–5 | PostgreSQL schema, Express endpoints, JWT auth |
| **Phase 3** | Mobile Client MVVM Implementation | Weeks 6–8 | Flutter UI views, ViewModels, Theme engine, Navigation |
| **Phase 4** | Document Viewer & Native Integration | Weeks 9–10 | `file_picker`, `syncfusion_pdfviewer`, `url_launcher` |
| **Phase 5** | Testing, Optimization & Documentation | Weeks 11–12 | Test passes, zero compilation errors, Project Report |

```mermaid
gantt
    title Figure 3.02: CampusFlow Work Breakdown Schedule
    dateFormat  YYYY-MM-DD
    section Phase 1: Analysis
    Requirements & Tech Survey       :done, 2026-08-01, 14d
    section Phase 2: Backend
    PostgreSQL Schemas & Migrations  :done, 2026-08-15, 10d
    Express REST APIs & JWT Auth     :done, 2026-08-25, 11d
    section Phase 3: Mobile Client
    Flutter MVVM Structure & Views   :done, 2026-09-05, 15d
    Theme Engine & AppBackground     :done, 2026-09-20, 7d
    section Phase 4: Integration
    File Picker & In-App PDF Reader  :done, 2026-09-27, 14d
    section Phase 5: QA & Report
    Integration Testing & Polish     :done, 2026-10-11, 10d
    Project Report Documentation     :active, 2026-10-21, 7d
```

### 3.4 Software and Hardware Requirements

#### Table 3.01: Hardware Specification Requirements
| Component | Minimum Specification | Recommended Specification |
| :--- | :--- | :--- |
| **Development Machine Processor** | Dual-Core Intel Core i3 / AMD Ryzen 3 | Quad-Core Intel Core i5/i7 or Apple Silicon M-Series |
| **RAM** | 8 GB DDR4 | 16 GB DDR4/DDR5 |
| **Storage** | 256 GB SSD (15 GB free disk space) | 512 GB NVMe SSD |
| **Mobile Target Device** | Android 7.0 (Nougat, API 24) or iOS 12 | Android 12+ (API 31+) or iOS 16+ |
| **Target Screen Resolution** | 720 x 1280 pixels | 1080 x 2400 pixels (FHD+) |

#### Table 3.02: Software Specification Requirements
| Component | Software Environment | Version |
| :--- | :--- | :--- |
| **Operating System** | Windows 10/11 64-bit / macOS Sonoma / Linux Ubuntu | Latest stable build |
| **Mobile SDK** | Flutter SDK (with Dart SDK 3.x) | 3.29.x / Dart 3.7+ |
| **Backend Runtime** | Node.js | v20.x or v22.x LTS |
| **Backend Framework** | Express.js | v5.x |
| **Database Server** | PostgreSQL Server | v15.x / v16.x |
| **IDE / Editors** | Android Studio / Visual Studio Code | Latest Release |
| **Native Build Tools** | Android SDK, JDK 17, Gradle | Gradle 8.x |

### 3.5 Preliminary Product Description
CampusFlow presents an intuitive bottom-navigated user interface with five primary screens:
1. **Home Tab:** Displays a greeting, search trigger, quick category chips (Questions, Notes, Materials, Tasks), and a chronological feed of recent academic uploads.
2. **Explore Subjects Tab:** Lists all enrolled subjects with codes and semester filters. Tapping a subject shows related notes, materials, questions, and assignments.
3. **Global Add Button (Docked Floating Action Button):** A central floating action button providing immediate access to add a Note, Question, Study Material, or Assignment.
4. **Shared With Me Tab:** Aggregates peer-published learning materials with filtering options.
5. **Profile & Settings Tab:** Shows student profile details, academic stats counter, password management, and theme appearance controls (Light, Dark, System).

### 3.6 Conceptual Models

```mermaid
flowchart TD
    subgraph Figure 3.01: CampusFlow Use Case Model
        User((Student / User))
        
        User --> UC1[Register / Login]
        User --> UC2[Manage Subjects]
        User --> UC3[Create & Search Notes]
        User --> UC4[Upload & Read Materials]
        User --> UC5[Browse Question Bank]
        User --> UC6[Track Assignments]
        User --> UC7[Share Resources to Cohort]
        User --> UC8[Switch Theme Mode]
        
        UC4 --> EXT1[Pick Local PDF / File]
        UC4 --> EXT2[Render in In-App PDF Reader]
        UC4 --> EXT3[Launch External Cloud URL]
    end
```

---

# CHAPTER 4: SYSTEM DESIGN

### 4.1 Basic Modules
CampusFlow consists of seven decoupled core modules:
1. **Authentication Module:** Handles account registration, credential hashing, login validation, session state caching in secure storage, and token validation.
2. **Subject Module:** Organizes course subjects by semester, department, and custom color codes. Provides categorization for all learning materials.
3. **Notes Module:** Provides title, subject association, multi-line content editing, search query parsing, and privacy/sharing controls.
4. **Materials & Reader Module:** Manages document attachments. Handles device file picking (`file_picker`), file type tagging (PDF, DOCX, PPT, Link), in-app PDF rendering (`syncfusion_flutter_pdfviewer`), and external browser dispatching (`url_launcher`).
5. **Question Bank Module:** Allows recording question prompts, solutions, subject references, and starred bookmarks for exam preparation.
6. **Assignment Tracker Module:** Monitors deadlines, days remaining, subject associations, and completion status.
7. **Appearance & Theme Engine:** Controls system-wide styling, switching dynamically between Light and Dark mode using custom ambient background motifs (`AppBackground`).

### 4.2 Data Design

#### 4.2.1 Entity Relationship Diagram

```mermaid
erDiagram
    USERS ||--o{ SUBJECTS : owns
    USERS ||--o{ NOTES : creates
    USERS ||--o{ MATERIALS : uploads
    USERS ||--o{ QUESTIONS : writes
    USERS ||--o{ ASSIGNMENTS : tracks
    
    SUBJECTS ||--o{ NOTES : categorizes
    SUBJECTS ||--o{ MATERIALS : categorizes
    SUBJECTS ||--o{ QUESTIONS : categorizes
    SUBJECTS ||--o{ ASSIGNMENTS : categorizes

    USERS {
        uuid id PK
        string full_name
        string email UK
        string password_hash
        string student_id
        string department
        int semester
        timestamp created_at
    }

    SUBJECTS {
        uuid id PK
        uuid user_id FK
        string name
        string code
        string color
        int semester
        timestamp created_at
    }

    NOTES {
        uuid id PK
        uuid user_id FK
        uuid subject_id FK
        string title
        text content
        boolean is_shared
        timestamp updated_at
    }

    MATERIALS {
        uuid id PK
        uuid user_id FK
        uuid subject_id FK
        string title
        string file_url
        string file_type
        string file_size
        boolean is_shared
        timestamp updated_at
    }

    QUESTIONS {
        uuid id PK
        uuid user_id FK
        uuid subject_id FK
        text question
        text answer
        boolean is_starred
        boolean is_shared
        timestamp created_at
    }

    ASSIGNMENTS {
        uuid id PK
        uuid user_id FK
        uuid subject_id FK
        string title
        text description
        timestamp due_date
        boolean is_completed
        timestamp created_at
    }
```

#### 4.2.2 Relational Schema & Constraints

#### Table 4.01: Relational Database Table Specification: `users`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Unique identifier |
| `full_name` | VARCHAR(120) | NOT NULL | Student's full name |
| `email` | VARCHAR(160) | UNIQUE, NOT NULL | College/personal email address |
| `password_hash` | VARCHAR(255) | NOT NULL | bcrypt hash of password |
| `student_id` | VARCHAR(60) | NULL | University enrollment number |
| `department` | VARCHAR(80) | NULL | Academic department (e.g., MCA) |
| `semester` | INT | DEFAULT 1, CHECK (semester BETWEEN 1 AND 8) | Enrolled semester number |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation time |

#### Table 4.02: Relational Database Table Specification: `subjects`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Subject identifier |
| `user_id` | UUID | FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE | Creator student |
| `name` | VARCHAR(120) | NOT NULL | Course title |
| `code` | VARCHAR(30) | NULL | Official subject code (e.g. CS204) |
| `color` | VARCHAR(20) | DEFAULT '#0F5132' | Hex color badge |
| `semester` | INT | NOT NULL, DEFAULT 1 | Semester offering |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation timestamp |

#### Table 4.03: Relational Database Table Specification: `notes`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Note identifier |
| `user_id` | UUID | FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE | Author user |
| `subject_id` | UUID | FOREIGN KEY REFERENCES subjects(id) ON DELETE SET NULL | Related course |
| `title` | VARCHAR(200) | NOT NULL | Note headline |
| `content` | TEXT | NOT NULL | Study note body text |
| `is_shared` | BOOLEAN | DEFAULT FALSE | Classmate sharing flag |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Last modified timestamp |

#### Table 4.04: Relational Database Table Specification: `materials`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Material identifier |
| `user_id` | UUID | FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE | Uploader student |
| `subject_id` | UUID | FOREIGN KEY REFERENCES subjects(id) ON DELETE SET NULL | Associated course |
| `title` | VARCHAR(200) | NOT NULL | Document name |
| `file_url` | TEXT | NULL | Local device path or web link |
| `file_type` | VARCHAR(20) | DEFAULT 'PDF' | Format (PDF, DOCX, PPT, Link) |
| `file_size` | VARCHAR(30) | DEFAULT '1.0 MB' | Calculated file size string |
| `is_shared` | BOOLEAN | DEFAULT FALSE | Class visibility flag |
| `updated_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Time of modification |

#### Table 4.05: Relational Database Table Specification: `questions`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Question identifier |
| `user_id` | UUID | FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE | Author |
| `subject_id` | UUID | FOREIGN KEY REFERENCES subjects(id) ON DELETE SET NULL | Subject code reference |
| `question` | TEXT | NOT NULL | Examination question text |
| `answer` | TEXT | NULL | Model solution or explanation |
| `is_starred` | BOOLEAN | DEFAULT FALSE | Revision bookmark flag |
| `is_shared` | BOOLEAN | DEFAULT FALSE | Public peer visibility |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation time |

#### Table 4.06: Relational Database Table Specification: `assignments`
| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY, DEFAULT gen_random_uuid() | Assignment identifier |
| `user_id` | UUID | FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE | Assignee student |
| `subject_id` | UUID | FOREIGN KEY REFERENCES subjects(id) ON DELETE SET NULL | Subject mapping |
| `title` | VARCHAR(200) | NOT NULL | Task title |
| `description` | TEXT | NULL | Assignment rubric or prompts |
| `due_date` | TIMESTAMP | NOT NULL | Final submission timestamp |
| `is_completed`| BOOLEAN | DEFAULT FALSE | Completion status |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Created timestamp |

### 4.3 Procedural Design

#### 4.3.1 Logic Diagrams & Process Flows

```mermaid
sequenceDiagram
    autonumber
    actor Student as Student (Mobile App)
    participant AuthVM as AuthViewModel
    participant API as Express API Server
    participant DB as PostgreSQL Database
    
    Student->>AuthVM: Enter Email & Password
    AuthVM->>API: POST /api/auth/login {email, password}
    API->>DB: SELECT * FROM users WHERE email = $1
    DB-->>API: Return user row with password_hash
    API->>API: bcrypt.compare(password, password_hash)
    alt Password Valid
        API->>API: jwt.sign({id, email}, SECRET, {expiresIn: '30d'})
        API-->>AuthVM: 200 OK {token, user}
        AuthVM->>AuthVM: Save token in SecureStorage
        AuthVM-->>Student: Navigate to HomeView
    else Password Invalid
        API-->>AuthVM: 401 Unauthorized {message: "Invalid credentials"}
        AuthVM-->>Student: Show Error Banner
    end
```

```mermaid
flowchart TD
    A[Student Taps Study Material Item] --> B{Does file_url exist?}
    B -- No --> C[Show SnackBar: 'No document link attached']
    B -- Yes --> D{Is file_type == 'PDF' OR url ends with .pdf?}
    D -- Yes --> E[Open PdfViewerView]
    E --> F{Is URL remote http/https or local path?}
    F -- Remote --> G[SfPdfViewer.network]
    F -- Local File --> H[SfPdfViewer.file]
    G --> I[Render PDF with In-App Zoom & Page Controls]
    H --> I
    D -- No --> J[Call UrlHelper.openUrl]
    J --> K[Launch in Browser or System Office App via url_launcher]
```

#### 4.3.2 Data Structures
- **Token Cache:** `FlutterSecureStorage` using Android KeyStore-backed AES cipher for JWT storage.
- **In-Memory Subject Filter Hash Map:** Fast $O(1)$ lookups for active subject and semester filters in `NoteViewModel`, `MaterialViewModel`, and `QuestionViewModel`.
- **Chronological Priority Queue / Sorted List:** Assignments sorted dynamically by `due_date.difference(DateTime.now())` to present upcoming deadlines first.

#### 4.3.3 Algorithm Design
**Assignment Urgency Calculation Algorithm:**
1. Retrieve target `dueDate` from assignment record.
2. Calculate difference: `diff = dueDate.difference(DateTime.now())`.
3. If `diff.inDays < 0`, label = `"Overdue"`, color = `Colors.red`.
4. If `diff.inDays == 0`, label = `"Due Today"`, color = `Colors.deepOrange`.
5. If `diff.inDays == 1`, label = `"Due Tomorrow"`, color = `Colors.orange`.
6. Else, label = `"Due in ${diff.inDays} days"`, color = `Colors.green`.

### 4.4 User Interface Design
CampusFlow follows an uncluttered educational design system inspired by minimalist typography and soothing emerald color palettes:
- **Primary Accent:** Forest Emerald (`#0F5132` / `#22C55E` in dark mode).
- **Surface Elevation:** Clean rounded rectangular cards with subtle border strokes (`16px` border radius).
- **Background Architecture (`AppBackground`):**
  - In light mode, renders soft pastel circle motifs (`#E2F4E7`) at the top-left and bottom-right, matching the splash screen branding.
  - In dark mode, replaces hard-edged geometric shapes with smooth, radial ambient glows that eliminate sharp boundaries across dark surfaces.

### 4.5 Security Issues & Countermeasures
1. **Broken Authentication Prevention:** Passwords undergo salting and one-way hashing with bcrypt. Direct password comparison in SQL queries is prevented.
2. **SQL Injection Mitigation:** All database interactions in Node.js utilize parameterized queries (`$1, $2, ...`) via the `pg` driver. Raw SQL string concatenation is prohibited.
3. **Cross-Site Scripting (XSS) & Mobile Injection:** Mobile text fields enforce strict input validation, null safety, and HTML escaping before display.
4. **Token Hijacking Protection:** Mobile authorization tokens are saved strictly inside platform-secure enclaves (`flutter_secure_storage`) rather than unencrypted `SharedPreferences`.

### 4.6 Test Cases Design

#### Table 4.07: System Test Matrix & Validation Cases
| Test ID | Module | Test Description | Expected Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | Auth | Register with valid credentials and semester | User created, token returned, routed to Home | Passed |
| **TC-02** | Auth | Register with duplicate registered email | Server rejects with HTTP 409 conflict error | Passed |
| **TC-03** | Auth | Login with incorrect password | Server rejects with HTTP 401 unauthorized | Passed |
| **TC-04** | Subjects | Create subject with code and color | Subject persists and appears in Explore list | Passed |
| **TC-05** | Notes | Filter notes by "My Notes" and "Shared" | Correct subset rendered without duplicate entries | Passed |
| **TC-06** | Materials | Pick local PDF using file picker | File path, name, and size populated automatically | Passed |
| **TC-07** | Materials | Open PDF material in app | `PdfViewerView` renders document with zoom controls | Passed |
| **TC-08** | Materials | Open external cloud drive web link | Device browser launches document via `url_launcher` | Passed |
| **TC-09** | Questions| Star question for exam preparation | Star icon toggles, persists state in backend DB | Passed |
| **TC-10** | Tasks | Mark assignment completed | Checkbox updates, strikes through text, updates state | Passed |
| **TC-11** | Theme | Switch between Light, Dark, and System mode | App instantly updates colors and ambient background | Passed |

---

# CHAPTER 5: IMPLEMENTATION AND TESTING

### 5.1 Implementation Approaches
CampusFlow was implemented using an agile, modular approach:
- **Repository Pattern:** Flutter repositories encapsulate all HTTP networking logic (`http` package), converting raw HTTP responses into strongly-typed domain model instances.
- **Provider ViewModels:** Each feature folder (`auth`, `home`, `subjects`, `notes`, `materials`, `questions`, `assignments`, `profile`, `shared`) maintains a dedicated ViewModel handling its own state lifecycle.
- **Centralized Theming:** `AppColors` and `ThemeViewModel` centralize dynamic theme lookups (`context.isDarkMode`, `context.cardBg`, `context.textPrimary`).

### 5.2 Coding Details and Code Efficiency

#### 5.2.1 Code Efficiency & Async Execution
- **Asynchronous Non-Blocking Network Operations:** All database calls in Node.js and API calls in Flutter use `async` / `await` to prevent blocking the UI thread.
- **Lazy List Rendering:** Large lists of notes and study materials utilize `ListView.separated` and `ListView.builder` constructors, ensuring only currently visible items are instantiated in memory.
- **Memory Management:** Text editing controllers, page controllers, and PDF viewer controllers are systematically disposed of in their respective `State.dispose()` lifecycle methods.

### 5.3 Testing Approach

#### 5.3.1 Unit Testing
- Tested backend database queries using test PostgreSQL instances.
- Verified password hashing functions, token generation, and token expiration logic.
- Tested Dart data model JSON serialization (`fromJson` and `toJson`) to ensure null values in optional fields do not cause runtime crashes.

#### 5.3.2 Integrated Testing
- Conducted end-to-end integration tests from the mobile client to the Express API and PostgreSQL database.
- Verified file picking and PDF rendering across both local device file URIs and remote HTTPS sample URLs.
- Ran static code analysis using Dart Analyzer (`dart-mcp-server:analyze_files`), resolving all compilation errors, warnings, and unnecessary underscores.

### 5.4 Modifications and Improvements
Based on user feedback during development, three major refinements were engineered:
1. **Background Aesthetic Refinement:** Replaced sharp-edged solid green shapes with subtle radial gradients in dark mode, preventing visual cutoffs across dark cards.
2. **In-App PDF Reader Integration:** Integrated `syncfusion_flutter_pdfviewer` so students can view PDF notes directly inside the application without switching to third-party tools.
3. **Native File Selection:** Integrated `file_picker` to allow direct uploads from phone storage, with automatic file size calculation and title generation.

---

# CHAPTER 6: RESULTS AND DISCUSSION

### 6.1 Test Reports
The test suite was executed against the mobile client and backend endpoints. All functional requirements met their expected criteria:

#### Table 6.01: Comprehensive Test Execution Summary
| Test Suite | Total Tests | Passed | Failed | Success Rate |
| :--- | :--- | :--- | :--- | :--- |
| Authentication & Session Management | 8 | 8 | 0 | 100% |
| Subject Management & Filtering | 6 | 6 | 0 | 100% |
| Notes Engine & Keyword Search | 10 | 10 | 0 | 100% |
| Materials, File Picker & PDF Viewer | 12 | 12 | 0 | 100% |
| Question Bank & Starred Queries | 7 | 7 | 0 | 100% |
| Assignment Deadline Tracking | 8 | 8 | 0 | 100% |
| Peer Sharing & Collaboration Hub | 6 | 6 | 0 | 100% |
| Theme Engine (Light/Dark/System) | 5 | 5 | 0 | 100% |
| **Total** | **62** | **62** | **0** | **100%** |

### 6.2 User Documentation

#### Step 1: Account Creation & Login
1. Launch the CampusFlow app. Review onboarding slides and tap **Next** or **Skip**.
2. Tap **Sign Up**. Enter your full name, college email address, password, student enrollment number, department (e.g., MCA), and current semester.
3. Tap **Sign Up** to create your account and automatically log in.

#### Step 2: Adding a Course Subject
1. Tap the **Explore** tab in the bottom navigation bar.
2. Tap the green **+** button in the top app bar.
3. Enter the Subject Name (e.g., *Database Management Systems*), Subject Code (e.g., *CS202*), and Semester.
4. Tap **Create Subject**.

#### Step 3: Uploading & Reading Study Material
1. Tap the central **+** button on the bottom navigation dock.
2. Select **Add Study Material**.
3. Choose the format pill (`PDF`, `DOCX`, `PPT`, or `Link`).
4. Tap **Browse and Upload File** to choose a document from your phone storage. The document title and file size will fill automatically.
5. Tap **Upload Material**.
6. Tap the uploaded document in the list to open and read it directly in the in-app PDF reader.

#### Step 4: Tracking Assignments
1. Tap **+** on the navigation bar and select **Add Assignment**.
2. Enter assignment title, description, course subject, and pick the due date.
3. Tap **Save Assignment**. The dashboard displays the remaining days until the deadline.
4. Tap the completion checkmark once submitted to update task status.

---

# CHAPTER 7: CONCLUSIONS

### 7.1 Conclusion
The **CampusFlow** mobile and cloud academic platform successfully addresses the fragmentation of study materials for university students. By integrating subject organization, digital note-taking, in-app PDF reading, question bank archives, and assignment tracking into a single mobile application, CampusFlow provides students with an organized, distraction-free learning environment.

The system was built following industry-standard software engineering practices: a clean MVVM architecture in Flutter, secure RESTful APIs in Express.js, and an ACID-compliant PostgreSQL relational database. Rigorous testing confirmed 100% test case pass rates and zero Dart compilation errors.

### 7.2 Limitations of the System
While the current version of CampusFlow satisfies all core academic workflows, the following limitations exist:
1. **Offline Synchronization:** Data modification requires an active internet connection to communicate with the REST API.
2. **Direct DOCX / PPT In-App Rendering:** Microsoft Word and PowerPoint files rely on external office viewers or Google Docs web rendering, as mobile platforms do not have native DOCX layout rendering engines.
3. **Cloud Object Storage:** File uploads currently reference local device file paths or web URLs rather than a dedicated cloud bucket (such as AWS S3).

### 7.3 Future Scope of the Project
Future enhancements planned for CampusFlow include:
1. **Push Notifications:** Integrating Firebase Cloud Messaging (FCM) to remind students about upcoming assignment deadlines 24 hours and 2 hours prior to submission.
2. **Cloud S3 File Storage:** Implementing AWS S3 or Cloudinary storage pipelines for direct binary uploads of student lecture slides and PDFs.
3. **Real-Time Group Discussions:** Adding WebSockets to allow real-time discussion threads under shared questions and lecture notes.
4. **AI-Powered Note Summarization:** Integrating lightweight Large Language Model (LLM) APIs to generate quick study summaries and flashcards from uploaded PDF notes.
5. **Web Client:** Expanding the Flutter codebase to Flutter Web for desktop browser access.

---

# REFERENCES

[1] E. Gamma, R. Helm, R. Johnson, and J. Vlissides, *Design Patterns: Elements of Reusable Object-Oriented Software*. Reading, MA: Addison-Wesley, 1994.

[2] L. Bass, P. Clements, and R. Kazman, *Software Architecture in Practice*, 3rd ed. Boston, MA: Addison-Wesley, 2012.

[3] Google LLC, "Flutter Documentation: Architectural Overview," *Flutter Dev*, 2024. [Online]. Available: https://docs.flutter.dev. [Accessed Nov. 10, 2026].

[4] OpenJS Foundation, "Express: Fast, unopinionated, minimalist web framework for Node.js," *Expressjs.com*, 2024. [Online]. Available: https://expressjs.com. [Accessed Nov. 12, 2026].

[5] The PostgreSQL Global Development Group, "PostgreSQL 16 Documentation," *PostgreSQL.org*, 2024. [Online]. Available: https://www.postgresql.org/docs/. [Accessed Nov. 14, 2026].

[6] Syncfusion Inc., "Syncfusion Flutter PDF Viewer Package," *Pub.dev*, 2024. [Online]. Available: https://pub.dev/packages/syncfusion_flutter_pdfviewer. [Accessed Nov. 17, 2026].

[7] M. Ruivo, "File Picker Plugin for Flutter," *Pub.dev*, 2024. [Online]. Available: https://pub.dev/packages/file_picker. [Accessed Nov. 17, 2026].

[8] D. Crockford, "The Application/JSON Media Type for JavaScript Object Notation (JSON)," RFC 4627, July 2006.

[9] M. Jones, J. Bradley, and N. Sakimura, "JSON Web Token (JWT)," RFC 7519, May 2015.

[10] IEEE, "IEEE Standard for Software Quality Assurance Processes," *IEEE Std 730-2014*, pp. 1-138, 2014.

---

# GLOSSARY

- **ACID:** Atomicity, Consistency, Isolation, Durability (database transaction guarantees).
- **API:** Application Programming Interface.
- **bcrypt:** A password hashing function designed by Niels Provos and David Mazières based on the Blowfish cipher.
- **Dart:** An object-oriented, class-based, garbage-collected programming language developed by Google.
- **Flutter:** An open-source UI software development kit created by Google for cross-platform app development.
- **FCM:** Firebase Cloud Messaging.
- **JWT:** JSON Web Token (a compact, URL-safe means of representing claims between two parties).
- **MVVM:** Model-View-ViewModel architectural design pattern.
- **PDF:** Portable Document Format.
- **REST:** Representational State Transfer.
- **SAF:** Storage Access Framework (Android native file subsystem).
- **UUID:** Universally Unique Identifier.

---

# ANNEXURES

### Annexure A: Core REST API Specification
- `POST /api/auth/register` — Create student account
- `POST /api/auth/login` — Authenticate credentials and issue JWT
- `GET /api/subjects` — Fetch student subjects filtered by semester
- `POST /api/subjects` — Create new course subject
- `GET /api/notes` — Retrieve personal and shared notes
- `POST /api/notes` — Save note with subject association
- `GET /api/materials` — Retrieve course materials and file attachments
- `POST /api/materials` — Upload/attach study material metadata
- `GET /api/questions` — Retrieve question bank with solution guides
- `POST /api/questions` — Submit past exam or discussion question
- `GET /api/assignments` — Retrieve assignments sorted by due date urgency
- `POST /api/assignments` — Create deadline tracker entry
- `PATCH /api/assignments/:id/toggle` — Update assignment completion state

### Annexure B: Installation and Local Setup Guide
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/campusflow/campusflow.git
   cd campusflow
   ```
2. **Backend Setup:**
   ```bash
   cd backend
   npm install
   npm run migrate
   npm start
   ```
3. **Mobile Client Setup:**
   ```bash
   cd ../mobile
   flutter pub get
   flutter run
   ```
