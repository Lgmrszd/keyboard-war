whitelist = { 'love', 'arg' }

{
  whitelist_globals: {
    ["."]: whitelist,
  }

  -- general whitelist for unused variables if desired for
  -- some reason
  whitelist_unused: {
    ["."]: {},
  }
}
