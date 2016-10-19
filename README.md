# CORPORATE EXPENSES TRACKER API

This app keep track of travel expenses of its employees and simplify the process of refund total travel expenses to each employee.

## Getting Started

* Using Ruby version: ruby-2.3.1

* Using bundler 1.11.2

* Using rails 5.0.1


1. Switch to project folder:

        $ cd corporate-expenses-tracker-api

2. System dependencies

        $ bundle install 

3. Database creation

        $ rake db:create
        $ rake db:migrate
        $ rake db:seed 		#-- Create an admin user

4. Start the web server:

        $ rails server -b 0.0.0.0

5. Using a browser, go to `http://localhost:3000` and you'll see:
"Login page"



## Testing 


1. Switch to project folder:

        $ cd corporate-expenses-tracker-api

2. Prepare the database

		$ rake db:create RAILS_ENV=test
        $ rake db:migrate RAILS_ENV=test

3. Run all tests
		
		$ rspec spec


## Best practices

* Use Versioning

```ruby
	namespace :api, defaults: { format: :json } do
		scope module: :v1, constraints: ApiConstraints.new( version: 1, default: :true ) do

			#-- Resources routes here

		end
	end
```
		
* Use HTTP Status Codes Correctly
	
		200 ->	OK
		201 ->	Created
		204 ->	No Content
		401 ->	Unauthorized
		403 ->	Forbidden
		404 ->	Not found
		422 ->	Unprocessable Entity

* Use of HTTP verbs

		GET 	->	Retrieve and only retrieve data. Never change any data within a GET request.
		POST	->	Create a new resource
		PATCH	->	Update an existing resource (partially)
		DELETE	->	Remove a resource

* Use Json Web Token Authentication


# CORPORATE EXPENSES TRACKER APP

