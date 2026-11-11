# API Documentation

## Base URL
`http://localhost:5000/api`

---

## Authentication Endpoints

### 1. Register User
- **Route:** `POST /auth/register`
- **Access:** Public
- **Request Body:**
```json
{
  "fullName": "John Doe",
  "email": "johndoe@example.com",
  "password": "secretpassword",
  "studentId": "STU12345",
  "department": "Computer Science",
  "semester": 4,
  "role": "student"
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "User registered successfully.",
  "data": {
    "user": {
      "id": "uuid-here",
      "full_name": "John Doe",
      "email": "johndoe@example.com",
      "student_id": "STU12345",
      "department": "Computer Science",
      "semester": 4,
      "role": "student",
      "avatar_url": null,
      "created_at": "2026-10-21T12:00:00.000Z"
    },
    "token": "jwt-token-string"
  }
}
```

---

## Subject Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Subject
- **Route:** `POST /subjects`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Data Structures & Algorithms",
  "code": "CS201",
  "description": "Core computer science fundamentals",
  "semester": 4,
  "department": "Computer Science",
  "color": "#0F5132",
  "icon": "menu_book"
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Subject created successfully.",
  "data": {
    "subject": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "name": "Data Structures & Algorithms",
      "code": "CS201",
      "description": "Core computer science fundamentals",
      "semester": 4,
      "department": "Computer Science",
      "color": "#0F5132",
      "icon": "menu_book",
      "created_at": "2026-11-06T12:00:00.000Z",
      "updated_at": "2026-11-06T12:00:00.000Z"
    }
  }
}
```

### 2. Get All Subjects
- **Route:** `GET /subjects`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subjects retrieved successfully.",
  "data": {
    "subjects": []
  }
}
```

### 3. Get Subject by ID
- **Route:** `GET /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject retrieved successfully.",
  "data": {
    "subject": {}
  }
}
```

### 4. Update Subject
- **Route:** `PUT /subjects/:id`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Advanced Data Structures",
  "description": "Updated course description"
}
```
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject updated successfully.",
  "data": {
    "subject": {}
  }
}
```

### 5. Delete Subject
- **Route:** `DELETE /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject deleted successfully."
}
```

---

## Notes Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Note
- **Route:** `POST /notes`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "Data Structures - Binary Trees",
  "content": "Trees are non-linear data structures consisting of nodes...",
  "tags": ["Tree", "Unit 2"],
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Note created successfully.",
  "data": {
    "note": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "subject_id": "subject-uuid",
      "title": "Data Structures - Binary Trees",
      "content": "Trees are non-linear data structures...",
      "tags": ["Tree", "Unit 2"],
      "is_shared": true,
      "created_at": "2026-11-11T12:00:00.000Z",
      "updated_at": "2026-11-11T12:00:00.000Z"
    }
  }
}
```

### 2. Get Notes
- **Route:** `GET /notes?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Notes retrieved successfully.",
  "data": {
    "notes": []
  }
}
```

### 3. Update Note
- **Route:** `PUT /notes/:id`
- **Access:** Protected

### 4. Delete Note
- **Route:** `DELETE /notes/:id`
- **Access:** Protected

---

## Study Materials Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Study Material
- **Route:** `POST /materials`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "OOP Lecture Slides",
  "fileUrl": "https://example.com/oop.pdf",
  "fileType": "PDF",
  "fileSize": "2.4 MB",
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Study material created successfully.",
  "data": {
    "material": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "title": "OOP Lecture Slides",
      "file_type": "PDF",
      "file_size": "2.4 MB"
    }
  }
}
```

### 2. Get Study Materials
- **Route:** `GET /materials?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Materials retrieved successfully.",
  "data": {
    "materials": []
  }
}
```

### 3. Update Study Material
- **Route:** `PUT /materials/:id`
- **Access:** Protected

### 4. Delete Study Material
- **Route:** `DELETE /materials/:id`
- **Access:** Protected

