
# A basic API using JSON Web Tokens for authentication.

Get the employees database:
```
git clone git@github.com:datacharmer/test_db.git
cd test_db
mysql < employees.sql
mysql -t < test_employees_md5.sql
mysql employees
```
```
bundle install
```
```
bundle exec rake db:setup
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
