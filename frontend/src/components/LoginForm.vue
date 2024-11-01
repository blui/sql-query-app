<template>
  <div class="w-full max-w-xs mx-auto mt-16 p-8 bg-white shadow-lg rounded-lg">
    <h2 class="text-2xl font-semibold text-center mb-4">Login</h2>
    <form @submit.prevent="login">
      <!-- Username Input -->
      <div class="mb-4">
        <label
          for="username"
          class="block text-gray-700 text-sm font-bold mb-2"
        >
          Username
        </label>
        <input
          v-model="username"
          type="text"
          id="username"
          class="w-full p-2 border rounded"
          required
        />
      </div>

      <!-- Password Input -->
      <div class="mb-6">
        <label
          for="password"
          class="block text-gray-700 text-sm font-bold mb-2"
        >
          Password
        </label>
        <input
          v-model="password"
          type="password"
          id="password"
          class="w-full p-2 border rounded"
          required
        />
      </div>

      <!-- Database Selection -->
      <div class="mb-6">
        <label
          for="database"
          class="block text-gray-700 text-sm font-bold mb-2"
        >
          Select Database
        </label>
        <select
          v-model="database"
          id="database"
          class="w-full p-2 border rounded"
        >
          <option value="SQLQueryExplorer">SQL Query Explorer</option>
          <option value="VacationDestinations">Vacation Destinations</option>
        </select>
      </div>

      <!-- Login Button -->
      <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded">
        Login
      </button>

      <!-- Error Message Display -->
      <p v-if="error" class="text-red-500 text-sm mt-4">{{ error }}</p>

      <!-- Switch to Registration Link -->
      <p class="mt-4 text-center">
        Don't have an account?
        <button @click="switchToRegister" class="text-blue-500 underline">
          Register
        </button>
      </p>
    </form>
  </div>
</template>

<script>
import axios from "axios";
import log from "loglevel";

log.setLevel("info");

export default {
  name: "LoginForm",
  data() {
    return {
      username: "", // User's entered username
      password: "", // User's entered password
      database: "SQLQueryExplorer", // Default to primary app schema
      error: null, // Holds any error message
    };
  },
  methods: {
    /**
     * Handles login functionality.
     * Sends login data to the backend, stores auth tokens and selected database in localStorage.
     */
    async login() {
      log.info("Login attempt started for user:", this.username);
      try {
        this.error = null;
        const response = await axios.post("http://localhost:5000/login", {
          username: this.username,
          password: this.password,
        });

        // Store authentication data and selected database in localStorage
        localStorage.setItem("token", response.data.token);
        localStorage.setItem("sessionId", response.data.sessionId);
        localStorage.setItem("database", this.database);
        log.info("Login successful for user:", this.username);

        // Emit login success event with username and selected database
        this.$emit("loginSuccess", {
          username: this.username,
          database: this.database,
        });
      } catch (err) {
        this.error = err.response?.data?.error || "Login failed";
        log.error(
          "Login failed for user:",
          this.username,
          "Error:",
          this.error
        );
      }
    },
    /**
     * Switches to the registration form.
     */
    switchToRegister() {
      log.debug("Switching to register form");
      this.$emit("switchToRegister");
    },
  },
};
</script>

<style scoped>
/* Scoped styling for login form */
</style>