### 2. Login User
- **Route:** `POST /auth/login`
- **Access:** Public
- **Request Body:**
```json
{
  "email": "johndoe@example.com",
  "password": "secretpassword"
}
```
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Login successful.",
  "data": {
    "user": {
      "id": "uuid-here",
      "full_name": "John Doe",
      "email": "johndoe@example.com",
      "student_id": "STU12345",
      "department": "Computer Science",
      "semester": 4,
      "role": "student",
      "avatar_url": null,
      "created_at": "2026-10-21T12:00:00.000Z"
    },
    "token": "jwt-token-string"
  }
}
```

---

## Subject Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Subject
- **Route:** `POST /subjects`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Data Structures & Algorithms",
  "code": "CS201",
  "description": "Core computer science fundamentals",
  "semester": 4,
  "department": "Computer Science",
  "color": "#0F5132",
  "icon": "menu_book"
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Subject created successfully.",
  "data": {
    "subject": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "name": "Data Structures & Algorithms",
      "code": "CS201",
      "description": "Core computer science fundamentals",
      "semester": 4,
      "department": "Computer Science",
      "color": "#0F5132",
      "icon": "menu_book",
      "created_at": "2026-11-06T12:00:00.000Z",
      "updated_at": "2026-11-06T12:00:00.000Z"
    }
  }
}
```

### 2. Get All Subjects
- **Route:** `GET /subjects`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subjects retrieved successfully.",
  "data": {
    "subjects": []
  }
}
```

### 3. Get Subject by ID
- **Route:** `GET /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject retrieved successfully.",
  "data": {
    "subject": {}
  }
}
```

### 4. Update Subject
- **Route:** `PUT /subjects/:id`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Advanced Data Structures",
  "description": "Updated course description"
}
```
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject updated successfully.",
  "data": {
    "subject": {}
  }
}
```

### 5. Delete Subject
- **Route:** `DELETE /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject deleted successfully."
}
```

---

## Notes Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Note
- **Route:** `POST /notes`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "Data Structures - Binary Trees",
  "content": "Trees are non-linear data structures consisting of nodes...",
  "tags": ["Tree", "Unit 2"],
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Note created successfully.",
  "data": {
    "note": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "subject_id": "subject-uuid",
      "title": "Data Structures - Binary Trees",
      "content": "Trees are non-linear data structures...",
      "tags": ["Tree", "Unit 2"],
      "is_shared": true,
      "created_at": "2026-11-11T12:00:00.000Z",
      "updated_at": "2026-11-11T12:00:00.000Z"
    }
  }
}
```

### 2. Get Notes
- **Route:** `GET /notes?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Notes retrieved successfully.",
  "data": {
    "notes": []
  }
}
```

### 3. Update Note
- **Route:** `PUT /notes/:id`
- **Access:** Protected

### 4. Delete Note
- **Route:** `DELETE /notes/:id`
- **Access:** Protected

---

## Study Materials Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Study Material
- **Route:** `POST /materials`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "OOP Lecture Slides",
  "fileUrl": "https://example.com/oop.pdf",
  "fileType": "PDF",
  "fileSize": "2.4 MB",
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Study material created successfully.",
  "data": {
    "material": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "title": "OOP Lecture Slides",
      "file_type": "PDF",
      "file_size": "2.4 MB"
    }
  }
}
```

### 2. Get Study Materials
- **Route:** `GET /materials?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Materials retrieved successfully.",
  "data": {
    "materials": []
  }
}
```

### 3. Update Study Material
- **Route:** `PUT /materials/:id`
- **Access:** Protected

### 4. Delete Study Material
- **Route:** `DELETE /materials/:id`
- **Access:** Protected

### 3. Get Current User Profile
- **Route:** `GET /auth/me`
- **Access:** Protected (Requires `Authorization: Bearer <token>`)
- **Success Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "full_name": "John Doe",
      "email": "johndoe@example.com",
      "student_id": "STU12345",
      "department": "Computer Science",
      "semester": 4,
      "role": "student",
      "avatar_url": null,
      "created_at": "2026-10-21T12:00:00.000Z"
    }
  }
}
```

---

## Subject Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Subject
- **Route:** `POST /subjects`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Data Structures & Algorithms",
  "code": "CS201",
  "description": "Core computer science fundamentals",
  "semester": 4,
  "department": "Computer Science",
  "color": "#0F5132",
  "icon": "menu_book"
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Subject created successfully.",
  "data": {
    "subject": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "name": "Data Structures & Algorithms",
      "code": "CS201",
      "description": "Core computer science fundamentals",
      "semester": 4,
      "department": "Computer Science",
      "color": "#0F5132",
      "icon": "menu_book",
      "created_at": "2026-11-06T12:00:00.000Z",
      "updated_at": "2026-11-06T12:00:00.000Z"
    }
  }
}
```

### 2. Get All Subjects
- **Route:** `GET /subjects`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subjects retrieved successfully.",
  "data": {
    "subjects": []
  }
}
```

