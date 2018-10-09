%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/srvices
].each { |path| Spring.watch(path) }
