const db = require('../config/database');
const SubjectModel = require('../models/subjectModel');
const NoteModel = require('../models/noteModel');
const MaterialModel = require('../models/materialModel');
const AssignmentModel = require('../models/assignmentModel');
const QuestionModel = require('../models/questionModel');

function getStarterBranchData(department, semester) {
  const sem = semester ? Number(semester) : 4;
  const dept = (department || '').trim();
  const lowerDept = dept.toLowerCase();

  if (lowerDept.includes('mech')) {
    return {
      department: dept || 'Mechanical Engineering',
      semester: sem,
      subjects: [
        { name: 'Thermodynamics', code: 'ME201', description: 'Laws of thermodynamics, heat engines, and entropy', color: '#DC2626', icon: 'calculate' },
        { name: 'Fluid Mechanics', code: 'ME202', description: 'Fluid statics, dynamics, Bernoulli theorem, and pipe flow', color: '#1E3A8A', icon: 'waves' },
        { name: 'Strength of Materials', code: 'ME203', description: 'Stress, strain, bending moments, and torsion', color: '#0F5132', icon: 'construction' },
        { name: 'Theory of Machines', code: 'ME204', description: 'Kinematic pairs, gear trains, and vibrations', color: '#D97706', icon: 'settings' },
        { name: 'Manufacturing Processes', code: 'ME205', description: 'Casting, machining, welding, and metallurgy', color: '#0D9488', icon: 'precision_manufacturing' },
      ],
      question: {
        question: 'Explain the Second Law of Thermodynamics and Clausius inequality.',
        answer: 'No process is possible whose sole result is the transfer of heat from a cooler body to a hotter body. Clausius inequality: cycle integral of dQ/T <= 0.',
      },
      note: {
        title: 'Thermodynamics Fundamentals',
        content: 'First law: Delta U = Q - W. For an adiabatic process, Q = 0.',
        tags: ['Thermodynamics', 'Unit 1', 'Revision'],
      },
      assignment: {
        title: 'Heat Engine Cycles Assignment',
        description: 'Calculate Otto and Diesel cycle thermal efficiencies with diagrams.',
      },
    };
  } else if (lowerDept.includes('elect') || lowerDept.includes('ece') || lowerDept.includes('eee')) {
    return {
      department: dept || 'Electrical Engineering',
      semester: sem,
      subjects: [
        { name: 'Circuit Theory', code: 'EE201', description: 'Network theorems, AC analysis, and resonance', color: '#1E3A8A', icon: 'bolt' },
        { name: 'Digital Electronics', code: 'EC202', description: 'Logic gates, flip-flops, counters, and registers', color: '#0F5132', icon: 'memory' },
        { name: 'Signals and Systems', code: 'EC203', description: 'Fourier transform, Laplace transform, and LTI systems', color: '#D97706', icon: 'graphic_eq' },
        { name: 'Control Systems', code: 'EE204', description: 'Transfer functions, Bode plots, and system stability', color: '#7C3AED', icon: 'settings_input_component' },
        { name: 'Microprocessors', code: 'EC205', description: '8085/8086 architecture, assembly language, and interfacing', color: '#0D9488', icon: 'developer_board' },
      ],
      question: {
        question: 'Explain Thevenin and Norton theorems in Circuit Theory.',
        answer: 'Thevenin states any linear two-terminal circuit can be replaced by an equivalent voltage source Vth in series with Rth. Norton uses In in parallel with Rn.',
      },
      note: {
        title: 'Digital Electronics Basics',
        content: 'De Morgan laws: (A + B)\' = A\' . B\' and (A . B)\' = A\' + B\'.',
        tags: ['Digital Electronics', 'Logic', 'Unit 2'],
      },
      assignment: {
        title: 'Filter Design Assignment',
        description: 'Design active low-pass and high-pass Butterworth filters with simulation.',
      },
    };
  } else if (lowerDept.includes('civil')) {
    return {
      department: dept || 'Civil Engineering',
      semester: sem,
      subjects: [
        { name: 'Structural Analysis', code: 'CE201', description: 'Determinate and indeterminate structures, shear force, and bending moments', color: '#0F5132', icon: 'foundation' },
        { name: 'Surveying', code: 'CE202', description: 'Leveling, theodolite, and total station surveying', color: '#D97706', icon: 'explore' },
        { name: 'Fluid Mechanics', code: 'CE203', description: 'Fluid properties, pipe flow, and open channel flow', color: '#1E3A8A', icon: 'waves' },
        { name: 'Building Materials', code: 'CE204', description: 'Cement, concrete technology, and brickwork', color: '#7C3AED', icon: 'domain' },
        { name: 'Geotechnical Engineering', code: 'CE205', description: 'Soil mechanics, permeability, and foundation design', color: '#0D9488', icon: 'terrain' },
      ],
      question: {
        question: 'What are the main assumptions in Euler Bernoulli beam bending theory?',
        answer: 'Plane sections remain plane after bending, material is isotropic and obeys Hooke law, and radius of curvature is large.',
      },
      note: {
        title: 'Concrete Mix Design',
        content: 'Water-cement ratio determines compressive strength. Target mean strength = fck + 1.65 s.',
        tags: ['Concrete', 'Mix Design', 'Unit 3'],
      },
      assignment: {
        title: 'Surveying Traverse Calculation',
        description: 'Compute latitudes, departures, and closing error of closed traverse.',
      },
    };
  } else {
    return {
      department: dept || 'Computer Science',
      semester: sem,
      subjects: [
        { name: 'DSA', code: 'CS201', description: 'Data Structures and Algorithms in Java & C++', color: '#0F5132', icon: 'account_tree' },
        { name: 'Database', code: 'CS202', description: 'Relational database management & SQL queries', color: '#1E3A8A', icon: 'storage' },
        { name: 'Web Development', code: 'CS203', description: 'HTML5, CSS3, Modern JavaScript & Node.js', color: '#D97706', icon: 'language' },
        { name: 'Java', code: 'CS204', description: 'Object-Oriented Programming and JVM internals', color: '#DC2626', icon: 'code' },
        { name: 'Android', code: 'CS205', description: 'Native Android application development with Kotlin', color: '#16A34A', icon: 'android' },
      ],
      question: {
        question: 'DBMS Important Questions: Explain 1NF, 2NF, 3NF and BCNF normalization.',
        answer: '1NF eliminates repeating groups. 2NF removes partial dependencies. 3NF eliminates transitive dependencies. BCNF requires every determinant to be a candidate key.',
      },
      note: {
        title: 'DBMS Revision Notes',
        content: 'Database Management Systems summary: ACID properties ensure Atomicity, Consistency, Isolation, and Durability across concurrent transactions.',
        tags: ['DBMS', 'SQL', 'Unit 3'],
      },
      assignment: {
        title: 'DBMS Assignment',
        description: 'Draw ER diagram and schema normalization exercises',
      },
    };
  }
}

