# PeepCode download / sync

A script for downloading [PeepCode][0] screencasts (skips already-downloaded ones).

Get `auth` key by looking at your cookies while logged in to PeepCode (e.g. in
Chrome, F12 -> Resources -> Cookies; alternatively use JavaScript console and
inspect `document.cookie`).

Tested on my unlimited account.

## Synopsis

```ruby
require './peep_code'
session_pool = PeepCode::Session.pool(args: [auth: '649a5a0vciw4ex5k7129ug41x3ifqmwk4gwxci84'])
screencasts = session_pool.screencasts

# dump one screencast
s = screencasts.find{|s| s.id == 'play-by-play-aaroncorey'}
session_pool.dump_screencast('/home/abe/Dropbox/Screencasts/PeepCode', s)

# dump all screencasts asynchronously
futures = screencasts.map{|s| session_pool.future.dump_screencast('/home/abe/Dropbox/Screencasts/PeepCode', s)}
# (optional) if you want to wait for all downloads to complete:
futures.map(&:value)
```

[0]: https://peepcode.com/
