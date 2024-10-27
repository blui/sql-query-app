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
        secondary: {
          light: "#f1f3f4",
          DEFAULT: "#e5e7eb",
          dark: "#cbd5e1",
        },
        accent: {
          light: "#f59e0b",
          DEFAULT: "#e37400",
          dark: "#c05600",
        },
        background: {
          light: "#ffffff",
          DEFAULT: "#f9fafb",
          dark: "#e5e5e5",
          gradient: "linear-gradient(135deg, #f9fafb, #e5e7eb)",
        },
      },
      fontFamily: {
        sans: ["Segoe UI", "Arial", "sans-serif"],
        heading: ["Montserrat", "sans-serif"],
        mono: ["Source Code Pro", "monospace"],
      },
      fontSize: {
        xs: ["0.75rem", { lineHeight: "1rem" }],
        sm: ["0.875rem", { lineHeight: "1.25rem" }],
        base: ["1rem", { lineHeight: "1.5rem" }],
        lg: ["1.125rem", { lineHeight: "1.75rem" }],
        xl: ["1.25rem", { lineHeight: "1.75rem" }],
        "2xl": ["1.5rem", { lineHeight: "2rem" }],
        "3xl": ["1.875rem", { lineHeight: "2.25rem" }],
        "4xl": ["2.25rem", { lineHeight: "2.5rem" }],
        "5xl": ["3rem", { lineHeight: "1" }],
      },
      spacing: {
        72: "18rem",
        84: "21rem",
        96: "24rem",
        108: "27rem",
      },
      borderRadius: {
        lg: "0.5rem",
        xl: "0.75rem",
        "2xl": "1rem",
        "3xl": "1.5rem",
      },
      boxShadow: {
        button: "0 4px 6px rgba(0, 0, 0, 0.1)",
        card: "0 8px 16px rgba(0, 0, 0, 0.1)",
        navbar: "0 4px 10px rgba(0, 0, 0, 0.08)",
        modal: "0 10px 25px rgba(0, 0, 0, 0.15)",
      },
      transitionProperty: {
        width: "width",
        spacing: "margin, padding",
      },
    },
  },
  plugins: [],
};
