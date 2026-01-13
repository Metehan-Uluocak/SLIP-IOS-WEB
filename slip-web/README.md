# SLIP Web - Security Leak Intelligence Platform# Getting Started with Create React App



React + TypeScript + Material-UI ile geliştirilmiş web uygulaması.This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).



## 🚀 Özellikler## Available Scripts



- ✅ **Login Sistemi** - Email/Password ile girişIn the project directory, you can run:

- ✅ **Dashboard** - Güvenlik sızıntılarını listele, ara ve filtrele

- ✅ **Sources Yönetimi** - CRUD operasyonları### `npm start`

- ✅ **Platforms Yönetimi** - CRUD operasyonları

- ✅ **Users Yönetimi** - CRUD operasyonları (Sadece Admin)Runs the app in the development mode.\

- ✅ **Dark/Light Tema** - Tema değiştirmeOpen [http://localhost:3000](http://localhost:3000) to view it in the browser.

- ✅ **Role-Based Access** - Admin, Analist, User rolleri

- ✅ **Responsive Design** - Mobil ve masaüstü uyumluThe page will reload if you make edits.\

You will also see any lint errors in the console.

## 🛠️ Teknolojiler

### `npm test`

- **React 18** - UI Framework

- **TypeScript** - Type SafetyLaunches the test runner in the interactive watch mode.\

- **Material-UI (MUI)** - UI ComponentsSee the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

- **React Router** - Routing

- **Axios** - HTTP Client### `npm run build`

- **Context API** - State Management

Builds the app for production to the `build` folder.\

## 📦 KurulumIt correctly bundles React in production mode and optimizes the build for the best performance.



### GereksinimlerThe build is minified and the filenames include the hashes.\

- Node.js 16+ Your app is ready to be deployed!

- npm veya yarn

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### Adımlar

### `npm run eject`

1. **Bağımlılıkları yükleyin:**

```bash**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

cd slip-web

npm installIf you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

```

Instead, it will copy all the configuration files and the transitive dependencies (webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

2. **Backend API'yi çalıştırın:**

Backend API'nin `http://localhost:5058` adresinde çalıştığından emin olun.You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.



```bash## Learn More

cd ../SlipAPI

dotnet runYou can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

```

To learn React, check out the [React documentation](https://reactjs.org/).

3. **Web uygulamasını başlatın:**
```bash
npm start
```

Uygulama `http://localhost:3000` adresinde açılacaktır.

## 🔐 Demo Hesapları

| Email | Şifre | Rol |
|-------|-------|-----|
| admin@slip.com | admin123 | Admin |
| analist@slip.com | analist123 | Analist |
| user@slip.com | user123 | User |

## 📁 Proje Yapısı

```
slip-web/
├── src/
│   ├── components/         # Reusable components
│   │   ├── MainLayout.tsx
│   │   └── ProtectedRoute.tsx
│   ├── contexts/          # React Contexts
│   │   ├── AuthContext.tsx
│   │   └── ThemeContext.tsx
│   ├── models/            # TypeScript Models
│   │   ├── User.ts
│   │   ├── Leak.ts
│   │   ├── Source.ts
│   │   └── Platform.ts
│   ├── pages/             # Page Components
│   │   ├── LoginPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── SourcesPage.tsx
│   │   ├── PlatformsPage.tsx
│   │   └── UsersPage.tsx
│   ├── services/          # API Services
│   │   └── api.ts
│   ├── App.tsx            # Main App Component
│   └── index.tsx          # Entry Point
├── package.json
└── tsconfig.json
```

## 🔧 Yapılandırma

### API Base URL

API URL'ini değiştirmek için `src/services/api.ts` dosyasını düzenleyin:

```typescript
const API_BASE_URL = 'http://localhost:5058/api';
```

## 🚀 Production Build

```bash
npm run build
```

Build dosyaları `build/` klasöründe oluşturulur.

## 📝 Kullanım

1. **Login** - Demo hesaplardan biriyle giriş yapın
2. **Dashboard** - Güvenlik sızıntılarını görüntüleyin ve arayın
3. **Sources** - Kaynak ekleyin, düzenleyin veya silin
4. **Platforms** - Platform ekleyin, düzenleyin veya silin
5. **Users** - (Sadece Admin) Kullanıcı yönetimi yapın

## 🎨 Tema

Sağ üst köşedeki güneş/ay ikonuna tıklayarak dark/light tema arasında geçiş yapabilirsiniz.

## 🔒 Yetkilendirme

- **User**: Dashboard, Sources, Platforms sayfalarını görüntüleyebilir
- **Analist**: User ile aynı yetkiler + ek analiz özellikleri
- **Admin**: Tüm yetkiler + Users yönetimi

## 📞 Destek

Sorularınız için: [GitHub Issues](https://github.com/Metehan-Uluocak/slip)
