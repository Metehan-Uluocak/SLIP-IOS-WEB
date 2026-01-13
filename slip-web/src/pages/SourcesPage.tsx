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
  Link,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Refresh as RefreshIcon,
  OpenInNew as OpenInNewIcon,
} from '@mui/icons-material';
import MainLayout from '../components/MainLayout';
import { sourceApi } from '../services/api';
import { Source } from '../models/Source';

const SourcesPage: React.FC = () => {
  const [sources, setSources] = useState<Source[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingSource, setEditingSource] = useState<Source | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    url: '',
    description: '',
  });

  const fetchSources = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await sourceApi.getAll();
      setSources(data);
    } catch (err) {
      setError('Kaynaklar yüklenirken hata oluştu');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSources();
  }, []);

  const handleOpenDialog = (source?: Source) => {
    if (source) {
      setEditingSource(source);
      setFormData({
        name: source.name,
        url: source.url,
        description: source.description,
      });
    } else {
      setEditingSource(null);
      setFormData({
        name: '',
        url: '',
        description: '',
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingSource(null);
  };

  const handleSubmit = async () => {
    setError('');
    try {
      if (editingSource) {
        await sourceApi.update({
          ...editingSource,
          ...formData,
        });
      } else {
        await sourceApi.create(formData);
      }
      handleCloseDialog();
      fetchSources();
    } catch (err) {
      setError('İşlem sırasında hata oluştu');
      console.error(err);
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Bu kaynağı silmek istediğinize emin misiniz?')) {
      setError('');
      try {
        await sourceApi.delete(id);
        fetchSources();
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
            Yeni Kaynak
          </Button>
          <IconButton onClick={fetchSources} color="primary">
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
                  <TableCell>URL</TableCell>
                  <TableCell>Açıklama</TableCell>
                  <TableCell align="right">İşlemler</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {sources.map((source) => (
                  <TableRow key={source.id}>
                    <TableCell>{source.id}</TableCell>
                    <TableCell>{source.name}</TableCell>
                    <TableCell>
                      <Link
                        href={source.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}
                      >
                        {source.url}
                        <OpenInNewIcon fontSize="small" />
                      </Link>
                    </TableCell>
                    <TableCell>{source.description}</TableCell>
                    <TableCell align="right">
                      <IconButton
                        size="small"
                        onClick={() => handleOpenDialog(source)}
                        color="primary"
                      >
                        <EditIcon />
                      </IconButton>
                      <IconButton
                        size="small"
                        onClick={() => handleDelete(source.id)}
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
            {editingSource ? 'Kaynak Düzenle' : 'Yeni Kaynak'}
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
                label="URL"
                value={formData.url}
                onChange={(e) => setFormData({ ...formData, url: e.target.value })}
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
              {editingSource ? 'Güncelle' : 'Oluştur'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </MainLayout>
  );
};

export default SourcesPage;
