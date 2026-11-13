const db = require('../config/database');
const SubjectModel = require('../models/subjectModel');
const NoteModel = require('../models/noteModel');
const MaterialModel = require('../models/materialModel');
const AssignmentModel = require('../models/assignmentModel');
const QuestionModel = require('../models/questionModel');

async function seedUserData(userId) {
  try {
    // 1. Create Default Subjects (Matches Screen 13 & 17 mockup)
    const dsa = await SubjectModel.create({
      userId,
      name: 'DSA',
      code: 'CS201',
      description: 'Data Structures and Algorithms in Java & C++',
      semester: 4,
      department: 'Computer Science',
      color: '#0F5132',
      icon: 'account_tree',
    });

    const dbms = await SubjectModel.create({
      userId,
      name: 'Database',
      code: 'CS202',
      description: 'Relational database management & SQL queries',
      semester: 4,
      department: 'Computer Science',
      color: '#1E3A8A',
      icon: 'storage',
    });

    const webDev = await SubjectModel.create({
      userId,
      name: 'Web Development',
      code: 'CS203',
      description: 'HTML5, CSS3, Modern JavaScript & Node.js',
      semester: 4,
      department: 'Computer Science',
      color: '#D97706',
      icon: 'language',
    });

    const java = await SubjectModel.create({
      userId,
      name: 'Java',
      code: 'CS204',
      description: 'Object-Oriented Programming and JVM internals',
      semester: 4,
      department: 'Computer Science',
      color: '#DC2626',
      icon: 'code',
    });

    const android = await SubjectModel.create({
      userId,
      name: 'Android',
      code: 'CS205',
      description: 'Native Android application development with Kotlin',
      semester: 4,
      department: 'Computer Science',
      color: '#16A34A',
      icon: 'android',
    });

    // 2. Create Sample Questions (Matches Screen 7, 9 & 14)
    await QuestionModel.create({
      userId,
      subjectId: dbms.id,
      question: 'DBMS Important Questions: Explain 1NF, 2NF, 3NF and BCNF normalization.',
      answer: '1NF eliminates repeating groups. 2NF removes partial dependencies. 3NF eliminates transitive dependencies. BCNF requires every determinant to be a candidate key.',
      isStarred: true,
      isShared: true,
    });

    await QuestionModel.create({
      userId,
      subjectId: dsa.id,
      question: 'DSA Important Questions: What is time complexity of QuickSort best, average, and worst case?',
      answer: 'Best case: O(n log n), Average case: O(n log n), Worst case: O(n^2) when the pivot choice is the extreme element.',
      isStarred: true,
      isShared: true,
    });

    // 3. Create Sample Notes (Matches Screen 7, 10 & 14)
    await NoteModel.create({
      userId,
      subjectId: dsa.id,
      title: 'Data Structures Notes',
      content: 'Binary Search Trees require left child < root < right child. AVL trees self-balance using single and double rotations with balance factor in {-1, 0, 1}.',
      tags: ['DSA', 'Trees', 'Revision'],
      isShared: true,
    });

    await NoteModel.create({
      userId,
      subjectId: dbms.id,
      title: 'DBMS Revision Notes',
      content: 'Database Management Systems summary: ACID properties ensure Atomicity, Consistency, Isolation, and Durability across concurrent transactions.',
      tags: ['DBMS', 'SQL', 'Unit 3'],
      isShared: true,
    });

    await NoteModel.create({
      userId,
      subjectId: java.id,
      title: 'Java Basics',
      content: 'Core principles of OOP: Encapsulation, Inheritance, Polymorphism, and Abstraction.',
      tags: ['Java', 'OOP'],
      isShared: false,
    });

    // 4. Create Sample Study Materials (Matches Screen 11 & 14)
    await MaterialModel.create({
      userId,
      subjectId: java.id,
      title: 'OOP PPT',
      fileUrl: 'https://campusflow.app/samples/oop.pdf',
      fileType: 'PDF',
      fileSize: '2.4 MB',
      isShared: true,
    });

    await MaterialModel.create({
      userId,
      subjectId: dbms.id,
      title: 'DBMS Notes',
      fileUrl: 'https://campusflow.app/samples/dbms.pdf',
      fileType: 'PDF',
      fileSize: '1.2 MB',
      isShared: true,
    });

    await MaterialModel.create({
      userId,
      subjectId: java.id,
      title: 'Java Cheat Sheet',
      fileUrl: 'https://campusflow.app/samples/java_cheatsheet.pdf',
      fileType: 'PDF',
      fileSize: '1.1 MB',
      isShared: true,
    });

    // 5. Create Sample Assignments (Matches Screen 7 & 12)
    const dueDate1 = new Date();
    dueDate1.setDate(dueDate1.getDate() + 3);

    const dueDate2 = new Date();
    dueDate2.setDate(dueDate2.getDate() + 6);

    const dueDate3 = new Date();
    dueDate3.setDate(dueDate3.getDate() + 10);

    await AssignmentModel.create({
      userId,
      subjectId: dbms.id,
      title: 'DBMS Assignment',
      description: 'Draw ER diagram and schema normalization exercises',
      dueDate: dueDate1,
      isSubmitted: false,
    });

    await AssignmentModel.create({
      userId,
      subjectId: java.id,
      title: 'Java Assignment',
      description: 'Implement polymorphic shapes hierarchy and interfaces',
      dueDate: dueDate2,
      isSubmitted: false,
    });

    await AssignmentModel.create({
      userId,
      subjectId: dsa.id,
      title: 'OOP Assignment',
      description: 'Graph representations and Dijkstra shortest path algorithm',
      dueDate: dueDate3,
      isSubmitted: true,
    });

    console.log(`Successfully seeded starter data for user ${userId}`);
  } catch (error) {
    console.error('Error seeding user data:', error);
  }
}

async function runSeed() {
  try {
    const res = await db.query('SELECT id, email FROM users ORDER BY created_at ASC;');
    if (res.rows.length === 0) {
      console.log('No users found in database. Please register a user first.');
      return;
    }

    for (const user of res.rows) {
      console.log(`Seeding data for user ${user.email} (${user.id})...`);
      await seedUserData(user.id);
    }

    console.log('All seed data inserted successfully.');
  } catch (error) {
    console.error('Seed script failed:', error);
  } finally {
    await db.pool.end();
  }
}

if (require.main === module) {
  runSeed();
}

module.exports = { seedUserData };

