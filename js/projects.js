/**
 * Visitor-Facing Projects Renderer
 * Consumes static project data from data/projects.js
 * Ahmed Mahamud Ahmed Portfolio
 */

let activeFilter = 'All';

function renderVisitorProjects() {
  const gridContainer = document.getElementById('projects-grid');
  if (!gridContainer) return;

  if (typeof PROJECTS_DATA === 'undefined' || !Array.isArray(PROJECTS_DATA)) {
    gridContainer.innerHTML = `<div class="card"><p>Unable to load projects dataset.</p></div>`;
    return;
  }

  const filtered = activeFilter === 'All'
    ? PROJECTS_DATA
    : PROJECTS_DATA.filter(p => {
        const techs = (p.technologies || []).map(t => t.toLowerCase());
        const cat = (p.category || '').toLowerCase();
        const searchTag = activeFilter.toLowerCase();
        return cat.includes(searchTag) || techs.some(t => t.includes(searchTag));
      });

  if (filtered.length === 0) {
    gridContainer.innerHTML = `
      <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem;" class="card">
        <h3 style="margin-bottom: 0.5rem; color: var(--text-primary);">No Projects Found</h3>
        <p style="color: var(--text-secondary);">No projects match the selected technology filter: "${activeFilter}".</p>
      </div>`;
    return;
  }

  gridContainer.innerHTML = filtered.map(project => `
    <article class="card reveal active" id="card-${project.id}">
      <div class="card-img-container">
        <img src="${project.image || 'assets/images/projects/project1.svg'}" alt="${project.title}" class="card-img" />
      </div>
      <h3 class="card-title">${project.title}</h3>
      <p class="card-desc">${project.description}</p>
      <div class="card-tags">
        ${(project.technologies || []).map(t => `<span class="tech-tag">${t}</span>`).join('')}
      </div>
      <div class="card-actions">
        <div style="display: flex; gap: 0.5rem; width: 100%;">
          ${project.githubUrl ? `
            <a href="${project.githubUrl}" target="_blank" rel="noopener" class="btn btn-secondary btn-sm" style="flex: 1; text-align: center;" title="View Repository on GitHub">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle; margin-right: 4px;"><path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path></svg>
              View Code
            </a>` : ''}
          ${project.liveUrl ? `
            <a href="${project.liveUrl}" target="_blank" rel="noopener" class="btn btn-primary btn-sm" style="flex: 1; text-align: center;" title="View Live Demo">
              Live Demo ↗
            </a>` : ''}
        </div>
      </div>
    </article>
  `).join('');
}

function initProjectFilters() {
  const filterBtns = document.querySelectorAll('.project-filter-btn');
  filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      filterBtns.forEach(b => {
        b.classList.remove('active', 'btn-primary');
        b.classList.add('btn-secondary');
      });
      
      btn.classList.remove('btn-secondary');
      btn.classList.add('active', 'btn-primary');
      
      activeFilter = btn.getAttribute('data-filter') || 'All';
      renderVisitorProjects();
    });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  renderVisitorProjects();
  initProjectFilters();
});
