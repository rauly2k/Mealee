Hello I need to have these things done


1. a plan for a python program Python desktop application that accepts YouTube video links (cooking recipes), extracts their content, processes them using the Google Gemini API, and exports them as a structured JSON file ready for import into the app as recipes.

Core Requirements

Language: The application GUI must be in Romanian. The generated recipe content (title, instructions, ingredients) must also be in Romanian.

Input: A text field or list area to input one or multiple YouTube links.

Processing:

Extract the transcript from the YouTube video.

Send the transcript to Google Gemini API.

Gemini must summarize/rewrite the transcript into a structured recipe.

Tags System: The app must have a pre-defined list of "Available Tags" (e.g., Vegan, Desert, Fel Principal, Rapid). Gemini must analyze the recipe and select only the relevant tags from this specific list.

Output: A JSON file where:

Keys are in English (e.g., id, title, ingredients).

Values are in Romanian (e.g., title: "Ciorbă de perișoare").

Read everything about my app to define everything needed like tags etc to align with my app

mplementation Steps for the Code

Step A: GUI Layout (Romanian Labels)

Window Title: "Generator Rețete YouTube"

API Key Input: A field to enter the Google Gemini API Key.

Tags Input: A text area to paste/edit the list of "Available Tags" (comma-separated).

URL Input: A multi-line text box to paste YouTube links (one per line).

Button: "Generează Rețete" (Generate Recipes).

Log/Output Area: To show progress (e.g., "Processing video 1...", "Done.").

Step B: Transcript Extraction Logic
link sent to gemini api 2.5pro model and it will do the job.

Write the prompt perfect for gemini to define the best output for my app so i can have recipes import only with a click not to change anything

