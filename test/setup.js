const jsdom = require('jsdom').jsdom;
global.document = jsdom('<!doctype html><html><body></body></html>');
global.window = global.document.defaultView;
global.navigator = global.window.navigator;

// set globally instead of requiring in each file
global.React = require('react');
global.expect = require('expect');
global.expect.extend(require('expect-jsx'));
global.enzyme = require('enzyme');
global.shallow = global.enzyme.shallow;
global.mount = global.enzyme.mount;
global.render = global.enzyme.render;
