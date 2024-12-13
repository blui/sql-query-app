<template>
  <div id="app" class="h-screen flex overflow-hidden bg-secondary-light">
    <!-- Login or Register Form -->
    <div v-if="!loggedIn" class="flex items-center justify-center w-full">
      <LoginForm
        v-if="!showRegister"
        @loginSuccess="handleLoginSuccess"
        @switchToRegister="showRegisterForm"
      />
      <RegisterForm
        v-else
        @registerSuccess="showLoginForm"
        @switchToLogin="showLoginForm"
      />
    </div>

    <!-- Main Content Area -->
    <div v-else class="flex flex-grow overflow-hidden bg-gray-100">
      <!-- Sidebar for Navigation and Saved Queries -->
      <aside
        class="w-1/5 bg-primary-dark text-white flex-shrink-0 flex flex-col"
      >
        <div
          class="h-16 bg-primary text-center flex items-center justify-center text-2xl font-semibold tracking-wide"
        >
          SQL Explorer
        </div>
        <nav class="flex-grow mt-6 px-4">
          <ul class="space-y-4">
            <li>
              <a
                href="#"
                @click.prevent="showProfile = false"
                class="flex items-center px-4 py-3 text-white rounded-lg bg-primary hover:bg-primary-dark transition"
              >
                <i class="fas fa-database mr-3"></i> Execute Queries
              </a>
            </li>
            <li>
              <a
                href="#"
                class="flex items-center px-4 py-3 text-white rounded-lg bg-primary hover:bg-primary-dark transition"
              >
                <i class="fas fa-history mr-3"></i> Query History
              </a>
            </li>
          </ul>
          <!-- Saved Queries -->
          <div class="mt-8">
            <h3 class="text-lg font-semibold px-4">Saved Queries</h3>
            <ul class="space-y-2 mt-4 px-4">
              <li v-if="savedQueries.length === 0" class="text-gray-400">
                No saved queries.
              </li>
              <li
                v-for="query in savedQueries"
                :key="query.id"
                class="text-white cursor-pointer"
                title="Click to load query"
              >
                <a
                  @click="loadQuery(query)"
                  href="#"
                  class="flex items-center px-4 py-2 hover:bg-primary-light rounded-lg transition w-full whitespace-nowrap"
                >
                  <i class="fas fa-file-alt mr-3"></i>
                  <span class="truncate">{{ query.queryName }}</span>
                </a>
              </li>
            </ul>
          </div>
        </nav>
      </aside>

      <!-- Main Query and Result Area -->
      <div class="flex-1 flex flex-col overflow-hidden">
        <!-- Header with Search Bar and Profile -->
        <header
          class="w-full h-16 bg-white shadow flex items-center justify-between px-6 relative"
        >
          <h1 class="text-lg font-semibold text-gray-700">
            Welcome, {{ username || "User" }}
          </h1>
          <div class="relative" v-if="username">
            <button @click="toggleProfileMenu" class="relative">
              <span
                v-if="username"
                class="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center font-semibold"
              >
                {{ username.charAt(0).toUpperCase() }}
              </span>
            </button>
            <div
              v-if="profileMenuVisible"
              class="absolute right-0 mt-2 w-32 bg-white border border-gray-200 rounded-lg shadow-lg z-10"
            >
              <ul>
                <li>
                  <button
                    @click="viewProfile"
                    class="w-full text-left px-4 py-2 hover:bg-gray-100"
                  >
                    Profile
                  </button>
                </li>
                <li>
                  <button
                    @click="logout"
                    class="w-full text-left px-4 py-2 hover:bg-gray-100"
                  >
                    Log Out
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </header>

        <!-- Main Content (Profile or Query View) -->
        <main class="flex-1 overflow-y-auto p-8">
          <div v-if="showProfile">
            <UserProfile @back="showProfile = false" />
          </div>
          <div v-else>
            <!-- SQL Connection Configuration -->
            <SqlConnectionConfig @setDbConfig="setDbConfig" />
            <!-- Query Editor -->
            <section class="mb-8 bg-white p-6 rounded-lg shadow-md">
              <h2 class="text-2xl font-semibold mb-4">Query Editor</h2>
              <textarea
                v-model="query"
                placeholder="Enter SQL query here..."
                class="w-full h-80 p-4 text-lg border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              ></textarea>
              <div class="flex items-center mt-4">
                <input
                  v-model="queryName"
                  placeholder="Query name (max 20 chars)"
                  :maxlength="20"
                  class="w-1/3 p-2 text-lg border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-primary"
                />
                <button
                  @click="saveQuery"
                  class="ml-4 bg-green-600 text-white py-2 px-6 rounded-lg shadow hover:bg-green-700"
                >
                  Save Query
                </button>
                <div class="flex-grow"></div>
                <button
                  @click="executeQuery"
                  class="bg-blue-600 text-white py-2 px-6 rounded-lg shadow hover:bg-blue-700"
                >
                  Execute Query
                </button>
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
  </div>
