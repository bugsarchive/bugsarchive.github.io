/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./public/**/*.html", "./src/**/*.html"],
  theme: {
    extend: {},
    fontFamily: {
      serif: ["IBM Plex Serif", "ui-serif", "Georgia", "serif"],
      mono: ["IBM Plex Mono", "ui-monospace", "SFMono-Regular"],
      display: ["Modern Antiqua", "serif"],
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
