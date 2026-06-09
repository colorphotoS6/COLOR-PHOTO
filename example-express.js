// example-express.js
// Minimal Express + Passport Google OAuth2 example for local testing
// Usage:
// 1) npm init -y
// 2) npm install express passport passport-google-oauth20 express-session
// 3) set env vars GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET (see README below)
// 4) node example-express.js

const express = require('express');
const session = require('express-session');
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

const PORT = process.env.PORT || 3000;
const CLIENT_ID = process.env.GOOGLE_CLIENT_ID || '<YOUR_CLIENT_ID>';
const CLIENT_SECRET = process.env.GOOGLE_CLIENT_SECRET || '<YOUR_CLIENT_SECRET>';
const CALLBACK_URL = process.env.GOOGLE_CALLBACK_URL || `http://localhost:${PORT}/oauth2/redirect/google`;

if (CLIENT_ID.startsWith('<YOUR') || CLIENT_SECRET.startsWith('<YOUR')) {
  console.warn('\n[WARN] GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET not set.\n' +
               'Set environment variables before testing login.\n');
}

passport.serializeUser((user, done) => done(null, user));
passport.deserializeUser((obj, done) => done(null, obj));

passport.use(new GoogleStrategy({
  clientID: CLIENT_ID,
  clientSecret: CLIENT_SECRET,
  callbackURL: CALLBACK_URL
}, (accessToken, refreshToken, profile, cb) => {
  // In production, find or create a user record in DB here.
  return cb(null, profile);
}));

const app = express();

app.use(session({
  secret: process.env.SESSION_SECRET || 'change-me',
  resave: false,
  saveUninitialized: true
}));

app.use(passport.initialize());
app.use(passport.session());

app.get('/', (req, res) => {
  if (req.user) {
    const photo = (req.user.photos && req.user.photos[0] && req.user.photos[0].value) || '';
    res.send(`
      <h1>Xin chào, ${req.user.displayName}</h1>
      <img src="${photo}" alt="avatar" width="96" style="border-radius:48px"/>
      <p>Email: ${(req.user.emails && req.user.emails[0] && req.user.emails[0].value) || 'N/A'}</p>
      <p><a href="/logout">Đăng xuất</a></p>
    `);
  } else {
    res.send(`
      <h1>Không đăng nhập</h1>
      <a href="/login/google">Đăng nhập bằng Google</a> |
      <a href="/login/mock">Đăng nhập giả lập (dev only)</a>
    `);
  }
});

// Redirect user to Google for authentication
app.get('/login/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Google will redirect the user to this URL after approval
app.get('/oauth2/redirect/google',
  passport.authenticate('google', { failureRedirect: '/' }),
  (req, res) => {
    res.redirect('/');
  }
);

// Mock login for local development without Google OAuth registration.
app.get('/login/mock', (req, res, next) => {
  const mockUser = {
    id: 'mock-123',
    displayName: 'Người Dùng Thử',
    name: { familyName: 'Thử', givenName: 'Người' },
    emails: [{ value: 'test@example.com', verified: true }],
    photos: [{ value: 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y' }]
  };
  req.login(mockUser, function(err) {
    if (err) { return next(err); }
    res.redirect('/');
  });
});

app.get('/logout', (req, res, next) => {
  // passport >=0.6 requires callback
  req.logout(function(err) {
    if (err) { return next(err); }
    res.redirect('/');
  });
});

app.listen(PORT, () => {
  console.log(`Server listening: http://localhost:${PORT}`);
  console.log(`Callback URL (register this in Google Console): ${CALLBACK_URL}`);
});
