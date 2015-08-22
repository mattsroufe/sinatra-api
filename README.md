
A basic api using JSON Web Tokens for authentication.

curl -X POST 'localhost:5000/auth' -d "email=<email>&password=<password>" -H "Accept: application/json"
curl -X POST 'localhost:5000/auth' -d '{"email": "<email>", "password": "<password>"}' -H "Accept: application/json" -H "Content-Type: application/json"

curl 'localhost:5000/accounts' -H "Accept: application/json" -H "Authorization: <token>" -H "Content-Type: application/json"
