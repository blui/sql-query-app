<template>
  <div class="p-8 bg-white rounded-lg shadow-md max-w-md mx-auto">
    <h2 class="text-2xl font-semibold mb-4">Your Profile</h2>

    <form @submit.prevent="updateProfile">
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

      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Role</label>
        <input
          v-model="profile.role"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Email</label>
        <input
          type="email"
          v-model="profile.email"
          class="w-full p-2 border rounded-lg"
          required
        />
      </div>

      <button
        type="submit"
        class="bg-primary text-white py-2 px-4 rounded-lg mt-4 hover:bg-primary-dark transition"
      >
        Update Profile
      </button>
    </form>

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
        role: "", // Updated field to match 'role' instead of 'job'
        email: "",
      },
      error: null,
      successMessage: null,
    };
  },
  mounted() {
    this.fetchProfile();
  },
  methods: {
    async fetchProfile() {
      try {
        const response = await axios.get("http://localhost:5000/profile", {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
            "x-session-id": localStorage.getItem("sessionId"), // Ensure session ID is sent
          },
        });
        if (response.data) {
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
    async updateProfile() {
      try {
        await axios.put("http://localhost:5000/profile", this.profile, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
            "X-Session-Id": localStorage.getItem("sessionId"), // Add session ID here for update
          },
        });
        this.successMessage = "Profile updated successfully";
      } catch (error) {
        this.error = "Failed to update profile";
        console.error("Error updating profile:", error);
      }
    },
  },
};
</script>

<style scoped>
/* Scoped styling for profile component */
</style>
