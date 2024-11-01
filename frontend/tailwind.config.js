module.exports = {
  content: ["./public/**/*.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: {
          light: "#4e97f7",
          DEFAULT: "#2563eb",
          dark: "#1e40af",
        },
        secondary: {
          light: "#f3f4f6",
          DEFAULT: "#e5e7eb",
          dark: "#cbd5e1",
        },
        accent: {
          light: "#fab005",
          DEFAULT: "#f59e0b",
          dark: "#c05600",
        },
        background: {
          light: "#f9fafb",
          DEFAULT: "#f3f4f6",
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
        "6xl": ["3.75rem", { lineHeight: "1" }],
      },
      spacing: {
        72: "18rem",
        84: "21rem",
        96: "24rem",
        108: "27rem",
        128: "32rem",
        "3/5": "60%",
        "4/5": "80%",
      },
      borderRadius: {
        lg: "0.5rem",
        xl: "0.75rem",
        "2xl": "1rem",
        "3xl": "1.5rem",
        full: "9999px", // For pill-shaped buttons or elements
      },
      boxShadow: {
        button: "0 4px 8px rgba(0, 0, 0, 0.15)",
        card: "0 8px 20px rgba(0, 0, 0, 0.12)",
        navbar: "0 4px 12px rgba(0, 0, 0, 0.08)",
        modal: "0 12px 28px rgba(0, 0, 0, 0.25)",
        subtle: "0 2px 4px rgba(0, 0, 0, 0.08)",
        inner: "inset 0 1px 3px rgba(0, 0, 0, 0.1)",
      },
      transitionProperty: {
        width: "width",
        spacing: "margin, padding",
        colors: "background-color, border-color, color, fill, stroke",
        transform: "transform",
      },
    },
  },
  plugins: [],
};
