require "colors"
exs = require "express"
ect = require "ect"
mg  = require "mongoose"
moment = require "moment"
crypto = require "crypto"
session = require "client-sessions"

mg.connect('mongodb://localhost/bratstvost-3')
{Event} = require   "./models/event"
{Notice} = require  "./models/notice"
{News} = require    "./models/news"
{Member} = require "./models/member"
{Video} = require "./models/video"

_ = require "lodash"
require("uasync")(_)

app = exs()

app
  .disable("x-powered-by")
  .set("view engine", "ect")
  .engine('ect', ect(
      root : __dirname + '/views'
      ext : '.ect'
      cache: no
    ).render)

COOKIE_SECRET = 'tarasiki'
  
app
  .use(exs.urlencoded())
  .use(exs.json({limit: '5mb'}))
  .use(exs.cookieParser(COOKIE_SECRET))
  .use(session(
    cookieName: 'session'
    secret: 'the_secret_'
    duration: 30 * 60 * 1000,
    activeDuration: 5 * 60 * 1000,
  ))
  .use(exs.logger("short"))
  .use(exs.static("public"))
  .use(app.router)


app.locals =
  formatDate: (date) -> moment(date).fromNow()

POST_PER_PAGE = 10

users = 
  admin:
    login: 'admin'
    salt: 'TaRaSiKi2013'
    hash: 'dHj7wHvFYX/RupWr5zRbtPKIWOUGge1jGJldlraZ1sJ+b2ANK7KWYNYpL5PZ2Tol6aGBUMEE+4LtR3CLviZiEvxczLQ5lZEyEFGb1gsNHhEfPv50rbSa0Micie+u0mF5kzKyyzn1fnvf3YEmyM19TSL8cPvtUVriv6RiuAA59iw='

  user:
    login: 'user'
    salt: 'TaRaSiKi'
    hash: 'cGrz5YUCUZryySdwnJW6Bp4kcN2E2+S2Ck3pBC0WN2nZVY9iZ87FE7arSKoiXkYHI01nSfwedNzNnp1iMSXFT+CPVbV1wwGJMm4Rc8oArbSD1GLIFMIsuGcFBPxxaSGQF4mzHCliVA/B3k7/nheDK1fYD/hBOrA5XD8kRFGwJUE='

PASS_ITER = 5000
HASH_LEN  = 128

get_hash = (pwd, salt, fn) ->
  if arguments.length is 3
    crypto.pbkdf2 pwd, salt, PASS_ITER, HASH_LEN, (err, hash) -> 
      fn(err, (new Buffer(hash, 'binary')).toString('base64'))
  else
    fn = salt
    crypto.randomBytes len, (err, salt) ->
      return fn(err) if err
      salt = salt.toString('base64')
    crypto.pbkdf2 pwd, salt, PASS_ITER, HASH_LEN, (err, hash) -> 
      return fn(err) if err
      fn(err, salt, (new Buffer(hash, 'binary')).toString('base64'))


authenticate = (login, pass, done) ->
  return done(new Error('invalid arguments')) unless login and pass
  user = users[login]
  return done(new Error('user not found')) unless user
  get_hash pass, user.salt, (err, hash) ->
    return done(err) if (err)
    return done(null, user) if hash == user.hash
    done(new Error('invalid password'))


restrict = (req, res, next) ->
  if (req.session.user)
    next()
  else
    console.log "restricted!".red
    res.redirect('/login')

    

app.get '/login', (req, res) ->
  res.render 'login'

app.post "/login", (req, res) ->
  authenticate req.body.login, req.body.password, (err, user) ->
    if user
      req.session.user = user;
      res.redirect("/")
    else
      res.redirect("/login")

app.get '/logout', (req, res) ->
  req.session.user = null
  res.redirect('/login')

### EVENTS ###

app.get "/api/events", (req, res) ->
  Event.find {}, (err, results) ->
    return res.json(status: "ERR", message: err) if err
    res.json(results)

app.post "/api/events", restrict, (req, res) ->
  Event.create req.body, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK", _id: result._id)

app.put "/api/events/:id", restrict, (req, res) ->
  delete req.body._id
  Event.update {"_id": mg.Types.ObjectId(req.params.id)}, req.body, upsert: yes, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

app.del "/api/events/:id", restrict, (req, res) ->
  Event.findByIdAndRemove req.params.id, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")


### NOTICE ###

app.get "/api/notice", (req, res) ->
  Notice.find {}, (err, results) ->
    return res.json(status: "ERR", message: err) if err
    res.json(results)

app.post "/api/notice", restrict, (req, res) ->
  Notice.create req.body, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK", _id: result._id)

app.put "/api/notice/:id", restrict, (req, res) ->
  delete req.body._id
  Notice.update {"_id": mg.Types.ObjectId(req.params.id)}, req.body, upsert: yes, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

app.del "/api/notice/:id", restrict, (req, res) ->
  Notice.findByIdAndRemove req.params.id, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

### NEWS ###

app.get "/api/news", (req, res) ->
  News.find {}, (err, results) ->
    return res.json(status: "ERR", message: err) if err
    res.json(results)

app.post "/api/news", restrict, (req, res) ->
  News.create req.body, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK", _id: result._id)

app.put "/api/news/:id", restrict, (req, res) ->
  delete req.body._id
  News.update {"_id": mg.Types.ObjectId(req.params.id)}, req.body, upsert: yes, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

app.del "/api/news/:id", restrict, (req, res) ->
  News.findByIdAndRemove req.params.id, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

### MEMBERS ###

app.get "/api/members", (req, res) ->
  Member.find {}, (err, results) ->
    return res.json(status: "ERR", message: err) if err
    res.json(results)

app.post "/api/members", restrict, (req, res) ->
  Member.create req.body, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK", _id: result._id)

app.put "/api/members/:id", restrict, (req, res) ->
  delete req.body._id
  Member.update {"_id": mg.Types.ObjectId(req.params.id)}, req.body, upsert: yes, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

app.del "/api/members/:id", restrict, (req, res) ->
  Member.findByIdAndRemove req.params.id, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")


### VIDEO ###

app.get "/api/video", (req, res) ->
  Video.find {}, (err, results) ->
    return res.json(status: "ERR", message: err) if err
    res.json(results)

app.post "/api/video", restrict, (req, res) ->
  Video.create req.body, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK", _id: result._id)

app.put "/api/video/:id", restrict, (req, res) ->
  delete req.body._id
  Video.update {"_id": mg.Types.ObjectId(req.params.id)}, req.body, upsert: yes, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

app.del "/api/video/:id", restrict, (req, res) ->
  Video.findByIdAndRemove req.params.id, (err, result) ->
    return res.json(status: "ERR", message: err) if err
    res.json(status: "OK")

### ALL ###

app.all "*", restrict, (req, res) ->
  res.render("index")

port = process.env.PORT || 5001
app.listen(port)
console.log "start server on port #{port}".green
