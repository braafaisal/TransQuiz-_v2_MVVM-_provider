spell_it
 
MVVM (Model-View-ViewModel) 
 
 Features of the Changes

    State Management: ChangeNotifier from the provider package is used to manage state and facilitate communication between the data model and UI. This approach allows for structured and efficient game state management.

    Level Reset: Added the _resetLevelsToDefault method to reset the levels to default values when all levels are completed successfully. This feature supports managing new levels after all current levels are finished.

    Question and Answer Management: Enhanced question and answer management with real-time feedback to the user based on their answers. This improves user experience by providing immediate feedback.

    Voice Interaction: Integrated FlutterTts for text-to-speech functionality, allowing the game to read words aloud, enhancing user interaction and engagement.

    Locked Level Handling: Implemented a dialog to inform users when attempting to access a locked level, prompting them to complete previous levels to unlock the desired one.


