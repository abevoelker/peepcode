# PeepCode dump

A script for dumping [PeepCode][0] screencasts.  Get `auth` key by looking at your
cookies while logged in to PeepCode (e.g. in Chrome, F12 -> Resources -> Cookies).

## Synopsis

```ruby
require './peep_code'
session_pool = PeepCode::Session.pool(args: [auth: '649a5a0vciw4ex5k7129ug41x3ifqmwk4gwxci84'])
screencasts = session_pool.screencasts

# dump one screencast
s = screencasts.find{|s| s.id == 'play-by-play-aaroncorey'}
session_pool.dump_screencast('/home/abe/Dropbox/Screencasts/PeepCode', s)

# dump all screencasts asynchronously (add .map(&:value) to end if you want to block on this line)
screencasts.map{|s| session_pool.future.dump_screencast('/home/abe/Dropbox/Screencasts/PeepCode', s)}
```

[0]: https://peepcode.com/
