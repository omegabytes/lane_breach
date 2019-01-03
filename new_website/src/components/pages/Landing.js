import React from "react";
import styled from "styled-components";
import Map from "../map";

const Padding = styled.div`
  padding: 20px;
`;

const Landing = () => (
  <Padding>
    <h1>Let's get cars out of bike lanes.</h1>
    <Map />
  </Padding>
);

export default Landing;
