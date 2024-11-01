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

    <div v-if="!collapsed">
      <form @submit.prevent="saveConnectionConfig">
        <!-- Form for SQL Connection Inputs -->
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

          <!-- Options Section for Encrypt and Trust Server Certificate -->
          <div class="col-span-2 mt-4">
            <h3 class="text-lg font-semibold text-gray-700">Options</h3>
          </div>

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

        <!-- Test and Save Buttons -->
        <div class="mt-4 flex space-x-4">
          <button
            type="button"
            @click="testConnection"
            class="bg-yellow-500 text-white py-2 px-4 rounded-lg hover:bg-yellow-600 transition"
          >
            Test Connection
          </button>
          <button
            type="submit"
            class="bg-primary text-white py-2 px-4 rounded-lg hover:bg-primary-dark transition"
          >
            Save Configuration
          </button>
        </div>

        <!-- Connection Test Message -->
        <p
          v-if="testMessage"
          :class="{
            'text-green-500': testSuccess,
            'text-red-500': !testSuccess,
          }"
        >
          {{ testMessage }}
        </p>
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
      collapsed: true, // Controls visibility of the form
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
      error: null, // Stores any error message for display
      testMessage: "", // Holds the message for connection test status
      testSuccess: false, // Flag to show if connection test passed or failed
    };
  },
  computed: {
    /**
     * Filters out the 'options' object from the main configuration
     * so it can be displayed separately in the form.
     */
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
      // Load default VacationDestinations configuration
      this.connectionConfig = response.data.sqlConfig.VacationDestinations;
    } catch (error) {
      this.error = "Failed to load configuration. Please try again.";
      console.error("Error loading configuration:", error);
    }
  },
  methods: {
    /**
     * Tests the current database connection settings to verify configuration.
     */
    async testConnection() {
      try {
        const response = await axios.post(
          "http://localhost:5000/test-connection",
          this.connectionConfig,
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("token")}`,
              "X-Session-Id": localStorage.getItem("sessionId"),
            },
          }
        );
        this.testMessage = response.data.message;
        this.testSuccess = true;
      } catch (error) {
        this.testMessage =
          "Connection test failed. Please verify your settings.";
        this.testSuccess = false;
        console.error("Error testing connection:", error);
      }
    },
    /**
     * Saves the current configuration specifically for VacationDestinations.
     * This ensures that the private SQLQueryExplorer configuration is not overwritten.
     */
    async saveConnectionConfig() {
      try {
        await axios.put(
          "http://localhost:5000/config",
          { sqlConfig: { VacationDestinations: this.connectionConfig } },
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("token")}`,
              "X-Session-Id": localStorage.getItem("sessionId"),
            },
          }
        );
        alert("Configuration updated successfully!");
      } catch (error) {
        this.error = "Failed to save configuration. Please try again.";
        console.error("Error saving configuration:", error);
      }
    },
  },
};
</script>

<style scoped>
/* Scoped styling for the SQL Connection Configuration component */
</style>
