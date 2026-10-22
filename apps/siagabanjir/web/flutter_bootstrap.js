{{flutter_js}}
{{flutter_build_config}}

const retry = document.getElementById('startup-retry');
retry.addEventListener('click', () => window.location.reload());
function startupFailed() {
  if (!document.getElementById('splash')) return;
  document.getElementById('startup-status').textContent =
    'Aplikasi belum dapat dibuka. Coba muat ulang.';
  retry.hidden = false;
}
// Engine downloads can fail before onEntrypointLoaded is called.
window.addEventListener('unhandledrejection', startupFailed);
window.addEventListener('error', startupFailed, true);
_flutter.loader.load({
  onEntrypointLoaded: async (engineInitializer) => {
    try {
      const appRunner = await engineInitializer.initializeEngine();
      await appRunner.runApp();
      document.getElementById('splash')?.remove();
    } catch (error) {
      startupFailed();
    }
  },
}).catch(startupFailed);
