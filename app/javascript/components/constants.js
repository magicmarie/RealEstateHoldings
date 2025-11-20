// API Configuration
export const API_BASE_URL = '/api/v1';

// Color Palette
export const COLORS = {
  primary: '#007bff',
  success: '#28a745',
  secondary: '#6c757d',
  danger: '#721c24',
  dangerBg: '#f8d7da',
  lightGray: '#f8f9fa',
  mediumGray: '#666',
  border: '#ddd',
  lightBorder: '#eee',
  inputBorder: '#ccc',
  white: '#fff',
  disabled: '#ccc'
};

// Common Styles
export const COMMON_STYLES = {
  input: {
    width: '100%',
    padding: '8px',
    borderRadius: '4px',
    border: `1px solid ${COLORS.inputBorder}`
  },
  button: {
    padding: '10px 20px',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer',
    fontWeight: 'bold'
  },
  buttonSmall: {
    padding: '8px 16px',
    color: 'white',
    border: 'none',
    borderRadius: '4px',
    cursor: 'pointer'
  },
  card: {
    border: `1px solid ${COLORS.border}`,
    borderRadius: '8px',
    padding: '16px',
    marginBottom: '16px',
    backgroundColor: COLORS.white
  },
  formContainer: {
    border: `2px solid ${COLORS.primary}`,
    borderRadius: '8px',
    padding: '20px',
    marginBottom: '24px',
    backgroundColor: COLORS.lightGray
  },
  label: {
    display: 'block',
    marginBottom: '4px',
    fontWeight: 'bold'
  },
  formField: {
    marginBottom: '12px'
  }
};
