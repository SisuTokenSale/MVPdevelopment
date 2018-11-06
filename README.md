# SISU

## Links
- [Docs Folder](https://drive.google.com/drive/u/3/folders/1hm6s3MCKh15aBEJrzI13Uz2nFGiBDIG6?ogsrc=32)
- [Milestones](https://docs.google.com/document/d/1_1hm6NgHgPnIz3i1htKh8Ea5EZX4C2FAptEnj5OT5ZM/edit)
- [Prototypes](https://projects.invisionapp.com/share/DMNV0HIBEFV#/screens/317951060)
- [Estimates](https://docs.google.com/spreadsheets/d/11xuN_goyHp8Yz2HC-zeLeU5SnRhh0GsHMW6NuIw1rNs/edit#gid=947080547)
- [Mockups](https://www.figma.com/proto/W0U6m5sqDqMV5jA4gBZKMpRB/Sisu?node-id=2%3A141&viewport=-163%2C-2047%2C0.253616&scaling=scale-down-width)

## Getting Started
- **Clone:**
```bash
git clone git@github.com:SisuTokenSale/MVPdevelopment.git \
&& cd MVPdevelopment
```

- **Configuring:**
```bash
cat > .env << EOF
RACK_ENV=development
PORT=3000
DB_POOL=5
DB_REAPING_FREQUENCY=10
MAX_THREADS=5
REDIS_URL=redis://localhost:6379/1
EMAIL_RECIPIENTS=dmitriy.bielorusov@syndicode.com
SECRET_KEY_BASE=c9af93d4128fb7cb3caa27610d1b889fe2e3b85018323c5dd101ea6e4b62d38847beb8948d823de24f674c2fec096825504adb2d1ee6b8d3039d859c6b59512d
APPLICATION_HOST=localhost
SMTP_PORT=2525
SMTP_ADDRESS=smtp.mailtrap.io
SMTP_AUTH=cram_md5
SMTP_DOMAIN=smtp.mailtrap.io
SMTP_PASSWORD=605f232a15d3ba
SMTP_USERNAME=52de78f2a6c277
WEB_CONCURRENCY=2
DWOLLA_ENV=sandbox
DWOLLA_APP_KEY=LLxv509vkpvZEcDM4swbO5De4yVGvrkYq1KoPYo0487OUNeCV7
DWOLLA_APP_SECRET=o6AlyWTrDd9Jgoe9st35zE2A6LHHwk6WtMXFvXuZrijKzHD6aQ
PLAID_CLIENT_ID=5bab5d496ae04e00139959c6
PLAID_SECRET=9a1a79c362bed984829b882260a313
PLAID_PUBLIC_KEY=521f8b04497f105c07843610261809
PLAID_ENV=sandbox
RECAPTCHA_SITE_KEY=6LfWqXQUAAAAACWljYMCuABTQ7EZCpyKdtHePYIS
RECAPTCHA_SECRET_KEY=6LfWqXQUAAAAALHAb6x24zzr2EAWS7tP33xaq1Gm
ROLLBAR_ENV=development
ROLLBAR_TOKEN=4adf54cdddc24b31a95a5eff29051a45
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
```bash
heroku local
```

- **Sidekiq:**
```bash
bundle exec sidekiq -e development
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
rubocop
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
