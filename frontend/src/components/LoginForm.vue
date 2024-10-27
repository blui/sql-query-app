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
      <!-- Login Button -->
      <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded">
        Login
      </button>
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

log.setLevel("info"); // Set log level (adjustable based on environment)

export default {
  name: "LoginForm",
  data() {
    return {
      username: "",
      password: "",
      error: null,
    };
  },
  methods: {
    async login() {
      log.info("Login attempt started for user:", this.username);
      try {
        this.error = null; // Clear previous errors
        const response = await axios.post("http://localhost:5000/login", {
          username: this.username,
          password: this.password,
        });

        // Store authentication details
        localStorage.setItem("token", response.data.token);
        localStorage.setItem("sessionId", response.data.sessionId);
        log.info("Login successful for user:", this.username);

        this.$emit("loginSuccess", this.username); // Pass username to App.vue
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
    switchToRegister() {
      log.debug("Switching to register form");
      this.$emit("switchToRegister"); // Switch to register form
    },
  },
};
</script>

<style scoped>
/* Scoped styling for login form */
</style>