</template>

<script>
import axios from "axios";
import log from "loglevel";
import LoginForm from "./components/LoginForm.vue";
import RegisterForm from "./components/RegisterForm.vue";
import UserProfile from "./components/UserProfile.vue";
import SqlConnectionConfig from "./components/SqlConnectionConfig.vue";

log.setLevel("info");

export default {
  name: "App",
  components: { LoginForm, RegisterForm, UserProfile, SqlConnectionConfig },
  data() {
    return {
      loggedIn: !!localStorage.getItem("token"),
      showRegister: false,
      query: "",
      queryName: "",
      result: null,
      error: null,
      savedQueries: [],
      profileMenuVisible: false,
      showProfile: false,
      username: "",
      dbConfig: null,
    };
  },
  async mounted() {
    axios.interceptors.response.use(
      (response) => response,
      (error) => {
        if (error.response && error.response.status === 401) {
          this.logout();
          this.error = "Your session has expired. Please log in again.";
          return Promise.reject(error);
        }
        return Promise.reject(error);
      }
    );
    if (this.loggedIn) {
      await this.fetchUserData();
      await this.fetchSavedQueries();
      await this.fetchInitialDbConfig();
    }
  },
  methods: {
    getAuthHeaders() {
      return {
        Authorization: `Bearer ${localStorage.getItem("token")}`,
        "X-Session-Id": localStorage.getItem("sessionId"),
      };
    },
    async fetchInitialDbConfig() {
      try {
        const response = await axios.get("http://localhost:5000/config", {
          headers: this.getAuthHeaders(),
        });
        this.dbConfig = response.data.sqlConfig.VacationDestinations;
        log.info("Fetched initial dbConfig:", this.dbConfig);
      } catch (error) {
        this.error = "Failed to load database configuration.";
        console.error("Error loading initial dbConfig:", error);
      }
    },
    setDbConfig(config) {
      this.dbConfig = config;
      log.info("Updated dbConfig:", this.dbConfig);
    },
    handleLoginSuccess(data) {
      this.loggedIn = true;
      this.username = data.username || "";
      log.info("User logged in successfully with username:", this.username);
      this.fetchSavedQueries();
      this.fetchInitialDbConfig();
    },
    toggleProfileMenu() {
      this.profileMenuVisible = !this.profileMenuVisible;
    },
    async fetchUserData() {
      try {
        const response = await axios.get("http://localhost:5000/profile", {
          headers: this.getAuthHeaders(),
        });
        this.username =
          response.data.firstName || response.data.username || "User";
        console.log("Fetched user data:", this.username);
      } catch (error) {
        console.error("Error fetching user data:", error);
      }
    },
    showRegisterForm() {
      this.showRegister = true;
    },
    showLoginForm() {
      this.showRegister = false;
    },
    viewProfile() {
      this.showProfile = true;
      this.profileMenuVisible = false;
    },
    async executeQuery() {
      if (!this.dbConfig) {
        this.error = "Database configuration is not set.";
        return;
      }
      try {
        this.error = null;
        this.result = null;
        const response = await axios.post(
          "http://localhost:5000/execute-query",
          { query: this.query, dbConfig: this.dbConfig },
          { headers: this.getAuthHeaders() }
        );
        this.result = response.data;
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    async saveQuery() {
      if (this.queryName.length > 20) {
        this.error = "Query name exceeds the maximum character limit.";
        return;
      }
      try {
        await axios.post(
          "http://localhost:5000/save-query",
          {
            queryName: this.queryName,
            queryText: this.query,
          },
          { headers: this.getAuthHeaders() }
        );
        this.queryName = "";
        this.fetchSavedQueries();
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    async fetchSavedQueries() {
      try {
        const response = await axios.get(
          "http://localhost:5000/saved-queries",
          {
            headers: this.getAuthHeaders(),
          }
        );
        this.savedQueries = response.data;
      } catch (err) {
        this.error = err.response?.data?.error || err.message;
      }
    },
    loadQuery(query) {
      this.query = query.queryText;
    },
    logout() {
      localStorage.removeItem("token");
      localStorage.removeItem("sessionId");
      this.loggedIn = false;
      this.query = "";
      this.result = null;
      this.savedQueries = [];
      this.profileMenuVisible = false;
      this.showProfile = false;
      this.username = "";
      this.dbConfig = null;
    },
  },
};
</script>

<style>
body {
  font-family: "Segoe UI", Arial, sans-serif;
}
</style>
