const dotenv = require('./dotenv')

dotenv.loadEnv()

module.exports = {
  plugins: [
    new webpack.EnvironmentPlugin(process.env)
  ]
}
