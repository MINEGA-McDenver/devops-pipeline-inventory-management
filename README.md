# Inventory Management System

A full-stack inventory management system built with React, Node.js, Express, and MySQL. Features include product management, authentication, search functionality, and real-time stock tracking.

## 🚀 Features

1. **Authentication** - JWT-based login system with token management
2. **Product Management** - Full CRUD operations (Create, Read, Update, Delete)
3. **Search & Filter** - Real-time search by name, SKU, or category
4. **Stock Tracking** - Low stock alerts and inventory value calculation
5. **Dashboard Stats** - Total products, inventory value, and low stock count

## 📋 Technical Stack

- **Frontend**: React with Tailwind CSS
- **Backend**: Node.js + Express
- **Database**: MySQL 8.0
- **Authentication**: JWT tokens
- **Containerization**: Docker & Docker Compose

## 🛠️ Prerequisites

- Node.js 18+ (for local development)
- Docker & Docker Compose (for containerized deployment)
- MySQL 8.0 (if running without Docker)

## 🚀 Quick Start with Docker

The easiest way to run the entire application:

```bash
# 1. Clone the repository
git clone <repository-url>
cd inventory-management

# 2. Create environment file
cp .env.example .env

# 3. Start all services with Docker Compose
docker-compose up -d

# 4. Check services are running
docker-compose ps

# 5. View logs
docker-compose logs -f backend
```

The API will be available at `http://localhost:3001`

### Default Login Credentials
- **Username**: `admin`
- **Password**: `password`

## 💻 Local Development Setup

### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Start MySQL (if not using Docker)
# Update .env with your MySQL credentials

# Run database migrations (automatic on first start)
npm start

# For development with auto-reload
npm run dev
```

### Frontend Setup

The React frontend is provided as an artifact that can be:
1. Copied into a new React project
2. Run directly in the Claude interface
3. Integrated into an existing React application

For a standalone React app:

```bash
# Create new React app
npx create-react-app inventory-frontend
cd inventory-frontend

# Install dependencies
npm install lucide-react

# Copy the React component code into src/App.js
# Update API_URL if needed

# Start development server
npm start
```

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/login` - User login

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create new product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

### Health Check
- `GET /api/health` - Check API status

## 📝 API Request Examples

### Login
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password"}'
```

### Create Product
```bash
curl -X POST http://localhost:3001/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "name":"Laptop",
    "sku":"LAP-001",
    "quantity":50,
    "price":999.99,
    "category":"Electronics"
  }'
```

### Get All Products
```bash
curl -X GET http://localhost:3001/api/products \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 🧪 Testing

Run the test suite:

```bash
# Install test dependencies
npm install --save-dev jest supertest

# Run tests
npm test

# Run tests with coverage
npm test -- --coverage
```

### Test Coverage
- Authentication endpoints
- CRUD operations
- Error handling
- Input validation
- Duplicate prevention

## 🐳 Docker Commands

```bash
# Build and start containers
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Rebuild containers
docker-compose up -d --build

# Remove all data (including database)
docker-compose down -v

# Access MySQL CLI
docker exec -it inventory_db mysql -u root -p inventory_db
```

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Products Table
```sql
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  sku VARCHAR(50) UNIQUE NOT NULL,
  quantity INT NOT NULL DEFAULT 0,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 🔒 Security Features

- JWT token-based authentication
- Password hashing with bcrypt
- SQL injection prevention with prepared statements
- CORS configuration
- Input validation
- Environment variable configuration

## 🌍 Environment Variables

```env
# Server
PORT=3001

# Database
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=inventory_db

# Security
JWT_SECRET=your-secret-key-change-in-production
```

## 📦 Project Structure

```
inventory-management/
├── backend/
│   ├── server.js           # Main server file
│   ├── package.json        # Dependencies
│   ├── .env.example        # Environment template
│   ├── Dockerfile          # Container configuration
│   └── server.test.js      # API tests
├── docker-compose.yml      # Multi-container setup
└── README.md              # Documentation
```

## 🚨 Troubleshooting

### Database Connection Issues
```bash
# Check if MySQL is running
docker-compose ps

# Check database logs
docker-compose logs db

# Restart database
docker-compose restart db
```

### Backend Issues
```bash
# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend

# Rebuild backend
docker-compose up -d --build backend
```

### Port Conflicts
If ports 3001 or 3306 are already in use:
```bash
# Change ports in docker-compose.yml
# For backend: "3002:3001"
# For MySQL: "3307:3306"
```

## 📈 Future Enhancements

- User roles and permissions
- Product categories management
- Bulk import/export (CSV)
- Activity logs and audit trail
- Advanced reporting and analytics
- Barcode scanning support
- Email notifications for low stock
- Multi-location inventory tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Support

For issues and questions:
- Create an issue in the repository
- Check existing documentation
- Review API tests for usage examples
