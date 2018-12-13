# Lane Breach

This is the public repository for all of the code associated with Lane Breach, a
digital platform for bringing safety to the cyclists riding along the streets of
San Francisco.

## Our Mission

We want to create an online platform that serves as the centerpoint for cyclist
data in San Francisco. By combining datasets from the
[city](https://data.sfgov.org/City-Infrastructure/311-Cases/vw6y-z8j6), the
SFMTA, and the CHP, we hope to paint a complete picture of the dangers that face
bicyclists in the city. This dataset is intended to be used by anyone who wants
a better understanding about what factors lead to the large number of bicycle
incidents on our streets each year.

## Current Status

Rome wasn't built in a day. To get started, we will be focusing on two main
user-facing applications:

- A [web-app](http://www.lanebreach.org) to display correlated data information
- An iPhone app to streamline reporting of bike lane obstructions to SF's 311
  database.
- A [Twitter bot](https://twitter.com/bikelanes_sf) that posts interesting interpretations from our database and provides
  a space to promote and discuss commuter saftey for cyclists. 
  
These applications will be tied together by a back-end service that
pulls data from various sources and combines them into a single PostgreSQL
database hosted on AWS.

## Contributing

We welcome contributions! All of our contributors are expected to follow the
rules outlined in our Code of Conduct. Please create a separate pull request
against master for each new feature/bug-fix. We will try to use Github issues
whenever possible to describe tasks that we need to do.

Steps for building the various apps, and an overview of the design can be found
on the wiki. We're excited to see your PRs!
