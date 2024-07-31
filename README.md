spell_it
 
MVVM (Model-View-ViewModel) 


 ![Project Structure Diagram](https://github.com/user-attachments/assets/a565eda4-6396-4649-91f0-a0606fa528be)








![1](https://github.com/user-attachments/assets/8b321127-d87f-4f50-b247-7f11861be8e5)




![2](https://github.com/user-attachments/assets/063f5101-8a85-44e0-9b6b-517d1d319a28)








![3](https://github.com/user-attachments/assets/a063e626-1d17-4b4a-9689-43f2409032dc)





![4](https://github.com/user-attachments/assets/ec816682-1038-4eef-aad4-ff14be413fde)






![5](https://github.com/user-attachments/assets/59e53a15-3fb5-4d2f-852e-a0bbe28d9a03)


Features of the Changes

    State Management: ChangeNotifier from the provider package is used to manage state and facilitate communication between the data model and UI. This approach allows for structured and efficient game state management.

    Level Reset: Added the _resetLevelsToDefault method to reset the levels to default values when all levels are completed successfully. This feature supports managing new levels after all current levels are finished.

    Question and Answer Management: Enhanced question and answer management with real-time feedback to the user based on their answers. This improves user experience by providing immediate feedback.

    Voice Interaction: Integrated FlutterTts for text-to-speech functionality, allowing the game to read words aloud, enhancing user interaction and engagement.

    Locked Level Handling: Implemented a dialog to inform users when attempting to access a locked level, prompting them to complete previous levels to unlock the desired one.


