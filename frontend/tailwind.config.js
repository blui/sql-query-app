module.exports = {
  content: ["./public/**/*.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: {
          light: "#3b82f6",
          DEFAULT: "#2563eb",
          dark: "#1e40af",
        },
      },
      fontFamily: {
        sans: ["Segoe UI", "Arial", "sans-serif"],
        heading: ["Montserrat", "sans-serif"],
      },
      fontSize: {
        xs: "0.75rem",
        sm: "0.875rem",
        base: "1rem",
        lg: "1.125rem",
        xl: "1.25rem",
        "2xl": "1.5rem",
        "3xl": "1.875rem",
        "4xl": "2.25rem",
        "5xl": "3rem",
      },
      spacing: {
        // Custom Spacing (padding, margin)
        72: "18rem", // 288px
        84: "21rem", // 336px
        96: "24rem", // 384px
      },
      borderRadius: {
        // Custom border-radius for rounded elements
        lg: "0.5rem", // 8px
        xl: "0.75rem", // 12px
        "2xl": "1rem", // 16px
      },
      boxShadow: {
        // Custom box shadows
        button: "0 4px 6px rgba(0, 0, 0, 0.1)", // Light shadow for buttons
        card: "0 8px 16px rgba(0, 0, 0, 0.1)", // Stronger shadow for cards
      },
    },
  },
  plugins: [],
};
