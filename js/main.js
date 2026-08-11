/**
 * Main Application Logic
 * Mobile Navigation, Scroll Observer, Contact Form Validation & Toasts
 * Ahmed Mahamud Ahmed Portfolio
 */

// Toast Notification Utility
window.showToast = function(message, type = 'info') {
  let toastContainer = document.querySelector('.toast-container');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.className = 'toast-container';
    document.body.appendChild(toastContainer);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  
  const icon = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
  toast.innerHTML = `<span style="font-weight:bold;">${icon}</span> <span>${message}</span>`;
  
  toastContainer.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    toast.style.transition = 'all 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 4000);
};

document.addEventListener('DOMContentLoaded', () => {
  // 1. Mobile Menu Drawer Functionality
  const mobileToggleBtn = document.querySelector('.mobile-toggle-btn');
  const mobileOverlay = document.querySelector('.mobile-menu-overlay');
  const mobileCloseBtn = document.querySelector('.mobile-drawer-close');

  function openMobileMenu() {
    if (mobileOverlay) mobileOverlay.classList.add('is-active');
  }

  function closeMobileMenu() {
    if (mobileOverlay) mobileOverlay.classList.remove('is-active');
  }

  if (mobileToggleBtn) mobileToggleBtn.addEventListener('click', openMobileMenu);
  if (mobileCloseBtn) mobileCloseBtn.addEventListener('click', closeMobileMenu);
  if (mobileOverlay) {
    mobileOverlay.addEventListener('click', (e) => {
      if (e.target === mobileOverlay) closeMobileMenu();
    });
  }

  // 2. Active Link Highlighting based on current page
  const currentPath = window.location.pathname.split('/').pop() || 'index.html';
  const navLinks = document.querySelectorAll('.nav-link, .mobile-nav-link');
  
  navLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPath || (currentPath === '' && href === 'index.html')) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });

  // 3. Scroll Reveal IntersectionObserver
  const revealElements = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('active');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.1 });

    revealElements.forEach(el => observer.observe(el));
  } else {
    revealElements.forEach(el => el.classList.add('active'));
  }

  // 4. Contact Form Validation & Mailto Action
  const contactForm = document.getElementById('contact-form');
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();
      
      let isValid = true;
      const nameInput = document.getElementById('contact-name');
      const emailInput = document.getElementById('contact-email');
      const subjectInput = document.getElementById('contact-subject');
      const messageInput = document.getElementById('contact-message');

      function setError(input, msg) {
        const group = input.closest('.form-group');
        if (group) {
          group.classList.add('has-error');
          let errorEl = group.querySelector('.form-error-msg');
          if (!errorEl) {
            errorEl = document.createElement('span');
            errorEl.className = 'form-error-msg';
            group.appendChild(errorEl);
          }
          errorEl.textContent = msg;
        }
        isValid = false;
      }

      function clearError(input) {
        const group = input.closest('.form-group');
        if (group) {
          group.classList.remove('has-error');
        }
      }

      if (!nameInput.value.trim()) {
        setError(nameInput, 'Full Name is required.');
      } else {
        clearError(nameInput);
      }

      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailInput.value.trim()) {
        setError(emailInput, 'Email Address is required.');
      } else if (!emailRegex.test(emailInput.value.trim())) {
        setError(emailInput, 'Please enter a valid email address.');
      } else {
        clearError(emailInput);
      }

      if (!subjectInput.value.trim()) {
        setError(subjectInput, 'Subject is required.');
      } else {
        clearError(subjectInput);
      }

      if (!messageInput.value.trim()) {
        setError(messageInput, 'Message content is required.');
      } else if (messageInput.value.trim().length < 10) {
        setError(messageInput, 'Message should be at least 10 characters long.');
      } else {
        clearError(messageInput);
      }

      if (isValid) {
        const successBox = document.getElementById('contact-success-box');
        if (successBox) {
          successBox.style.display = 'block';
          successBox.scrollIntoView({ behavior: 'smooth' });
        }
        
        window.showToast('Thank you! Your message has been prepared.', 'success');
        
        const mailtoSubject = encodeURIComponent(`[Portfolio Contact] ${subjectInput.value}`);
        const mailtoBody = encodeURIComponent(`Name: ${nameInput.value}\nEmail: ${emailInput.value}\n\nMessage:\n${messageInput.value}`);
        
        const mailtoBtn = document.getElementById('btn-mailto-fallback');
        if (mailtoBtn) {
          mailtoBtn.href = `mailto:ahmed.mahamud.dba@example.com?subject=${mailtoSubject}&body=${mailtoBody}`;
        }
        
        contactForm.reset();
      }
    });
  }
});
