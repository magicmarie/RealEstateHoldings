// Entry point for the build script in your package.json
import React from 'react';
import ReactDOM from 'react-dom';
import BuildingApp from './components/BuildingApp';

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('react-root');
  if (node) {
    ReactDOM.render(<BuildingApp />, node);
  }
});
