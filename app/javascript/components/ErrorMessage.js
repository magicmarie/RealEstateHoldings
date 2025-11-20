import React from 'react';
import { COLORS } from './constants';

const ErrorMessage = ({ message }) => {
  if (!message) return null;
  
  return (
    <div style={{
      padding: '12px',
      marginBottom: '16px',
      backgroundColor: COLORS.dangerBg,
      color: COLORS.danger,
      borderRadius: '4px'
    }}>
      {message}
    </div>
  );
};

export default ErrorMessage;
