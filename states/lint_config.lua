local whitelist = {
  'love',
  'arg'
}
return {
  whitelist_globals = {
    ["."] = whitelist
  },
  whitelist_unused = {
    ["."] = { }
  }
}