async function seedUserData(userId, department, semester) {
  try {
    const branchData = getStarterBranchData(department, semester);
    const createdSubs = [];

    // 1. Create Default Subjects for student's department
    for (const sub of branchData.subjects) {
      const created = await SubjectModel.create({
        userId,
        name: sub.name,
        code: sub.code,
        description: sub.description,
        semester: branchData.semester,
        department: branchData.department,
        color: sub.color,
        icon: sub.icon,
      });
      createdSubs.push(created);
    }

    const sub1 = createdSubs[0] || null;
    const sub2 = createdSubs[1] || sub1;
    const sub3 = createdSubs[2] || sub1;

    // 2. Create Sample Questions
    if (sub2) {
      await QuestionModel.create({
        userId,
        subjectId: sub2.id,
        question: branchData.question.question,
        answer: branchData.question.answer,
        isStarred: true,
        isShared: true,
      });
    }

    if (sub1) {
      await QuestionModel.create({
        userId,
        subjectId: sub1.id,
        question: `${sub1.name} Core Concepts: Describe the foundational principles and key formulas.`,
        answer: `Review foundational concepts for ${sub1.name}. Focus on core definitions, theorems, and real-world engineering applications.`,
        isStarred: true,
        isShared: true,
      });
    }

    // 3. Create Sample Notes
    if (sub1) {
      await NoteModel.create({
        userId,
        subjectId: sub1.id,
        title: `${sub1.name} Notes`,
        content: `Comprehensive overview of ${sub1.name}. Key principles, important problem solving steps, and unit summary.`,
        tags: [sub1.name, 'Core', 'Revision'],
        isShared: true,
      });
    }

    if (sub2) {
      await NoteModel.create({
        userId,
        subjectId: sub2.id,
        title: branchData.note.title,
        content: branchData.note.content,
        tags: branchData.note.tags,
        isShared: true,
      });
    }

    if (sub3) {
      await NoteModel.create({
        userId,
        subjectId: sub3.id,
        title: `${sub3.name} Quick Reference`,
        content: `Summary sheet and quick reference formula sheet for ${sub3.name}.`,
        tags: [sub3.name, 'CheatSheet'],
        isShared: false,
      });
    }

    // 4. Create Sample Study Materials
    if (sub1) {
      await MaterialModel.create({
        userId,
        subjectId: sub1.id,
        title: `${sub1.name} Lecture Slides`,
        fileUrl: 'https://campusflow.app/samples/notes.pdf',
        fileType: 'PDF',
        fileSize: '2.4 MB',
        isShared: true,
      });
    }

    if (sub2) {
      await MaterialModel.create({
        userId,
        subjectId: sub2.id,
        title: `${sub2.name} Reference Notes`,
        fileUrl: 'https://campusflow.app/samples/reference.pdf',
        fileType: 'PDF',
        fileSize: '1.2 MB',
        isShared: true,
      });
    }

    // 5. Create Sample Assignments
    const dueDate1 = new Date();
    dueDate1.setDate(dueDate1.getDate() + 3);

    const dueDate2 = new Date();
    dueDate2.setDate(dueDate2.getDate() + 7);

    if (sub2) {
      await AssignmentModel.create({
        userId,
        subjectId: sub2.id,
        title: branchData.assignment.title,
        description: branchData.assignment.description,
        dueDate: dueDate1,
        isSubmitted: false,
      });
    }

    if (sub1) {
      await AssignmentModel.create({
        userId,
        subjectId: sub1.id,
        title: `${sub1.name} Assignment 1`,
        description: `Complete numerical problems and conceptual review questions for Unit 1.`,
        dueDate: dueDate2,
        isSubmitted: false,
      });
    }

    console.log(`Successfully seeded starter data for user ${userId} (${branchData.department})`);
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

