/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./**/*.html"],
  theme: {
    extend: {},
    fontFamily: {
      math: ["Computer Modern", "ui-serif", "serif"],
      serif: ["IBM Plex Serif", "ui-serif", "Georgia", "serif"],
      sans: ["Fira Sans", "sans"],
      mono: ["Fira Mono", "ui-monospace", "SFMono-Regular"],
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
