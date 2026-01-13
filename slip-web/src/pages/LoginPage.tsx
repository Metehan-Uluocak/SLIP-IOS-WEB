import React, { useState } from 'react';
import {
  Box,
  Card,
  CardContent,
  TextField,
  Button,
  Typography,
  Container,
  Alert,
  Divider,
  Stack,
  Paper,
} from '@mui/material';
import { Security as SecurityIcon } from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const LoginPage: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const { login, isLoading } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (!email || !password) {
      setError('Email ve şifre gerekli');
      return;
    }

    const success = await login(email, password);
    if (success) {
      navigate('/dashboard');
    } else {
      setError('Email veya şifre hatalı');
    }
  };

  const demoAccounts = [
    { email: 'admin@slip.com', password: 'admin123', role: 'Admin' },
    { email: 'analist@slip.com', password: 'analist123', role: 'Analist' },
    { email: 'user@slip.com', password: 'user123', role: 'User' },
  ];

  const handleDemoLogin = (email: string, password: string) => {
    setEmail(email);
    setPassword(password);
  };

  return (
    <Container maxWidth="sm">
      <Box
        sx={{
          minHeight: '100vh',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Card elevation={8} sx={{ width: '100%' }}>
          <CardContent sx={{ p: 4 }}>
            <Box sx={{ textAlign: 'center', mb: 3 }}>
              <SecurityIcon sx={{ fontSize: 80, color: 'primary.main', mb: 2 }} />
              <Typography variant="h4" component="h1" gutterBottom>
                SLIP
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Security Leak Intelligence Platform
              </Typography>
            </Box>

            <form onSubmit={handleSubmit}>
              <Stack spacing={2}>
                <TextField
                  fullWidth
                  label="Email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={isLoading}
                />
                <TextField
                  fullWidth
                  label="Şifre"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  disabled={isLoading}
                />
                {error && <Alert severity="error">{error}</Alert>}
                <Button
                  fullWidth
                  variant="contained"
                  type="submit"
                  size="large"
                  disabled={isLoading}
                >
                  {isLoading ? 'Giriş yapılıyor...' : 'Giriş Yap'}
                </Button>
              </Stack>
            </form>

            <Divider sx={{ my: 3 }} />

            <Typography variant="subtitle2" align="center" gutterBottom>
              Demo Hesapları:
            </Typography>
            <Stack spacing={1} sx={{ mt: 2 }}>
              {demoAccounts.map((account) => (
                <Paper
                  key={account.email}
                  variant="outlined"
                  sx={{ p: 1.5, cursor: 'pointer' }}
                  onClick={() => handleDemoLogin(account.email, account.password)}
                >
                  <Typography variant="body2" fontWeight="bold">
                    {account.role}
                  </Typography>
                  <Typography variant="caption" color="text.secondary">
                    {account.email} / {account.password}
                  </Typography>
                </Paper>
              ))}
            </Stack>
          </CardContent>
        </Card>
      </Box>
    </Container>
  );
};

export default LoginPage;
