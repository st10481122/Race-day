# Race-day
About race day
1. Initialise RaceDay repository
2. Add project README
3. Create docs folder
4. Add Users database design
5. Add Events database design
6. Add Categories database design
7. Add Enrolments database design
8. Add Results database design
9. Add EventRoutes database design
10. Define ERD relationships
11. Finalise ERD cardinalities
12. Add RaceDay ERD document
13. Create API endpoint plan
14. Add authentication endpoints
15. Add event and category endpoints
16. Add enrolment endpoints
17. Add results endpoints
18. Add RaceDay SQL database script
19. Add SQL seed data and constraints
20. Add CI build screenshot
21. Add YouTube presentation link
22. The RaceDay Part 1 project presentation is available on YouTube:

[Watch the RaceDay Part 1 Presentation]
https://youtu.be/3bmEgH5MfeU?si=NtI5qgF45-1iQ3hm

PART 2

# RaceDay API

## Project Overview

RaceDay is a race event management system developed to help manage running, walking and cycling events. The API provides functions for organisers to manage events and categories, while participants can enrol in event categories and view their results.

## Technologies Used

- C#
- ASP.NET Core Web API
- .NET 8
- SQL Server
- Entity Framework Core
- JWT authentication
- Swagger / OpenAPI
- GitHub Actions

## Main Features

- User registration and login
- Role-based access for Organisers and Participants
- View and update user profiles
- View upcoming events and event details
- Create, update and delete events
- Manage event categories, distances and entry fees
- Enrol participants in event categories
- Record and view race results

## Database

The API uses the existing SQL Server database named `RaceDayDB`. It contains the following main tables:

- Roles
- Users
- Events
- Categories
- Enrolments
- Results

The API should use the existing database schema. Do not run the original database creation script against a database containing data, because it drops and recreates tables.

## Running the Project

1. Open the solution in Visual Studio.
2. Configure the `RaceDayConnection` connection string for your local SQL Server.
3. Configure the JWT issuer, audience and signing key using local development settings.
4. Restore the NuGet packages.
5. Build and run the `RaceDay.API` project.
6. Open the Swagger URL displayed by Visual Studio to test the endpoints.
7. Register test accounts for the Organiser and Participant roles and sign in to obtain JWT tokens.

## Authentication and Authorisation

The API uses JWT bearer tokens to identify logged-in users. Organiser-only endpoints require the Organiser role, while participant endpoints require the Participant role. Users should only be able to update their own profile and access records permitted by their role.

## Continuous Integration

GitHub Actions runs a build check when changes are pushed to the configured branches or a pull request is created. Automated tests should also be run through the workflow once the test project has been added to the solution.

## Project Documentation

The `docs` folder contains the planning documents from Part 1, including the database ERD, SQL script and API endpoint plan.

## Testing

The API endpoints should be tested using Swagger, including successful requests, invalid input, missing records and access-control checks. Any automated test results should be documented accurately.

## Security Note

Do not commit real passwords, production signing keys, access tokens or other secrets to GitHub. Use local development configuration or a suitable secret-management solution.


