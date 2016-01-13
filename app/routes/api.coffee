authService = require '../services/auth-service'

module.exports = (express, config, jwt) ->
  apiRouter = express.Router()

  apiRouter.post '/auth', (req, res) ->
    authService.login req.body.username, req.body.password, (message)->
      res.json message
    
  apiRouter.use (req, res, next) ->
      
      token = req.body.token or req.query.token or req.headers['x-access-token']
      
      if token
        jwt.verify token, config.secret, (err, decoded) ->
          if err
            res.status(203).send
              success: false
              message: 'Token inválido.'
          else
            req.decoded = decoded
            next()
            return
      else
        res.status(203).send
            success: false
            message: 'Token de identificação não fornecido.'
      return

  return apiRouter