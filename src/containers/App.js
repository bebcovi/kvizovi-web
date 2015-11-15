import React from 'react';
import { Grid, Row, Col } from 'react-flexbox-grid';
import style from '../styles/App.scss';

const App = () => (
  <Grid className={style.container}>
    <Row center="xs">
      <Col>
        <h1>{'Hello World!'}</h1>
      </Col>
    </Row>
  </Grid>
);

export default App;
