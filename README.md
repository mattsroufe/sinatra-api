
# A basic API using JSON Web Tokens for authentication.

```
bundle install
```

```
rackup config.ru
```

```
curl -v -X POST 'localhost:5000/auth' -d "email=<email>&password=<password>" -H "Accept: application/json"
curl -v -X POST 'localhost:5000/auth' -d '{"email": "<email>", "password": "<password>"}' -H "Accept: application/json" -H "Content-Type: application/json"
```
```
curl 'localhost:5000/accounts' --cookie "access_token=<token>" -H "Accept: application/json"
```
