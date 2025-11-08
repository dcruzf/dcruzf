(function(){
  // Inject PyScript runtime as a module so we can set type="module"
  const s = document.createElement('script');
  s.type = 'module';
  s.src = 'https://pyscript.net/releases/2025.8.1/core.js';
  s.defer = true;
  document.head.appendChild(s);
})();
