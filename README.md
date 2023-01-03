# README

This README would normally document whatever steps are necessary to get the application up and running.

Things you may want to cover:

* Ruby version 3.1.2
* Rails version 7.0.4

### Steps to config this app:
- Clone or download this app
- Go inside app's folder
- Install and config posgresql (https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart)
- Run `bundle install`
- Run `bundle exec figaro install`

Figaro will generate for you a file `config/application.yml`. We will use the file to config some environment variables like `ENV[shorten_host]`, `ENV[db_username]`, and `ENV[db_username]`.

For example:
	db_username: `your-db-username-here`
	db_password: `your-db-password-here`
	shorten_host: `the_hostname_for_shortened_link_affter_encoded_here`

- Run `rails db:setup`
- Run `rails db:migrate`
- Run `rails server`

### How to use this app?
You can use Postman for testing two endpoints (https://learning.postman.com/docs/getting-started/introduction/):

#### POST /encode

##### Summary

Will require a `url` parameter (original URL). It should respond with a short version url after encoding.

##### Parameters
|Parameter|Type|Required|Description|
|---|:---:|:---:|---|
|url|string|yes|an original url you want to shorten|

For example:
##### Request
```
POST /encode/

```

##### Response
```
HTTP/1.1 200
Content-Type: application/json

{
  "shorten_version": "http://shorten_host/Er8eia"
}
```

#### GET /decode

##### Summary

Will require a `url` parameter (short url). It should respond to the original version url.

##### Parameters
|Parameter|Type|Required|Description|
|---|:---:|:---:|---|
|url|string|yes|a short url you revelant to an existed original url|

For example:
##### Request
```
GET /decode?url=http://shorten_host/Er8eia

```

##### Response
```
HTTP/1.1 200
Content-Type: application/json

{
  "original_version": "http://example.co.jp/some_long_character_here"
}
```

### Several problems I see while implementing this app:
- Almost people will use this app to shorten a link and share it so the `/decode` endpoint will be called more than `/endcode`. To prevent the server from getting overloaded, I use caching for the `/decode` endpoint

- Short URLs can be used by hackers to hide malicious websites and share them with people. I think we need to implement a feature that carefully scans linked websites for authenticity, and quality to ensure it’s not malicious.


### Scale up

To resolve saving malicious websites on the database mentioned above. At the current time, I can only think we need to validate url parameter more carefully. For example, we can check each component by URI like:

```
def valid_uri?(url)
    u = URI.parse(url)
    # check u.scheme, u.userinfo, etc. to ensure the url is valid before saving into database
end
```