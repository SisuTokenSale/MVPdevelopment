# SISU

## Getting Started
- **Clone:**
```bash
git clone git@github.com:SisuTokenSale/MVPdevelopment.git \
&& cd MVPdevelopment
```

- **Configuring:**
```bash
cat > .env << EOF
PORT=3000
DB_POOL=5
DB_REAPING_FREQUENCY=10
MAX_THREADS=5
#DATABASE_URL=localhost
REDIS_URL=redis://localhost:6379/1
EMAIL_RECIPIENTS=dmitriy.bielorusov@syndicode.com
SECRET_KEY_BASE=c9af93d4128fb7cb3caa27610d1b889fe2e3b85018323c5dd101ea6e4b62d38847beb8948d823de24f674c2fec096825504adb2d1ee6b8d3039d859c6b59512d
APPLICATION_HOST=localhost
SMTP_ADDRESS=smtp.mailtrap.io
SMTP_AUTH=cram_md5
SMTP_DOMAIN=smtp.mailtrap.io
SMTP_PASSWORD=605f232a15d3ba
SMTP_USERNAME=52de78f2a6c277
WEB_CONCURRENCY=2
MAX_THREADS=2
RACK_ENV=development
DWOLLA_APP_KEY=LLxv509vkpvZEcDM4swbO5De4yVGvrkYq1KoPYo0487OUNeCV7
DWOLLA_APP_SECRET=o6AlyWTrDd9Jgoe9st35zE2A6LHHwk6WtMXFvXuZrijKzHD6aQ
PLAID_CLIENT_ID=5bab5d496ae04e00139959c6
PLAID_SECRET=9a1a79c362bed984829b882260a313
PLAID_PUBLIC_KEY=521f8b04497f105c07843610261809
PLAID_ENV=sandbox
EOF
```

- **Setup:**
```bash
./bin/setup
```

- **Reload Spring:**
```
bin/spring stop
```

- **Run app:**
**
```bash
heroku local
```

## Deploying
If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

```bash
./bin/deploy staging
./bin/deploy production
```

## Testing

```bash
RAILS_ENV=test rake db:environment:set db:drop db:create db:migrate && rspec
rubocop --auto-correct
```

### Manual deployment

## Add Heroku staging and production
```bash
git remote add staging https://git.heroku.com/sisu-staging.git
git remote add production https://git.heroku.com/sisu-prod.git    
```

## Deploy 
- **Staging:**
```bash
git push -f staging current-branch-name:master
```

- **Production:**
```bash
git push -f production current-branch-name:master
```
