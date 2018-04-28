KsMyVoteInfo
=========================

KsMyVoteInfo Ruby gem makes it easy to search the Kansas SOS voter registration site
for the registrant details. You supply first/last name, dob and county, this gem looks
it up and return the HTML snippet from the site.

MIT license.

# Example

```ruby
require 'ksmyvoteinfo'

ksmvi = KsMyVoteInfo.new
if details = ksmvi.lookup(first_name: 'Some', last_name: 'Body', dob: 'january 1, 1970', county: 'Douglas')
  puts details
else
  puts "Sorry, no details for Some Body in Douglas county."
end
```

Copyright 2018 Peter Karman
