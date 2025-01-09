# mis

A new Flutter project.

## Getting Started

1. Login Screen Layout Design
Details:
Designing the structure and layout of the login screen, including form fields (username, password), login button, and any additional elements like a logo or a link to the registration page.
Implementing basic validation (e.g., username and password fields cannot be empty).
Time Spent: 4 hours
Research & planning: 1 hour
UI design and layout implementation: 2 hours
Basic validation & testing: 1 hour


2. Login Screen Functionality
Details:
Adding logic to handle user authentication (e.g., verifying credentials via API or local database).
Handling success and failure states (e.g., navigating to the next screen on successful login, showing an error message if credentials are wrong).
Time Spent: 3 hours
Authentication API integration: 2 hours
Handling login response and error states: 1 hour

3. UI Enhancements (Animations, Transitions)
Details:
Adding subtle animations like fade-in/fade-out effects for buttons or input fields to enhance user experience.
Creating smooth transitions when navigating to the next screen.
Time Spent: 2 hours
Implementing animations: 1 hour
Refining transitions and animations: 1 hour


4. User Testing and Debugging
Details:
Testing the login screen on different devices/emulators.
Fixing bugs, addressing edge cases, and ensuring the UI looks good on various screen sizes.
Time Spent: 2 hours
Testing: 1 hour
Bug fixing & debugging: 1 hour

5. Final Review and Documentation
Details:
Reviewing the code and ensuring everything is functioning correctly.
Writing documentation for the login screen's functionality and layout for future reference or handoff to another developer.
Time Spent: 1 hour
Final code review: 0.5 hours
Writing documentation: 0.5 hours
Total Time Spent on Login Screen: 12 hours


Screen 2: Dashboard
Details:
Display the user’s current location (latitude and longitude) on the screen by using a location service.
The check-in date and time should be blank by default when the page loads.
When the 'switch' button is clicked, the check-in date and time should be displayed.
Include UI elements like the current location (e.g., 'Faridabad, Haryana'), a switch button for check-in, and a time/date label for the check-in time.
Time Spent: 5 hours
Location API setup and integration: 2 hours
UI layout and design for Dashboard screen: 1.5 hours
Implementing check-in functionality (conditional display of check-in time): 1 hour
Testing the screen and debugging: 0.5 hours


Screen 3: Check-In
Details:
The screen allows users to check in to mark their attendance.
When the user clicks the check-in button, the current date and time are captured and displayed.
The location is captured and stored along with the check-in time.
Time Spent: 4 hours
UI design for check-in button and date-time display: 1 hour
Location API integration for capturing check-in location: 1 hour
Storing check-in data (location, time) in a database or SharedPreferences: 1.5 hours
Testing and debugging check-in functionality: 0.5 hours


Screen 4: Attendance History
Details:
This screen should display the user's attendance history, including the locations, times, and dates for all check-ins and check-outs.
Include a map view at the top of the screen, followed by a list view that displays individual attendance records.
Each record should display a circular icon for the location, time, and date of check-in.
A vertical divider should be added between the location icons and the time/date for clean UI separation.
Time Spent: 6 hours
Map view integration for displaying locations: 2 hours
UI design for displaying the attendance records (list view, time, location): 2 hours
Implementing vertical dividers and proper layout management: 1 hour
Testing and debugging: 1 hour


Screen 5: Check-Out
Details:
This screen allows users to check out when they are done with their job.
Clicking the 'green button' will log the check-out time, update the attendance status, and display the check-out time on the screen.
Ensure that after clicking the button, the job status is updated accordingly.
Time Spent: 3 hours
UI design for check-out button and status update: 1 hour
Implementing logic to store check-out time and update the job status: 1 hour
Testing and debugging the check-out process: 1 hour


Screen 6: View Particular Attendance History
Details:
This screen displays the details of a particular attendance history entry.
It should show all relevant information about the selected check-in/check-out, including location, check-in/check-out times, and job status.
Time Spent: 3 hours
UI design to show detailed attendance information: 1.5 hours
Fetching and displaying the correct data from the database: 1 hour
Testing and debugging: 0.5 hours


Total Time Spent on All Screens: 48 hours
