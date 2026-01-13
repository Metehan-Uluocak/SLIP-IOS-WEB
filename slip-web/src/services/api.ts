import axios from 'axios';
import { User } from '../models/User';
import { Leak } from '../models/Leak';
import { Source } from '../models/Source';
import { Platform } from '../models/Platform';

const API_BASE_URL = 'http://localhost:5058/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// User APIs
export const userApi = {
  login: async (email: string, password: string): Promise<User> => {
    const response = await api.post<User>('/Users/login', { email, password });
    return response.data;
  },

  getAll: async (): Promise<User[]> => {
    const response = await api.get<User[]>('/users');
    return response.data;
  },

  create: async (user: Omit<User, 'id'>): Promise<User> => {
    const response = await api.post<User>('/users', user);
    return response.data;
  },

  update: async (user: User): Promise<void> => {
    await api.put(`/users/${user.id}`, user);
  },

  delete: async (id: number): Promise<void> => {
    await api.delete(`/users/${id}`);
  },
};

// Leak APIs
export const leakApi = {
  getAll: async (): Promise<Leak[]> => {
    const response = await api.get<Leak[]>('/leaks');
    return response.data;
  },
};

// Source APIs
export const sourceApi = {
  getAll: async (): Promise<Source[]> => {
    const response = await api.get<Source[]>('/sources');
    return response.data;
  },

  create: async (source: Omit<Source, 'id'>): Promise<Source> => {
    const response = await api.post<Source>('/sources', source);
    return response.data;
  },

  update: async (source: Source): Promise<void> => {
    await api.put(`/sources/${source.id}`, source);
  },

  delete: async (id: number): Promise<void> => {
    await api.delete(`/sources/${id}`);
  },
};

// Platform APIs
export const platformApi = {
  getAll: async (): Promise<Platform[]> => {
    const response = await api.get<Platform[]>('/platforms');
    return response.data;
  },

  create: async (platform: Omit<Platform, 'id'>): Promise<Platform> => {
    const response = await api.post<Platform>('/platforms', platform);
    return response.data;
  },

  update: async (platform: Platform): Promise<void> => {
    await api.put(`/platforms/${platform.id}`, platform);
  },

  delete: async (id: number): Promise<void> => {
    await api.delete(`/platforms/${id}`);
  },
};

export default api;
