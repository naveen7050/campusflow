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
