# Ahmed Mahamud Ahmed - Personal Portfolio

A modern, premium, fully responsive personal portfolio website for **Ahmed Mahamud Ahmed** (Cloud Database Administrator | PostgreSQL | SQL Server | Database Security | Research, Monitoring & Evaluation).

---

## Portfolio Architecture & Principles
- **Visitor-Facing Presentation**: Visitors only see clean, published content. No upload buttons, edit triggers, delete icons, modal forms, or admin controls are visible.
- **Backend-Free Static Stack**: 100% standard HTML5, CSS3, and Vanilla JavaScript. Zero database, zero CMS, zero backend tokens.
- **4 Main Pages**:
  1. `index.html` (Home)
  2. `about.html` (About)
  3. `projects.html` (Projects)
  4. `contact.html` (Contact)

---

## Directory & Asset Structure
```
/
├── index.html            # Home page
├── about.html            # About page
├── projects.html         # Projects page
├── contact.html          # Contact page
│
├── data/
│   └── projects.js       # Static project data array (Title, Description, Image, Tech, GitHub Link)
│
├── css/
│   └── style.css         # Global design system, light & dark mode variables, glassmorphism
│
├── js/
│   ├── theme.js          # Dark/Light theme switcher with localStorage persistence
│   ├── projects.js       # Static project card renderer and tag filtering logic
│   └── main.js           # Navigation drawer, scroll reveal observer & contact form validation
│
├── assets/
│   └── images/
│       ├── profile/      # Profile picture assets (e.g., profile-default.svg)
│       └── projects/     # Project cover image assets (project1.svg - project6.svg)
│
└── README.md             # Developer & deployment documentation
```

---

## How to Add or Update Projects (Developer Workflow)

When you want to add a new project to your portfolio:

1. **Add Project Image**: Place your project cover image (e.g. `my-new-project.png`) into `assets/images/projects/`.
2. **Update Dataset**: Open `data/projects.js` and add a new project entry:
   ```javascript
   {
     id: 'p-07',
     title: 'My New High-Availability Database Project',
     description: 'A brief summary of your project goals, tech stack, and results.',
     image: 'assets/images/projects/my-new-project.png',
     technologies: ['PostgreSQL', 'Docker', 'Python', 'Monitoring'],
     githubUrl: 'https://github.com/Garjoox/your-repo-name',
     liveUrl: '', // Optional Live demo URL
     category: 'PostgreSQL'
   }
   ```
3. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Add new project to portfolio"
   git push origin main
   ```
4. **Automatic Redeployment**: Vercel (or your static host) will automatically detect the commit and deploy your updated portfolio in seconds!

---

## Features
- **Light & Dark Theme Switcher**: Toggle button in the header navbar smoothly switches between themes and saves user preference in `localStorage`.
- **Direct GitHub Repo Links**: Each project card links directly to your public GitHub repository.
- **Technology Tag Filters**: Filter projects on `projects.html` by PostgreSQL, SQL Server, Cloud, Security & DR, or M&E.
- **Responsive & Performant**: Lightweight, fast load time, and mobile drawer menu.
