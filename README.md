# hashman

* [Homepage](https://github.com/esurdam/hashman#readme)
* [Issues](https://github.com/esurdam/hashman/issues)
* [Documentation](http://rubydoc.info/gems/hashman/frames)
* [Email](mailto:es at cosi.io)

## Description

Add some hash magic to your ruby classes.

Use this gem to conceal ids or any integer based array.

Ideally, user a serializer to exlucde ids and include your hash.

Credits on hasher to [Peter Hellberg's Hashid](https://github.com/peterhellberg/hashids.rb)

## Features
- Hash integer and UUID based ids
- Reverse hash for lookup
- Create a hashprint based on an array of integers.
- Index your hashprint for uniqueness (Useful for payment data!) [EXAMPLE]()

## Examples

### Rails Usage
    
Include ```HashMan``` in your model
```
class User < ActiveRecord::Base
  include HashMan
  # include activuuid only if thats your style
  include activeuuid
  
  # optionally set a hash length minimum
  # useful for integer based ids
  hash_length 8 
end
```

A typical user will look like:
```
user = User.create({ :name => "awesome" })
user.id 
 => #<UUID:0x3fe2f1dda1d0 UUID:5604ee6e-c934-44cb-89ff-d2934a708e55> 
```

Generate a hash for an id (integer or uuid):
```
user.hash_id
 => "rkALRLO3rJyz3vRjx9XJrzlq6" 
```

Reverse the hash for lookup:
```
User.reverse_hash("rkALRLO3rJyz3vRjx9XJrzlq6")
 => #<UUID:0x3fe2f1d00f70 UUID:5604ee6e-c934-44cb-89ff-d2934a708e55> 
```

Hashprint sensitive data:
```
# secrets are created in userspace
secrets = {:number => 1234123412341234, :cvv => 701, :zip => 90025 }
 
# hashprint is created before saving to model
secret_hash = User.create_hashprint = [ secrets[:number], secrets[:cvv], secrets[:zip ]
=> "evALO3rJyzJrzlq6" 
 
# persist the secret
user.hashprint = secret_hash
user.save!
```
```
# Do some cool stuff in your model
def verify_cvv(cvv)
    # where [1] is the index of the value
    # `decoded_hashprint` is a private method form hashman
    cvv == self.decoded_hashprint[1]
end
  
user.verify_cvv(700)
 => false
 
user.verify_cvv(701)
 => true
```
Secret data is then hidden from prying eyes!


Index hashprint for uniqueness validation! ;)

## Standalone

    require 'hashman'

magic 

```
HashMan.encode(integer)
HashMan.create_hashprint(integer_array)
Hashman.decode(hash)

```
## Requirements

## Todo

- Auto intercept `find` method on model to allow hash_id
- I forget the others

## Install

    $ gem install hashman

## Copyright

Copyright (c) 2016 Evan Surdam

See {file:LICENSE.txt} for details.
