import App from 'containers/App';

describe('<App>', function () {
  it('greets the world', function () {
    const wrapper = shallow(<App />);
    expect(wrapper.find('h1').text()).toBe('Hello World!');
  });
});
