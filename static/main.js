// Mobile menu toggle
const menuBtn = document.getElementById("menuToggle");
const nav = document.getElementById("nav");
if (menuBtn) {
  menuBtn.addEventListener("click", () => {
    nav.classList.toggle("open");
  });
}

// Theme toggle (light/dark) with persistence
const themeToggle = document.getElementById("themeToggle");
const root = document.documentElement;

const savedTheme = localStorage.getItem("theme");
if (savedTheme) {
  document.documentElement.setAttribute("data-theme", savedTheme);
}

if (themeToggle) {
  themeToggle.addEventListener("click", () => {
    const current = root.getAttribute("data-theme") || "dark";
    const next = current === "dark" ? "light" : "dark";
    root.setAttribute("data-theme", next);
    localStorage.setItem("theme", next);
  });
}

// Fake submit for demo
function fakeSubmit() {
  const s = document.getElementById("formStatus");
  if (s) {
    s.textContent = "Thanks! This demo form doesn't send messages yet.";
  }
}
window.fakeSubmit = fakeSubmit;
