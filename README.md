# product_list

A new Flutter application.

# Dart & Flutter SDK
Dart : 2.8.4
Flutter : 1.17.5

## About the api_call.dart class
I used to break down services into three packages/classes for each.
One for endpoints: listing all endpoints. One for API: handling the http call of a certain API. 
One for repository: handling the API call in a simpler way to be used on the state management.

And for the http call or to store headers, I used to put it on a separated class, i.e. http_helper.dart.
And put the url base on a different class as well, i.e. url_base.dart, so that it will be easier if we need to manage the data.

Because this is a simple app, I want to keep it as simple as possible,
so I put all services in one class. I think for this case study, this approach, will be much easier to manage.

PS : sometimes it takes seconds to load based on the internet speed.
I print the response to see if the API Request is successful or not.
If you have any questions or considerations, please reach me out.

Thank you! 

-victoriavhe