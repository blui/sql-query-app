<template>
  <section class="mb-8 bg-white p-6 rounded-lg shadow-md">
    <div class="flex items-center justify-between">
      <h2 class="text-2xl font-semibold mb-4">SQL Connection Configuration</h2>
      <button
        @click="collapsed = !collapsed"
        class="text-primary hover:underline flex items-center"
      >
        <span v-if="collapsed">▶</span>
        <span v-else>▼</span>
      </button>
    </div>

    <!-- Conditionally render the form based on `collapsed` state -->
    <div v-if="!collapsed">
      <form @submit.prevent="saveConnectionConfig">
        <div class="grid grid-cols-2 gap-4">
          <div v-for="(value, key) in filteredConfig" :key="key">
            <label
              :for="key"
              class="block text-gray-700 text-sm font-bold mb-2"
            >
              {{ key }}
            </label>
            <input
              v-model="connectionConfig[key]"
              :type="key === 'password' ? 'password' : 'text'"
              :placeholder="`Enter ${key}`"
              class="w-full p-2 border rounded-lg"
              required
            />
          </div>

          <!-- Options Section -->
          <div class="col-span-2 mt-4">
            <h3 class="text-lg font-semibold text-gray-700">Options</h3>
          </div>

          <!-- Encrypt Option -->
          <div>
            <label
              for="encrypt"
              class="block text-gray-700 text-sm font-bold mb-2"
              >Encrypt</label
            >
            <select
              v-model="connectionConfig.options.encrypt"
              class="w-full p-2 border rounded-lg"
            >
              <option :value="true">True</option>
              <option :value="false">False</option>
            </select>
          </div>

          <!-- Trust Server Certificate Option -->
          <div>
            <label
              for="trustServerCertificate"
              class="block text-gray-700 text-sm font-bold mb-2"
              >Trust Server Certificate</label
            >
            <select
              v-model="connectionConfig.options.trustServerCertificate"
              class="w-full p-2 border rounded-lg"
            >
              <option :value="true">True</option>
              <option :value="false">False</option>
            </select>
          </div>
        </div>

        <button
          type="submit"
          class="bg-primary text-white py-2 px-4 rounded-lg mt-4 hover:bg-primary-dark transition"
        >
          Save Configuration
        </button>
      </form>
    </div>
  </section>
</template>

<script>
import axios from "axios";

export default {
  name: "SqlConnectionConfig",
  data() {
    return {
      collapsed: true, // Controls whether the section is collapsed
      connectionConfig: {
        user: "",
        password: "",
        server: "",
        database: "",
        options: {
          encrypt: false,
          trustServerCertificate: false,
        },
      },
      error: null,
    };
  },
  computed: {
    filteredConfig() {
      return Object.fromEntries(
        Object.entries(this.connectionConfig).filter(
          ([key]) => key !== "options"
        )
      );
    },
  },
  async mounted() {
    try {
      const response = await axios.get("http://localhost:5000/config", {
        headers: {
          Authorization: `Bearer ${localStorage.getItem("token")}`,
          "X-Session-Id": localStorage.getItem("sessionId"),
        },
      });
      this.connectionConfig = response.data.sqlConfig;
    } catch (error) {
      this.error = "Failed to load configuration. Please try again.";
      console.error("Error loading configuration:", error);
    }
  },
  methods: {
    async saveConnectionConfig() {
      try {
        await axios.put("http://localhost:5000/config", this.connectionConfig, {
          headers: {
            Authorization: `Bearer ${localStorage.getItem("token")}`,
            "X-Session-Id": localStorage.getItem("sessionId"),
          },
        });
        alert("Configuration updated successfully!");
      } catch (error) {
        this.error = "Failed to save configuration. Please try again.";
        console.error("Error saving configuration:", error);
      }
    },
  },
};
</script>
