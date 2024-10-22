# SQL Query Execution Web App

This web application allows users to write and execute SQL queries against a SQL Server database directly from the browser. The app provides a simple and intuitive interface where users can input SQL commands, view real-time query results, and manage their database interactions seamlessly.

## Features

- Execute SQL queries in real-time from the browser
- View query results in a dynamic table format
- Supports SQL Authentication for secure access
- Works with a SQL Server database

## Prerequisites

- Node.js (v14.x or higher)
- Vue.js (Vue 3.x)
- SQL Server with accessible credentials
- A modern browser (Chrome, Firefox, Edge)

## Getting Started

### 1. Clone the Repository

Run the following commands to clone the repository:

`git clone https://github.com/your-username/your-repository.git`

Then navigate to the repository folder:

`cd your-repository`

### 2. Install Dependencies

Navigate to both the `server` and `frontend` directories and install the necessary packages:

For the backend:

`cd server`

`npm install`

For the frontend:

`cd ../frontend`

`npm install`

### 3. Setup the Backend

Modify the SQL Server configuration in the `server/index.js` file:

Replace `your-username`, `your-password`, and `VacationDestinations` with your actual SQL Server details.

### 4. Running the Backend

Start the backend server with:

`cd server`

`node index.js`

The backend will run on `http://localhost:5000`.

### 5. Running the Frontend

Navigate to the `frontend` folder and start the Vue development server with:

`cd frontend`

`npm run serve`

The frontend will run on `http://localhost:8080`.

### 6. Accessing the App

Open your browser and navigate to `http://localhost:8080` to start using the web app.

## Project Structure

Your project should have the following structure:

- `frontend/` - Vue.js frontend
- `server/` - Node.js backend
- `.gitignore` - Git ignore file
- `README.md` - Project documentation

## Technologies Used

- Vue.js (Frontend framework)
- Node.js & Express (Backend API)
- SQL Server (Database)
- Axios (HTTP client for API requests)

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
