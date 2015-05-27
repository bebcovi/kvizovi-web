import 'fontfaceobserver';

new FontFaceObserver('Open Sans')
  .check()
  .then(function () {
    document.documentElement.classList.add('wf-actually-active');
  });
