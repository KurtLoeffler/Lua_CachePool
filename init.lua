local currentDir = (...) and (...):gsub('%.init$', '').."." or ""
return require(currentDir.."CachePool")
