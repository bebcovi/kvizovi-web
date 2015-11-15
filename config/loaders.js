import { resolve } from 'path';

export const style = {
  modules: {
    test: /\.s?css$/,
    include: [
      resolve('./src/styles'),
      /flexboxgrid/,
      /react-toolbox/,
    ],
    exclude: resolve('./src/styles/global'),
  },
  global: {
    test: /\.s?css$/,
    include: [
      resolve('./src/styles/global'),
      resolve('./node_modules'),
    ],
    exclude: [
      /flexboxgrid/,
      /react-toolbox/,
    ],
  },
};
