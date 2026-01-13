import React, { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  IconButton,
  CircularProgress,
  Alert,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Refresh as RefreshIcon,
} from '@mui/icons-material';
import MainLayout from '../components/MainLayout';
import { platformApi } from '../services/api';
import { Platform } from '../models/Platform';

const PlatformsPage: React.FC = () => {
  const [platforms, setPlatforms] = useState<Platform[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingPlatform, setEditingPlatform] = useState<Platform | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    description: '',
  });

  const fetchPlatforms = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await platformApi.getAll();
      setPlatforms(data);
    } catch (err) {
      setError('Platformlar yüklenirken hata oluştu');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPlatforms();
  }, []);

  const handleOpenDialog = (platform?: Platform) => {
    if (platform) {
      setEditingPlatform(platform);
      setFormData({
        name: platform.name,
        description: platform.description,
      });
    } else {
      setEditingPlatform(null);
      setFormData({
        name: '',
        description: '',
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingPlatform(null);
  };

  const handleSubmit = async () => {
    setError('');
    try {
      if (editingPlatform) {
        await platformApi.update({
          ...editingPlatform,
          ...formData,
        });
      } else {
        await platformApi.create(formData);
      }
      handleCloseDialog();
      fetchPlatforms();
    } catch (err) {
      setError('İşlem sırasında hata oluştu');
      console.error(err);
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Bu platformu silmek istediğinize emin misiniz?')) {
      setError('');
      try {
        await platformApi.delete(id);
        fetchPlatforms();
      } catch (err) {
        setError('Silme işlemi sırasında hata oluştu');
        console.error(err);
      }
    }
  };

  return (
    <MainLayout>
      <Box>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={() => handleOpenDialog()}
          >
            Yeni Platform
          </Button>
          <IconButton onClick={fetchPlatforms} color="primary">
            <RefreshIcon />
          </IconButton>
        </Box>

        {error && (
          <Alert severity="error" sx={{ mb: 2 }}>
            {error}
          </Alert>
        )}

        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
            <CircularProgress />
          </Box>
        ) : (
          <TableContainer component={Paper}>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>ID</TableCell>
                  <TableCell>İsim</TableCell>
                  <TableCell>Açıklama</TableCell>
                  <TableCell align="right">İşlemler</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {platforms.map((platform) => (
                  <TableRow key={platform.id}>
                    <TableCell>{platform.id}</TableCell>
                    <TableCell>{platform.name}</TableCell>
                    <TableCell>{platform.description}</TableCell>
                    <TableCell align="right">
                      <IconButton
                        size="small"
                        onClick={() => handleOpenDialog(platform)}
                        color="primary"
                      >
                        <EditIcon />
                      </IconButton>
                      <IconButton
                        size="small"
                        onClick={() => handleDelete(platform.id)}
                        color="error"
                      >
                        <DeleteIcon />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        )}

        <Dialog open={dialogOpen} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
          <DialogTitle>
            {editingPlatform ? 'Platform Düzenle' : 'Yeni Platform'}
          </DialogTitle>
          <DialogContent>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 2 }}>
              <TextField
                fullWidth
                label="İsim"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              />
              <TextField
                fullWidth
                label="Açıklama"
                multiline
                rows={3}
                value={formData.description}
                onChange={(e) =>
                  setFormData({ ...formData, description: e.target.value })
                }
              />
            </Box>
          </DialogContent>
          <DialogActions>
            <Button onClick={handleCloseDialog}>İptal</Button>
            <Button onClick={handleSubmit} variant="contained">
              {editingPlatform ? 'Güncelle' : 'Oluştur'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </MainLayout>
  );
};

export default PlatformsPage;
