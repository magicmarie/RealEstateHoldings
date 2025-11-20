import React, { useState, useMemo, useCallback } from 'react';
import Button from './Button';
import ErrorMessage from './ErrorMessage';
import FormField from './FormField';
import { API_BASE_URL, COLORS, COMMON_STYLES } from './constants';

const BuildingForm = ({ building, clients, usStates = [], onSave, onCancel }) => {
  const [clientId, setClientId] = useState(building?.client_id || '');
  const [address, setAddress] = useState(building?.address || '');
  const [city, setCity] = useState(building?.city || '');
  const [state, setState] = useState(building?.state || '');
  const [zipCode, setZipCode] = useState(building?.zip_code || '');
  const [customFields, setCustomFields] = useState(building?.custom_fields || {});
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const selectedClient = useMemo(
    () => clients.find(c => c.id === parseInt(clientId)),
    [clients, clientId]
  );
  
  const fieldDefinitions = useMemo(
    () => selectedClient?.custom_field_definitions || [],
    [selectedClient]
  );

  const handleCustomFieldChange = useCallback((fieldName, value) => {
    setCustomFields(prev => ({
      ...prev,
      [fieldName]: value
    }));
  }, []);

  const handleSubmit = useCallback(async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const data = {
      building: {
        client_id: parseInt(clientId),
        address,
        city,
        state,
        zip_code: zipCode,
        custom_fields: customFields
      }
    };

    try {
      const url = building 
        ? `${API_BASE_URL}/buildings/${building.id}`
        : `${API_BASE_URL}/buildings`;
      
      const method = building ? 'PATCH' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.errors?.join(', ') || errorData.error || 'Failed to save');
      }

      onSave();
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [building, clientId, address, city, state, zipCode, customFields, onSave]);

  return (
    <form onSubmit={handleSubmit} style={COMMON_STYLES.formContainer}>
      <h3 style={{ marginTop: 0 }}>{building ? 'Edit Building' : 'Create New Building'}</h3>
      
      <ErrorMessage message={error} />

      <FormField label="Client" required>
        <select
          value={clientId}
          onChange={(e) => setClientId(e.target.value)}
          required
          disabled={!!building}
          style={COMMON_STYLES.input}
        >
          <option value="">Select a client</option>
          {clients.map(client => (
            <option key={client.id} value={client.id}>{client.name}</option>
          ))}
        </select>
      </FormField>

      <FormField label="Address" required>
        <input
          type="text"
          value={address}
          onChange={(e) => setAddress(e.target.value)}
          required
          style={COMMON_STYLES.input}
        />
      </FormField>

      <FormField label="City">
        <input
          type="text"
          value={city}
          onChange={(e) => setCity(e.target.value)}
          style={COMMON_STYLES.input}
        />
      </FormField>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '12px' }}>
        <FormField label="State" required>
          <select
            value={state}
            onChange={(e) => setState(e.target.value)}
            required
            style={COMMON_STYLES.input}
          >
            <option value="">Select state</option>
            {usStates.map(stateCode => (
              <option key={stateCode} value={stateCode}>{stateCode}</option>
            ))}
          </select>
        </FormField>
        <FormField label="Zip Code" required>
          <input
            type="text"
            value={zipCode}
            onChange={(e) => setZipCode(e.target.value)}
            required
            placeholder="02101"
            style={COMMON_STYLES.input}
          />
        </FormField>
      </div>

      {fieldDefinitions.length > 0 && (
        <div style={{ marginTop: '20px', paddingTop: '20px', borderTop: `2px solid ${COLORS.border}` }}>
          <h4 style={{ marginTop: 0 }}>Custom Fields</h4>
          {fieldDefinitions.map(field => (
            <FormField key={field.id} label={field.field_name}>
              {field.field_type === 'enum_type' ? (
                <select
                  value={customFields[field.field_name] || ''}
                  onChange={(e) => handleCustomFieldChange(field.field_name, e.target.value)}
                  style={COMMON_STYLES.input}
                >
                  <option value="">Select...</option>
                  {field.enum_options?.map(option => (
                    <option key={option} value={option}>{option}</option>
                  ))}
                </select>
              ) : (
                <input
                  type={field.field_type === 'number' ? 'number' : 'text'}
                  value={customFields[field.field_name] || ''}
                  onChange={(e) => handleCustomFieldChange(field.field_name, e.target.value)}
                  step={field.field_type === 'number' ? 'any' : undefined}
                  style={COMMON_STYLES.input}
                />
              )}
            </FormField>
          ))}
        </div>
      )}

      <div style={{ display: 'flex', gap: '8px', marginTop: '20px' }}>
        <Button type="submit" variant="success" disabled={loading}>
          {loading ? 'Saving...' : 'Save'}
        </Button>
        <Button onClick={onCancel} variant="secondary">
          Cancel
        </Button>
      </div>
    </form>
  );
};

export default BuildingForm;
