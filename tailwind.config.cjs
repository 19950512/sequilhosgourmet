module.exports = {
  content: ["./site/**/*.html"],
  darkMode: 'selector',
  theme: {
    extend: {
      colors: {
        rose: {
          50: '#fff1f2',
          100: '#ffe4e6',
          200: '#fecdd3',
          300: '#fda4af',
          400: '#fb7185',
          500: '#f43f5e'
        },
        brand: {
          light: '#F8E8EE',
          DEFAULT: '#E5B8C8',
          dark: '#A45D7D',
          accent: '#7D4C5E'
        }
      },
      fontFamily: {
        serif: ['Cormorant Garamond', 'serif'],
        sans: ['Montserrat', 'sans-serif']
      }
    }
  },
  plugins: [],
};
