import React, { memo } from 'react';
import Button from './Button';
import { COLORS, COMMON_STYLES } from './constants';

const BuildingCard = memo(({ building, onEdit }) => {
  const customFields = building.custom_fields || {};
  
  return (
    <div style={COMMON_STYLES.card}>
      <h3 style={{ margin: '0 0 8px 0' }}>{building.address}</h3>
      <p style={{ margin: '4px 0', color: COLORS.mediumGray }}>
        {building.city}, {building.state} {building.zip_code}
      </p>
      <p style={{ margin: '4px 0', fontSize: '14px' }}>
        <strong>Client:</strong> {building.client_name}
      </p>
      
      {Object.keys(customFields).length > 0 && (
        <div style={{ marginTop: '12px', paddingTop: '12px', borderTop: `1px solid ${COLORS.lightBorder}` }}>
          <strong style={{ fontSize: '14px' }}>Custom Fields:</strong>
          <ul style={{ margin: '8px 0', paddingLeft: '20px' }}>
            {Object.entries(customFields).map(([key, value]) => (
              <li key={key} style={{ fontSize: '14px', margin: '4px 0' }}>
                <strong>{key}:</strong> {value || '(empty)'}
              </li>
            ))}
          </ul>
        </div>
      )}
      
      <div style={{ marginTop: '12px' }}>
        <Button onClick={() => onEdit(building)} size="small">
          Edit
        </Button>
      </div>
    </div>
  );
});

BuildingCard.displayName = 'BuildingCard';

export default BuildingCard;
