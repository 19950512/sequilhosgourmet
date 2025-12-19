const fs = require('fs');
const path = require('path');
const postcss = require('postcss');
const tailwindPostcss = require('@tailwindcss/postcss');
const autoprefixer = require('autoprefixer');

const input = path.join(__dirname, '..', 'site', 'styles.css');
const outDir = path.join(__dirname, '..', 'site', 'dist');
const output = path.join(outDir, 'styles.css');

const args = process.argv.slice(2);
const watch = args.includes('--watch');
const minify = args.includes('--minify') || args.includes('--production');

async function build() {
  try {
    const css = fs.readFileSync(input, 'utf8');
    const plugins = [tailwindPostcss(), autoprefixer()];
    if (minify) {
      const cssnano = require('cssnano');
      plugins.push(cssnano({ preset: 'default' }));
    }
    const result = await postcss(plugins).process(css, { from: input, to: output });
    if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
    fs.writeFileSync(output, result.css, 'utf8');
    console.log('Built', output);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
}

if (watch) {
  const chokidar = require('chokidar');
  chokidar.watch(path.join(__dirname, '..', 'site')).on('change', (p) => {
    console.log('Change detected:', p);
    build();
  });
  build();
} else {
  build();
}
