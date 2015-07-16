import browserSync from 'browser-sync';

export const dev = browserSync.create('dev');
export const prod = browserSync.create('prod');
