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

- A web-app to display correlated data information
- An iPhone app to streamline reporting of bike lane obstructions to SF's 311
  database.
  
Both of these applications will be tied together by a back-end service that
pulls data from various sources and combines them into a single PostgreSQL
database hosted on AWS.
