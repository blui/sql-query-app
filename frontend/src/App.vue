<template>
  <div
    id="app"
    class="min-h-screen bg-gray-50 p-8 flex flex-col items-center justify-start"
  >
    <!-- Header -->
    <h1 class="text-4xl font-semibold mb-8 text-center text-gray-900">
      SQL Query Explorer
    </h1>

    <!-- SQL Query Input -->
    <textarea
      v-model="query"
      placeholder="Enter SQL query here..."
      class="w-full max-w-4xl p-4 text-lg border border-gray-300 rounded-lg shadow-sm mb-6 focus:outline-none focus:ring-2 focus:ring-blue-600"
      rows="10"
    ></textarea>

    <!-- Execute Button -->
    <button
      @click="executeQuery"
      class="bg-blue-600 text-white py-2 px-6 rounded-lg shadow hover:bg-blue-700 transition mb-4"
    >
      Execute Query
    </button>

    <!-- Error Message -->
    <div v-if="error" class="text-red-600 mt-4">
      <p>Error: {{ error }}</p>
    </div>

    <!-- Query Results -->
    <div v-if="result && result.length" class="mt-6 w-full max-w-4xl">
      <h3 class="text-2xl font-semibold mb-4 text-gray-800">Results:</h3>
      <table
        class="w-full border-collapse border border-gray-300 shadow-sm rounded-lg"
      >
        <thead>
          <tr class="bg-gray-200">
            <th
              v-for="(value, key) in result[0]"
              :key="key"
              class="border border-gray-300 p-3 text-left font-semibold"
            >
              {{ key }}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(row, index) in result"
            :key="index"
            class="hover:bg-gray-100"
          >
            <td
              v-for="(value, key) in row"
              :key="key"
              class="border border-gray-300 p-3"
            >
              {{ value }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- No Results Message -->
    <div v-else-if="result" class="mt-4 text-gray-600">
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
body {
  font-family: "Segoe UI", Arial, sans-serif;
}
</style>
