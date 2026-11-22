(function(){
/**
 * patches/web_optimizations/taps.js - kill the 300ms double-tap delay.
 */
'use strict';

function installTaps(doc) {
  try {
    var style = doc.createElement('style');
    style.setAttribute('data-agy', 'web-optimizations');
    style.textContent =
      'button,a,[role="button"],input,select,textarea{touch-action:manipulation;}';
    (doc.head || doc.documentElement).appendChild(style);
  } catch (e) {}
}

/**
 * patches/web_optimizations/viewport.js - keep --agy-vvh honest while the
 * soft keyboard opens.
 */
function installViewport(global, doc) {
  try {
    if (global.visualViewport) {
      global.visualViewport.addEventListener('resize', function () {
        var vv = global.visualViewport;
        if (vv && vv.height && doc.documentElement) {
          doc.documentElement.style.setProperty(
            '--agy-vvh', Math.round(vv.height) + 'px');
        }
      }, { passive: true });
    }
  } catch (e) {}
}

/**
 * patches/web_optimizations/gpu.js - GPU-accelerate scroll/animation surfaces,
 * enable 120Hz/144Hz high-refresh buttery smooth transitions, and optimize layout containment.
 */
function installGpu(doc) {
  try {
    if (!doc.querySelector('style[data-agy="gpu-acceleration"]')) {
      var gpu = doc.createElement('style');
      gpu.setAttribute('data-agy', 'gpu-acceleration');
      gpu.textContent =
        ':root {' +
        '  --agy-spring: cubic-bezier(0.16, 1, 0.3, 1);' +
        '  --agy-smooth: cubic-bezier(0.2, 0.8, 0.2, 1);' +
        '}' +
        'main, [data-testid="chat-container"], .scrollable, #root, body {' +
        '  transform: translateZ(0);' +
        '  -webkit-overflow-scrolling: touch;' +
        '  scroll-behavior: smooth;' +
        '  backface-visibility: hidden;' +
        '}' +
        '[role="listitem"], .message-row, .artifact-viewer, [data-testid="chat-message"] {' +
        '  contain: layout style;' +
        '  content-visibility: auto;' +
        '}' +
        '*{ -webkit-tap-highlight-color: transparent; }' +
        'button, a, [role="button"], input, select, textarea {' +
        '  touch-action: manipulation;' +
        '  transition: background-color 180ms var(--agy-smooth), border-color 180ms var(--agy-smooth), color 180ms var(--agy-smooth), box-shadow 180ms var(--agy-smooth), transform 120ms var(--agy-spring), opacity 180ms var(--agy-smooth);' +
        '}' +
        'button:active, [role="button"]:active {' +
        '  transform: scale(0.972);' +
        '}' +
        '[role="menu"], [role="dialog"], [data-radix-popper-content-wrapper], .touch-model-menu {' +
        '  animation: agy-pop-in 200ms var(--agy-spring) forwards;' +
        '  will-change: transform, opacity;' +
        '}' +
        '@keyframes agy-pop-in {' +
        '  0% { opacity: 0; transform: scale(0.96) translateY(5px); }' +
        '  100% { opacity: 1; transform: scale(1) translateY(0); }' +
        '}' +
        '[data-sidebar], .sidebar-panel, aside {' +
        '  transition: transform 260ms var(--agy-spring), opacity 260ms var(--agy-smooth);' +
        '  will-change: transform;' +
        '}' +
        '@keyframes agy-fade-in {' +
        '  0% { opacity: 0; transform: translateY(4px); }' +
        '  100% { opacity: 1; transform: translateY(0); }' +
        '}';
      (doc.head || doc.documentElement).appendChild(gpu);
    }
  } catch (e) {}
}

/**
 * patches/web_optimizations/public-api.js - install and expose.
 */
var global = window;

if (global.__AG_WEB_OPTIMIZATIONS__) return;
global.__AG_WEB_OPTIMIZATIONS__ = true;

var doc = global.document;
if (!doc) return;

installTaps(doc);
installViewport(global, doc);
installGpu(doc);

global.__agWebOptimizations = { installed: true };


})();
