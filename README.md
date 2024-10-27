# SQL Query Explorer Web App

SQL Query Explorer is a professional web application designed for business users to securely write, save, and execute SQL queries against a SQL Server database directly from their browser. The app provides a modern, enterprise-grade interface, allowing users to interact with their database, view query results, manage configurations, and perform user-specific operations with ease.

## Features

- **User Authentication**: Secure login system with session handling and JWT authentication.
- **Real-Time SQL Query Execution**: Write and execute SQL commands directly in the browser.
- **Query History and Saved Queries**: Save SQL queries with custom names for future use.
- **Dynamic Query Results**: View real-time results in a structured table format.
- **User Profiles**: Update and manage user profiles, including authentication details.
- **Configurable SQL Connection Settings**: Adjust SQL Server connection configurations directly from the app, with options for encryption and server certificate trust.
- **Responsive UI**: Optimized for desktop with an intuitive, enterprise-grade layout.

## Tech Stack

- **Frontend**: Vue.js 3 with Tailwind CSS for styling, Axios for API requests.
- **Backend**: Node.js, Express, and SQL Server integration with JWT for secure sessions.
- **Database**: SQL Server with SQL Authentication.
- **Logging & Error Handling**: Winston for detailed logging, error tracking for effective debugging.

## Prerequisites

- **Node.js** (v14.x or higher)
- **Vue.js** (Vue 3.x)
- **SQL Server** with accessible credentials
- **Browser**: Modern browser (Chrome, Firefox, Edge)

## Getting Started

### 1. Clone the Repository

Run the following commands to clone the repository and navigate into it:

`git clone https://github.com/your-username/your-repository.git`

`cd your-repository`

### 2. Install Dependencies

Navigate to both `server` and `frontend` directories and install the necessary packages:

For the backend:

`cd server`

`npm install`

For the frontend:

`cd ../frontend`

`npm install`

### 3. Configure the Backend

Update `server/config.json` with your SQL Server credentials:

{
"sqlConfig": {
"user": "your-username",
"password": "your-password",
"server": "your-server",
"database": "your-database",
"options": {
"encrypt": true,  
 "trustServerCertificate": true
}
},
"SECRET_KEY": "your-secret-key"
}

### 4. Run the Backend

Start the backend server:

`cd server`

`node index.js`

The backend will run on `http://localhost:5000`.

### 5. Run the Frontend

Navigate to the `frontend` directory and start the Vue development server:

`cd frontend`

`npm run serve`

The frontend will run on `http://localhost:8080`.

### 6. Access the Application

Open your browser and go to `http://localhost:8080` to start using the application.

## Project Structure

Your project should have the following structure:

- frontend/ - Vue.js frontend
- server/ - Node.js backend
- .gitignore - Git ignore file
- README.md - Project documentation

## Technologies Used

- **Vue.js**: Frontend framework for dynamic UI.
- **Tailwind CSS**: For styling with a modern, responsive design.
- **Node.js & Express**: Backend API for handling routes, sessions, and SQL queries.
- **SQL Server**: Database for secure, business-grade SQL operations.
- **JWT & Bcrypt**: For secure user authentication.
- **Winston**: Logging library to track server events and errors.
- **Axios**: HTTP client for managing API requests.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.
