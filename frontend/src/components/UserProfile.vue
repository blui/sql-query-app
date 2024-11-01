<template>
  <div class="p-8 bg-white rounded-lg shadow-md max-w-md mx-auto">
    <h2 class="text-2xl font-semibold mb-4">Your Profile</h2>

    <!-- Profile Update Form -->
    <form @submit.prevent="updateProfile">
      <!-- First Name Input -->
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2"
          >First Name</label
        >
        <input
          v-model="profile.firstName"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <!-- Last Name Input -->
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2"
          >Last Name</label
        >
        <input
          v-model="profile.lastName"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <!-- Role Input -->
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Role</label>
        <input
          v-model="profile.role"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <!-- Email Input -->
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Email</label>
        <input
          type="email"
          v-model="profile.email"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <!-- Update Button -->
      <button
        type="submit"
        class="bg-primary text-white py-2 px-4 rounded-lg mt-4 hover:bg-primary-dark transition"
      >
        Update Profile
      </button>
    </form>

    <!-- Success and Error Messages -->
    <p v-if="successMessage" class="text-green-500 mt-4">
      {{ successMessage }}
    </p>
    <p v-if="error" class="text-red-500 mt-4">{{ error }}</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "UserProfile",
  data() {
    return {
      profile: {
        firstName: "",
        lastName: "",
        role: "",
        email: "",
      },
      error: null, // Error message storage
      successMessage: null, // Success message storage
    };
  },
  mounted() {
    this.fetchProfile(); // Fetch profile data when component is mounted
  },
  methods: {
    /**
     * Fetch the user's profile information from the server.
     */
    async fetchProfile() {
      try {
        const response = await axios.get("http://localhost:5000/profile", {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
            "X-Session-Id": localStorage.getItem("sessionId"),
          },
        });

        if (response.data) {
          // Populate profile fields with response data, fallback to empty if not available
          this.profile = {
            firstName: response.data.firstName || "",
            lastName: response.data.lastName || "",
            role: response.data.role || "",
            email: response.data.email || "",
          };
        }
      } catch (error) {
        this.error = "Failed to get profile";
        console.error("Error fetching profile:", error);
      }
    },

    /**
     * Update the user's profile with the current form data.
     */
    async updateProfile() {
      try {
        await axios.put("http://localhost:5000/profile", this.profile, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
            "X-Session-Id": localStorage.getItem("sessionId"),
          },
        });
        this.successMessage = "Profile updated successfully";
        this.error = null;
      } catch (error) {
        this.error = "Failed to update profile";
        this.successMessage = null;
        console.error("Error updating profile:", error);
      }
    },
  },
};
</script>

<style scoped>
/* Scoped styling for profile component */
</style>
