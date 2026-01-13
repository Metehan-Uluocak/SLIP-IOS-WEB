export enum UserRole {
  Admin = 0,
  Analist = 1,
  User = 2
}

export interface User {
  id: number;
  email: string;
  name: string;
  role: UserRole;
  password?: string;
}

export const getRoleName = (role: UserRole): string => {
  switch (role) {
    case UserRole.Admin:
      return 'Admin';
    case UserRole.Analist:
      return 'Analist';
    case UserRole.User:
      return 'User';
    default:
      return 'User';
  }
};
