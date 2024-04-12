# Step to build project
Open the what3words.xcodeproj and wait until all package dependencies and run app

# What I have completed in the project
1. Use https://developer.themoviedb.org/reference/trending-movies to get the trending movies for today and create an infinite list (query the next page as it scrolls)
2. This should work offline after first use by caching the results, the  cache should persist between application sessions and device reboots.results
3. The movie list item should include an image, movie title, year and vote average
4. Add a search field and allow searching movies using https://developer.themoviedb.org/reference/search-movie, when the search field is empty go back to showing the trending movies (search doesn’t need to work offline)
5. Present a detail view when a movie is tapped. Get info for the view using https://developer.themoviedb.org/reference/movie-details.  Also cache this detail info to make it work off-line for any items that were previously queried and viewed.
6. Create Unit Tests
7. Make search work offline by searching cached results
8. Error message handling (offline/online/failed API calls)

# Architecture overview
I use `Clean Architecture` and `MVVM` for this project.

For the local storage I use Core Data for it
## High Level Overview

<img width="600" alt="High Level Overview" src="images/CleanArchitecture.jpg">

Domain Layer: Entities + Use Cases + Gateway Protocols

Data Layer: Gateway Implementations + API (Network) + Database

Presentation Layer: ViewModels + Views + Navigator + Scene Use Cases

# Demo
https://youtu.be/clw_YrU462g?si=TwKvW9OmAhJLJwog
