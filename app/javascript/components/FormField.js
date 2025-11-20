import React from 'react';
import { COMMON_STYLES } from './constants';

const FormField = ({ 
  label, 
  required = false, 
  children 
}) => {
  return (
    <div style={COMMON_STYLES.formField}>
      <label style={COMMON_STYLES.label}>
        {label} {required && '*'}
      </label>
      {children}
    </div>
  );
};

export default FormField;
