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
  Chip,
  CircularProgress,
  Alert,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Refresh as RefreshIcon,
} from '@mui/icons-material';
import MainLayout from '../components/MainLayout';
import { userApi } from '../services/api';
import { User, UserRole, getRoleName } from '../models/User';
import { useAuth } from '../contexts/AuthContext';

const UsersPage: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    role: UserRole.User,
  });
  const { user: currentUser } = useAuth();

  const fetchUsers = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await userApi.getAll();
      setUsers(data);
    } catch (err) {
      setError('Kullanıcılar yüklenirken hata oluştu');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const handleOpenDialog = (user?: User) => {
    if (user) {
      setEditingUser(user);
      setFormData({
        name: user.name,
        email: user.email,
        password: '',
        role: user.role,
      });
    } else {
      setEditingUser(null);
      setFormData({
        name: '',
        email: '',
        password: '',
        role: UserRole.User,
      });
    }
    setDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setDialogOpen(false);
    setEditingUser(null);
  };

  const handleSubmit = async () => {
    setError('');
    try {
      if (editingUser) {
        await userApi.update({
          ...editingUser,
          ...formData,
          password: formData.password || undefined,
        });
      } else {
        await userApi.create(formData);
      }
      handleCloseDialog();
      fetchUsers();
    } catch (err) {
      setError('İşlem sırasında hata oluştu');
      console.error(err);
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Bu kullanıcıyı silmek istediğinize emin misiniz?')) {
      setError('');
      try {
        await userApi.delete(id);
        fetchUsers();
      } catch (err) {
        setError('Silme işlemi sırasında hata oluştu');
        console.error(err);
      }
    }
  };

  const getRoleColor = (role: UserRole) => {
    switch (role) {
      case UserRole.Admin:
        return 'error';
      case UserRole.Analist:
        return 'warning';
      default:
        return 'default';
    }
  };

  if (currentUser?.role !== UserRole.Admin) {
    return (
      <MainLayout>
        <Alert severity="error">Bu sayfaya erişim yetkiniz yok.</Alert>
      </MainLayout>
    );
  }

  return (
    <MainLayout>
      <Box>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={() => handleOpenDialog()}
          >
            Yeni Kullanıcı
          </Button>
          <IconButton onClick={fetchUsers} color="primary">
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
                  <TableCell>Email</TableCell>
                  <TableCell>Rol</TableCell>
                  <TableCell align="right">İşlemler</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {users.map((user) => (
                  <TableRow key={user.id}>
                    <TableCell>{user.id}</TableCell>
                    <TableCell>{user.name}</TableCell>
                    <TableCell>{user.email}</TableCell>
                    <TableCell>
                      <Chip
                        label={getRoleName(user.role)}
                        color={getRoleColor(user.role)}
                        size="small"
                      />
                    </TableCell>
                    <TableCell align="right">
                      <IconButton
                        size="small"
                        onClick={() => handleOpenDialog(user)}
                        color="primary"
                      >
                        <EditIcon />
                      </IconButton>
                      <IconButton
                        size="small"
                        onClick={() => handleDelete(user.id)}
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
            {editingUser ? 'Kullanıcı Düzenle' : 'Yeni Kullanıcı'}
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
                label="Email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              />
              <TextField
                fullWidth
                label={editingUser ? 'Şifre (boş bırakılabilir)' : 'Şifre'}
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              />
              <FormControl fullWidth>
                <InputLabel>Rol</InputLabel>
                <Select
                  value={formData.role}
                  label="Rol"
                  onChange={(e) =>
                    setFormData({ ...formData, role: e.target.value as UserRole })
                  }
                >
                  <MenuItem value={UserRole.User}>User</MenuItem>
                  <MenuItem value={UserRole.Analist}>Analist</MenuItem>
                  <MenuItem value={UserRole.Admin}>Admin</MenuItem>
                </Select>
              </FormControl>
            </Box>
          </DialogContent>
          <DialogActions>
            <Button onClick={handleCloseDialog}>İptal</Button>
            <Button onClick={handleSubmit} variant="contained">
              {editingUser ? 'Güncelle' : 'Oluştur'}
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </MainLayout>
  );
};

export default UsersPage;
