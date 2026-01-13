import React, { useEffect, useState } from 'react';
import {
  Box,
  TextField,
  MenuItem,
  Select,
  FormControl,
  InputLabel,
  IconButton,
  Card,
  CardContent,
  Typography,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Chip,
  Button,
  CircularProgress,
  Alert,
  Stack,
  InputAdornment,
} from '@mui/material';
import {
  ExpandMore as ExpandMoreIcon,
  Refresh as RefreshIcon,
  Search as SearchIcon,
  OpenInNew as OpenInNewIcon,
  Error as ErrorIcon,
} from '@mui/icons-material';
import MainLayout from '../components/MainLayout';
import { leakApi } from '../services/api';
import { Leak } from '../models/Leak';

const DashboardPage: React.FC = () => {
  const [leaks, setLeaks] = useState<Leak[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterPlatform, setFilterPlatform] = useState<string>('');
  const [error, setError] = useState('');

  const fetchLeaks = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await leakApi.getAll();
      setLeaks(data);
    } catch (err) {
      setError('Sızıntılar yüklenirken hata oluştu');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLeaks();
  }, []);

  const availablePlatforms = Array.from(
    new Set(leaks.map((leak) => leak.platformName))
  ).sort();

  const filteredLeaks = leaks.filter((leak) => {
    const matchesSearch =
      searchQuery === '' ||
      leak.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      leak.summary.toLowerCase().includes(searchQuery.toLowerCase()) ||
      leak.platformName.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesPlatform =
      filterPlatform === '' || leak.platformName === filterPlatform;

    return matchesSearch && matchesPlatform;
  });

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('tr-TR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  return (
    <MainLayout>
      <Box>
        <Stack direction="row" spacing={2} sx={{ mb: 3 }}>
          <TextField
            fullWidth
            placeholder="Platform, başlık veya özet ara..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
            }}
          />
          <FormControl sx={{ minWidth: 200 }}>
            <InputLabel>Platform Filtrele</InputLabel>
            <Select
              value={filterPlatform}
              label="Platform Filtrele"
              onChange={(e) => setFilterPlatform(e.target.value)}
            >
              <MenuItem value="">Tümü</MenuItem>
              {availablePlatforms.map((platform) => (
                <MenuItem key={platform} value={platform}>
                  {platform}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
          <IconButton onClick={fetchLeaks} color="primary" title="Yenile">
            <RefreshIcon />
          </IconButton>
        </Stack>

        {error && (
          <Alert severity="error" sx={{ mb: 2 }}>
            {error}
          </Alert>
        )}

        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 8 }}>
            <CircularProgress />
          </Box>
        ) : filteredLeaks.length === 0 ? (
          <Card>
            <CardContent>
              <Box sx={{ textAlign: 'center', py: 4 }}>
                <ErrorIcon sx={{ fontSize: 64, color: 'text.secondary', mb: 2 }} />
                <Typography variant="h6" color="text.secondary">
                  {searchQuery || filterPlatform
                    ? 'Arama kriterlerine uygun sızıntı bulunamadı'
                    : 'Henüz sızıntı bulunmuyor'}
                </Typography>
              </Box>
            </CardContent>
          </Card>
        ) : (
          <Stack spacing={2}>
            {filteredLeaks.map((leak) => (
              <Accordion key={leak.id}>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Box sx={{ display: 'flex', alignItems: 'center', width: '100%', gap: 2 }}>
                    <Chip
                      label={leak.platformName}
                      color="error"
                      size="small"
                      sx={{ minWidth: 100 }}
                    />
                    <Typography sx={{ flexGrow: 1 }} fontWeight="bold">
                      {leak.title}
                    </Typography>
                    <Typography variant="caption" color="text.secondary">
                      {formatDate(leak.publishDate)}
                    </Typography>
                  </Box>
                </AccordionSummary>
                <AccordionDetails>
                  <Stack spacing={2}>
                    <Box>
                      <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                        Özet:
                      </Typography>
                      <Typography variant="body2">{leak.summary}</Typography>
                    </Box>
                    <Box>
                      <Typography variant="subtitle2" color="text.secondary" gutterBottom>
                        Kaynak:
                      </Typography>
                      <Typography variant="body2">{leak.sourceName}</Typography>
                    </Box>
                    <Box>
                      <Button
                        variant="outlined"
                        size="small"
                        startIcon={<OpenInNewIcon />}
                        href={leak.sourceUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        Kaynağa Git
                      </Button>
                    </Box>
                  </Stack>
                </AccordionDetails>
              </Accordion>
            ))}
          </Stack>
        )}
      </Box>
    </MainLayout>
  );
};

export default DashboardPage;
