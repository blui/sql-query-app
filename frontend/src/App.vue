<!-- frontend/src/App.vue -->

<template>
  <div id="app">
    <h1>SQL Query Executor</h1>

    <!-- SQL Query Input -->
    <textarea
      v-model="query"
      placeholder="Enter SQL query here..."
      rows="10"
      cols="70"
    ></textarea>

    <!-- Execute Button -->
    <br /><br />
    <button @click="executeQuery">Execute Query</button>

    <!-- Error Message -->
    <div v-if="error" style="color: red">
      <p>Error: {{ error }}</p>
    </div>

    <!-- Query Results -->
    <div v-if="result && result.length">
      <h3>Results:</h3>
      <table border="1">
        <thead>
          <tr>
            <th v-for="(value, key) in result[0]" :key="key">{{ key }}</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(row, index) in result" :key="index">
            <td v-for="(value, key) in row" :key="key">{{ value }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- No Results Message -->
    <div v-else-if="result">
      <p>No results to display.</p>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "App",
  data() {
    return {
      query: "", // Stores the SQL query input
      result: null, // Stores the query results
      error: null, // Stores any error messages
    };
  },
  methods: {
    async executeQuery() {
      try {
        this.error = null;
        this.result = null;

        // Send the SQL query to the backend
        const response = await axios.post(
          "http://localhost:5000/execute-query",
          {
            query: this.query,
          }
        );

        // Set the result to display
        this.result = response.data;
      } catch (err) {
        // Handle errors
        if (err.response && err.response.data && err.response.data.error) {
          this.error = err.response.data.error;
        } else {
          this.error = err.message;
        }
      }
    },
  },
};
</script>

<style>
#app {
  font-family: Arial, sans-serif;
  text-align: center;
  margin: 20px;
}

textarea {
  width: 80%;
  font-size: 16px;
}

button {
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}

table {
  margin: 20px auto;
  border-collapse: collapse;
}

th,
td {
  padding: 8px 12px;
  text-align: left;
}

th {
  background-color: #f2f2f2;
}
</style>