### 3. Get Subject by ID
- **Route:** `GET /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject retrieved successfully.",
  "data": {
    "subject": {}
  }
}
```

### 4. Update Subject
- **Route:** `PUT /subjects/:id`
- **Access:** Protected
- **Request Body:**
```json
{
  "name": "Advanced Data Structures",
  "description": "Updated course description"
}
```
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject updated successfully.",
  "data": {
    "subject": {}
  }
}
```

### 5. Delete Subject
- **Route:** `DELETE /subjects/:id`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Subject deleted successfully."
}
```

---

## Notes Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Note
- **Route:** `POST /notes`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "Data Structures - Binary Trees",
  "content": "Trees are non-linear data structures consisting of nodes...",
  "tags": ["Tree", "Unit 2"],
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Note created successfully.",
  "data": {
    "note": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "subject_id": "subject-uuid",
      "title": "Data Structures - Binary Trees",
      "content": "Trees are non-linear data structures...",
      "tags": ["Tree", "Unit 2"],
      "is_shared": true,
      "created_at": "2026-11-11T12:00:00.000Z",
      "updated_at": "2026-11-11T12:00:00.000Z"
    }
  }
}
```

### 2. Get Notes
- **Route:** `GET /notes?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Notes retrieved successfully.",
  "data": {
    "notes": []
  }
}
```

### 3. Update Note
- **Route:** `PUT /notes/:id`
- **Access:** Protected

### 4. Delete Note
- **Route:** `DELETE /notes/:id`
- **Access:** Protected

---

## Study Materials Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Study Material
- **Route:** `POST /materials`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "OOP Lecture Slides",
  "fileUrl": "https://example.com/oop.pdf",
  "fileType": "PDF",
  "fileSize": "2.4 MB",
  "isShared": true
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Study material created successfully.",
  "data": {
    "material": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "title": "OOP Lecture Slides",
      "file_type": "PDF",
      "file_size": "2.4 MB"
    }
  }
}
```

### 2. Get Study Materials
- **Route:** `GET /materials?subjectId=:id&filter=all|my|shared`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Materials retrieved successfully.",
  "data": {
    "materials": []
  }
}
```

### 3. Update Study Material
- **Route:** `PUT /materials/:id`
- **Access:** Protected

### 4. Delete Study Material
- **Route:** `DELETE /materials/:id`
- **Access:** Protected


---

## Assignments Endpoints

All endpoints require `Authorization: Bearer <token>`.

### 1. Create Assignment
- **Route:** `POST /assignments`
- **Access:** Protected
- **Request Body:**
```json
{
  "subjectId": "uuid-optional",
  "title": "DBMS Assignment",
  "description": "ER diagrams and normalization exercises",
  "dueDate": "2025-09-12T18:00:00.000Z",
  "isSubmitted": false
}
```
- **Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Assignment created successfully.",
  "data": {
    "assignment": {
      "id": "uuid-here",
      "user_id": "user-uuid",
      "subject_id": "subject-uuid",
      "title": "DBMS Assignment",
      "description": "ER diagrams and normalization exercises",
      "due_date": "2025-09-12T18:00:00.000Z",
      "is_submitted": false,
      "submitted_at": null,
      "created_at": "2026-11-11T12:00:00.000Z",
      "updated_at": "2026-11-11T12:00:00.000Z"
    }
  }
}
```

### 2. Get Assignments
- **Route:** `GET /assignments?subjectId=:id&filter=all|upcoming|completed`
- **Access:** Protected
- **Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Assignments retrieved successfully.",
  "data": {
    "assignments": []
  }
}
```

### 3. Update Assignment
- **Route:** `PUT /assignments/:id`
- **Access:** Protected

### 4. Toggle Assignment Submission Status
- **Route:** `PATCH /assignments/:id/toggle`
- **Access:** Protected

### 5. Delete Assignment
- **Route:** `DELETE /assignments/:id`
- **Access:** Protected
