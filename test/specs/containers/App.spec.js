import React from 'react';
import { shallow } from 'enzyme';
import expect from 'expect';
import App from 'containers/App';

describe('<App>', () => {
  it('greets the world', () => {
    const wrapper = shallow(<App />);
    expect(wrapper.find('h1').text()).toBe('Hello World!');
  });
});
