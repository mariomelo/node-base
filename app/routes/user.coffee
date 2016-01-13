 apiRouter.route('/users').post (req, res) ->
    
    user = new User
    
    user.name = req.body.name
    user.username = req.body.username
    user.password = req.body.password
    
    user.save (err) ->
      if err
        if err.code == 11000
          return res.json(
            success: false
            message: 'A user with thatusername already exists. ')
        else
          return res.send(err)
      res.json message: 'User created!'
      return
    return

   .get (req, response) ->
    User.find (error, users) ->
      response.send error if error
      response.json users

  apiRouter.route('/users/:user_id')
  .get (req, res) ->
    User.findById req.params.user_id, (error, user) ->
      res.send error if error
      res.json user
  .put (req, res) ->
    User.findById req.params.user_id, (error, user) ->
      res.send error if error

      updateFields = ['name', 'username', 'password']
      
      user[field] = req.body[field] for field in updateFields

      user.save (error) ->
        res.send error if error
        res.json  
          message: 'User updated!'

  .delete (req, res) ->
    User.remove _id: req.params.user_id, (error, user) ->
      return error if error
      res.json message: 'User removed!'