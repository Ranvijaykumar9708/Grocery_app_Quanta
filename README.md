# Grocery App Quanta

## 📌 Description
Flutter e-commerce grocery application with dual user/admin interfaces. Built using Clean Architecture (MVVM + Provider). Features product browsing, shopping cart, order management, and admin dashboard for managing products, categories, and users.

## 🚀 Features

### User Features
- 🔐 **Authentication** - Login and registration
- 🛍️ **Product Browsing** - Browse by categories and subcategories
- 🛒 **Shopping Cart** - Add, update, and remove items
- 📦 **Order Management** - Place orders and view order history
- 📍 **Address Management** - Save and select delivery addresses
- 👤 **Profile Management** - Update user details

### Admin Features
- 📦 **Product Management** - Add, edit, delete products with images
- 📂 **Category Management** - Manage categories and subcategories
- 📋 **Order Management** - View and update order status
- 👥 **User Management** - View and manage users
- 📊 **Dashboard** - Overview of orders and products

## 📂 Project Structure
```
lib/
├── core/              # Core functionality (constants, errors, network, services)
├── data/              # Data layer (datasources, models, repositories)
├── domain/            # Domain layer (entities, repositories, usecases)
├── presentation/      # Presentation layer (screens, viewmodels)
├── di/                # Dependency injection
├── Pages/             # UI pages (legacy, being migrated)
├── services/          # API services (legacy, being migrated)
└── main.dart          # App entry point
```

## 🛠️ Key Dependencies
```yaml
dependencies:
  provider: ^6.1.1          # State management
  get_it: ^7.7.0            # Dependency injection
  equatable: ^2.0.5         # Value equality
  http:                     # HTTP client
  shared_preferences: ^2.3.4 # Local storage
  image_picker:             # Image selection
  cached_network_image: ^3.4.1 # Image caching
  carousel_slider: ^5.0.0   # Image carousel
  google_fonts: ^6.2.1      # Custom fonts
  intl:                     # Internationalization
```

## 📥 Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Ranvijaykumar9708/Grocery_app_Quanta.git
   cd Grocery_app_Quanta
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the application:**
   ```sh
   flutter run
   ```

## 🔧 Configuration

- **API Base URL**: Configured in `lib/core/constants/app_constants.dart`
- **Access Key**: Stored in `AppConstants.accessKey`
- Update these values for different environments (dev/staging/production)

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web (partial)
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 🏗️ Architecture Details

The app follows **Clean Architecture** principles:

- **Core Layer**: Constants, errors, network utilities, core services
- **Domain Layer**: Business logic, entities, use cases, repository interfaces
- **Data Layer**: API calls, local storage, repository implementations
- **Presentation Layer**: UI screens, ViewModels (Providers), widgets

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).
