/**
 * Static Projects Dataset
 * Ahmed Mahamud Ahmed - Personal Portfolio
 * 
 * To add or update projects:
 * 1. Add your project cover image to assets/images/projects/
 * 2. Add an entry object below with title, description, image, technologies, githubUrl, and liveUrl
 * 3. Commit and push to GitHub (Vercel will redeploy automatically)
 */

const PROJECTS_DATA = [
  {
    id: 'p-01',
    title: 'PostgreSQL Database Administration Lab',
    description: 'A practical PostgreSQL environment focused on database administration, user and role management, permissions, backup and recovery, indexing, monitoring, and performance optimization.',
    image: 'assets/images/projects/project1.svg',
    technologies: ['PostgreSQL', 'Linux', 'SQL', 'Database Administration'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'PostgreSQL'
  },
  {
    id: 'p-02',
    title: 'SQL Server Database Management',
    description: 'A SQL Server database environment demonstrating database design, SSMS administration, security management, stored procedures, indexing, backup strategies, and performance monitoring.',
    image: 'assets/images/projects/project2.svg',
    technologies: ['SQL Server', 'SSMS', 'T-SQL', 'Database Security'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'SQL Server'
  },
  {
    id: 'p-03',
    title: 'Database Backup & Recovery System',
    description: 'A database backup and recovery project designed around reliable backup strategies, recovery procedures, disaster recovery planning, and data protection.',
    image: 'assets/images/projects/project3.svg',
    technologies: ['PostgreSQL', 'SQL Server', 'Backup & Recovery', 'Automation'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'Security'
  },
  {
    id: 'p-04',
    title: 'Database Performance Optimization',
    description: 'A performance optimization project focused on identifying slow queries, analyzing execution plans, improving indexes, optimizing SQL queries, and monitoring database performance.',
    image: 'assets/images/projects/project4.svg',
    technologies: ['SQL', 'PostgreSQL', 'SQL Server', 'Query Optimization'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'PostgreSQL'
  },
  {
    id: 'p-05',
    title: 'Cloud Database Infrastructure',
    description: 'A cloud database architecture concept demonstrating secure and scalable database infrastructure, cloud storage, networking, monitoring, and database management.',
    image: 'assets/images/projects/project5.svg',
    technologies: ['Cloud', 'Azure', 'PostgreSQL', 'SQL Server', 'Docker'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'Cloud'
  },
  {
    id: 'p-06',
    title: 'Research Monitoring & Evaluation System',
    description: 'A data-driven research and monitoring concept designed to support research activities, indicators, data collection, monitoring, evaluation, reporting, and evidence-based decision making.',
    image: 'assets/images/projects/project6.svg',
    technologies: ['Research', 'Monitoring & Evaluation', 'Data Analysis', 'SQL'],
    githubUrl: 'https://github.com/Garjoox/Ahmed-mohamud',
    liveUrl: '',
    category: 'M&E'
  }
];
