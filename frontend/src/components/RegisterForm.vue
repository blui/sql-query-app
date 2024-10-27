<template>
  <div class="w-full max-w-xs mx-auto mt-16 p-8 bg-white shadow-lg rounded-lg">
    <h2 class="text-2xl font-semibold text-center mb-4">Register</h2>
    <form @submit.prevent="register">
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
      <!-- Email Input -->
      <div class="mb-4">
        <label for="email" class="block text-gray-700 text-sm font-bold mb-2">
          Email
        </label>
        <input
          v-model="email"
          type="email"
          id="email"
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
      <!-- Register Button -->
      <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded">
        Register
      </button>
      <p v-if="error" class="text-red-500 text-sm mt-4">{{ error }}</p>
      <!-- Switch to Login Link -->
      <p class="mt-4 text-center">
        Already have an account?
        <button @click="switchToLogin" class="text-blue-500 underline">
          Log in
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
  name: "RegisterForm",
  data() {
    return {
      username: "",
      email: "",
      password: "",
      error: null,
    };
  },
  methods: {
    async register() {
      log.info("Registration attempt started for user:", this.username);
      try {
        this.error = null; // Reset previous error

        await axios.post("http://localhost:5000/register", {
          username: this.username,
          email: this.email,
          password: this.password,
        });

        log.info("Registration successful for user:", this.username);
        this.$emit("registerSuccess"); // Notify parent of successful registration
      } catch (err) {
        this.error = err.response?.data?.error || "Registration failed";
        log.error(
          "Registration failed for user:",
          this.username,
          "Error:",
          this.error
        );
      }
    },
    switchToLogin() {
      log.debug("Switching to login form from registration");
      this.$emit("switchToLogin"); // Notify parent to show LoginForm
    },
  },
};
</script>

<style scoped>
/* Scoped styling for register form */
</style>
