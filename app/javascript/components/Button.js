import React from 'react';
import { COLORS, COMMON_STYLES } from './constants';

const Button = ({ 
  children, 
  onClick, 
  type = 'button', 
  variant = 'primary', 
  disabled = false,
  size = 'medium'
}) => {
  const variantColors = {
    primary: COLORS.primary,
    success: COLORS.success,
    secondary: COLORS.secondary
  };

  const baseStyle = size === 'small' ? COMMON_STYLES.buttonSmall : COMMON_STYLES.button;

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled}
      style={{
        ...baseStyle,
        backgroundColor: disabled ? COLORS.disabled : variantColors[variant],
        cursor: disabled ? 'not-allowed' : 'pointer'
      }}
    >
      {children}
    </button>
  );
};

export default Button;
