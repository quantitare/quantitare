const dotenv = require('dotenv')

const dotenvFiles = [
  '.env'
]

function loadEnv() {
  dotenvFiles.forEach((dotenvFile) => {
    dotenv.config({ path: dotenvFile, silent: true })
  })
}

module.exports = { loadEnv }
