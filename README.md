# recipes
# recipes
### Steps to Run the App
1.Go to Recipes.xcworkspace
2.Go to Product and click run

##Steps to run tests
1.Go to Recipes.xcworkspace
2.Go to Product and click test

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused on handling malformed and empty JSON data gracefully, as this is critical for creating a reliable user experience. I also worked on implementing clear, efficient error messages for scenarios like server issues or empty datasets to enhance user feedback. Additionally, I ensured test coverage for critical functionalities to maintain code reliability.
### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
2 hours: Setting up the project structure, integrating dependencies, and configuring the API.
2 hours: Implementing core functionalities like data fetching, error handling, and displaying recipes.
3 hours: Writing unit tests and ensuring comprehensive test coverage.
2 hours: Debugging, optimizing code, and refining the UI for edge cases like empty or malformed data.
### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
Mock Network Session for Testing: Instead of testing against live endpoints, I created a mock session to ensure predictable results. While this isolates testing, it doesn’t verify live data reliability.
Focus on Core Functionality Over Custom Design: I chose to focus on functionality and robust error handling rather than heavily customizing the UI, ensuring the app behaves correctly under all scenarios.
### Weakest Part of the Project: What do you think is the weakest part of your project?
The weakest part of the project is the UI customization. While functional and user-friendly, the UI could be improved with additional design elements like animations, detailed empty states, or more advanced styling. Another area that could be improved is adding automated UI tests to complement the existing unit tests.
### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
SDWebImageSwiftUI: For efficient image loading and caching. It improves performance when displaying recipe images.
### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Insights: Handling malformed and empty datasets was a valuable exercise in building fault-tolerant applications. It reinforced the importance of testing edge cases.
Future Improvements: Adding detailed user feedback for each error type (e.g., specific messages for server downtime vs. empty results), integrating localization for multi-language support, and refining the project structure for scalability.
