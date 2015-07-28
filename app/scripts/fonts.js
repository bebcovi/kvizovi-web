/*global FontFaceObserver*/

import 'fontfaceobserver';

new FontFaceObserver('Roboto')
  .check()
  .then(function () {
    document.documentElement.classList.add('wf-actually-active');
  });
