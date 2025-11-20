import React, { useState, useEffect, useCallback } from 'react';
import BuildingCard from './BuildingCard';
import BuildingForm from './BuildingForm';
import Button from './Button';
import ErrorMessage from './ErrorMessage';
import { API_BASE_URL, COLORS } from './constants';

const BuildingApp = () => {
  const [buildings, setBuildings] = useState([]);
  const [clients, setClients] = useState([]);
  const [usStates, setUsStates] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingBuilding, setEditingBuilding] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchBuildings = useCallback(async (page = 1) => {
    try {
      const response = await fetch(`${API_BASE_URL}/buildings?page=${page}&per_page=10`);
      if (!response.ok) throw new Error('Failed to fetch buildings');
      const data = await response.json();
      setBuildings(data.buildings || data);
      if (data.meta) {
        setTotalPages(data.meta.total_pages);
        setCurrentPage(data.meta.current_page);
      }
    } catch (err) {
      setError(err.message);
    }
  }, []);

  const fetchClients = useCallback(async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/clients`);
      if (!response.ok) throw new Error('Failed to fetch clients');
      const data = await response.json();
      setClients(data);
    } catch (err) {
      setError(err.message);
    }
  }, []);

  const fetchMetadata = useCallback(async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/buildings/metadata`);
      if (!response.ok) throw new Error('Failed to fetch metadata');
      const data = await response.json();
      setUsStates(data.us_states || []);
    } catch (err) {
      setError(err.message);
    }
  }, []);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      await Promise.all([fetchBuildings(), fetchClients(), fetchMetadata()]);
      setLoading(false);
    };
    loadData();
  }, [fetchBuildings, fetchClients, fetchMetadata]);

  const handleSave = useCallback(async () => {
    setShowForm(false);
    setEditingBuilding(null);
    await fetchBuildings(currentPage);
  }, [fetchBuildings, currentPage]);

  const handleEdit = useCallback((building) => {
    setEditingBuilding(building);
    setShowForm(true);
  }, []);

  const handleCancel = useCallback(() => {
    setShowForm(false);
    setEditingBuilding(null);
  }, []);

  if (loading) {
    return <div style={{ padding: '20px' }}>Loading...</div>;
  }

  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '20px' }}>
      <h1 style={{ marginBottom: '24px' }}>Building Management</h1>

      <ErrorMessage message={error} />

      {!showForm && (
        <div style={{ marginBottom: '24px' }}>
          <Button onClick={() => setShowForm(true)}>
            + Create New Building
          </Button>
        </div>
      )}

      {showForm && !editingBuilding && (
        <BuildingForm
          building={editingBuilding}
          clients={clients}
          usStates={usStates}
          onSave={handleSave}
          onCancel={handleCancel}
        />
      )}

      <div>
        <h2>Buildings ({buildings.length})</h2>
        {buildings.map(building => (
          <div key={building.id}>
            <BuildingCard
              building={building}
              onEdit={handleEdit}
            />
            {editingBuilding?.id === building.id && showForm && (
              <div style={{ marginTop: '16px', marginBottom: '24px' }}>
                <BuildingForm
                  building={editingBuilding}
                  clients={clients}
                  usStates={usStates}
                  onSave={handleSave}
                  onCancel={handleCancel}
                />
              </div>
            )}
          </div>
        ))}
      </div>

      {totalPages > 1 && (
        <div style={{ marginTop: '24px', textAlign: 'center' }}>
          <Button
            onClick={() => fetchBuildings(currentPage - 1)}
            disabled={currentPage === 1}
            size="small"
          >
            Previous
          </Button>
          <span style={{ margin: '0 16px' }}>
            Page {currentPage} of {totalPages}
          </span>
          <Button
            onClick={() => fetchBuildings(currentPage + 1)}
            disabled={currentPage === totalPages}
            size="small"
          >
            Next
          </Button>
        </div>
      )}
    </div>
  );
};

export default BuildingApp;
