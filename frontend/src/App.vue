<template>
  <div id="app" class="h-screen flex overflow-hidden bg-gray-100">
    <!-- Sidebar -->
    <aside class="w-80 bg-blue-900 text-white flex-shrink-0">
      <div
        class="h-16 bg-blue-800 flex items-center justify-center text-2xl font-semibold"
      ></div>
      <nav class="mt-4 px-4">
        <ul class="space-y-4">
          <li>
            <a
              href="#"
              class="flex items-center px-4 py-2 text-white hover:bg-blue-700 rounded-lg"
            >
              <i class="fas fa-database mr-3"></i>
              Execute Queries
            </a>
          </li>
          <li>
            <a
              href="#"
              class="flex items-center px-4 py-2 text-white hover:bg-blue-700 rounded-lg"
            >
              <i class="fas fa-history mr-3"></i>
              Query History
            </a>
          </li>
        </ul>

        <!-- Saved Queries Section in Sidebar -->
        <div class="mt-8">
          <h3 class="text-lg font-semibold px-4">Saved Queries</h3>
          <ul class="space-y-2 mt-2 px-4">
            <li v-if="savedQueries.length === 0" class="text-gray-300">
              No saved queries.
            </li>
            <li
              v-for="query in savedQueries"
              :key="query.id"
              class="text-white"
              title="Click to load query"
            >
              <a
                @click="loadQuery(query)"
                href="#"
                class="flex items-center px-4 py-2 hover:bg-blue-700 rounded-lg w-full"
              >
                <i class="fas fa-file-alt mr-3"></i>
                <span class="truncate">{{ query.queryName }}</span>
              </a>
            </li>
          </ul>
        </div>
      </nav>
    </aside>

    <!-- Main content area -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- Top bar -->
      <header
        class="w-full h-16 bg-white shadow-sm flex items-center justify-between px-4"
      >
        <h1 class="text-lg font-semibold text-gray-800">SQL Query Explorer</h1>
        <div>
          <button class="bg-blue-600 text-white py-2 px-4 rounded-lg">
            Log Out
          </button>
        </div>
      </header>

      <!-- Main content area -->
      <main class="flex-1 overflow-y-auto p-6">
        <div class="max-w-7xl mx-auto">
          <!-- SQL Query Input and Save Query Form -->
          <section class="mb-8 bg-white p-6 rounded-lg shadow-md">
            <h2 class="text-2xl font-semibold mb-4">SQL Query Editor</h2>
            <textarea
              v-model="query"
              placeholder="Enter SQL query here..."
              class="w-full h-80 p-4 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
            ></textarea>

            <div class="flex items-center justify-between mt-4">
              <input
                v-model="queryName"
                placeholder="Enter query name (max 75 characters)..."
                :maxlength="75"
                class="w-1/2 p-2 text-lg border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-600"
              />
              <span v-if="queryName.length >= 75" class="text-red-600"
                >Max character limit reached!</span
              >
              <button
                @click="saveQuery"
                class="bg-green-600 text-white py-2 px-6 rounded-lg shadow hover:bg-green-700"
              >
                Save Query
              </button>
              <button
                @click="executeQuery"
                class="bg-blue-600 text-white py-2 px-6 rounded-lg shadow hover:bg-blue-700"
              >
                Execute Query
              </button>
            </div>

            <!-- Error Message -->
            <div v-if="error" class="text-red-600 mt-4">
              <p>Error: {{ error }}</p>
            </div>
          </section>

          <!-- Query Results -->
          <section
            v-if="result && result.length"
            class="mb-8 bg-white p-6 rounded-lg shadow-md"
          >
            <h2 class="text-2xl font-semibold mb-4">Query Results</h2>
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
          </section>
        </div>
      </main>
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
      queryName: "", // Stores the name of the query to save
      result: null, // Stores the query results
      error: null, // Stores any error messages
      savedQueries: [], // Stores the list of saved queries
    };
  },
  mounted() {
    this.fetchSavedQueries(); // Fetch saved queries when component is mounted
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

        // Set the result to display in the table
        this.result = response.data;
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    async saveQuery() {
      if (this.queryName.length > 75) {
        this.error = "Query name exceeds the maximum character limit.";
        return;
      }

      try {
        // Save the query with a name
        await axios.post("http://localhost:5000/save-query", {
          queryName: this.queryName,
          queryText: this.query,
        });

        this.queryName = ""; // Clear the query name after saving
        this.fetchSavedQueries(); // Fetch updated list of saved queries
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    async fetchSavedQueries() {
      try {
        const response = await axios.get("http://localhost:5000/saved-queries");
        this.savedQueries = response.data; // Populate saved queries
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    loadQuery(query) {
      this.query = query.queryText; // Load the query into the input box
    },
  },
};
</script>

<style>
body {
  font-family: "Segoe UI", Arial, sans-serif;
}
</style>
