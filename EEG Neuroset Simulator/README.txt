EEG Neureset
April, 2024

Description:
This project is a GUI simulation of an EEG Neureset.
EEG components and functions are represented as buttons and panels.
This project only simulates the system part of an EEG Neureset.

to run code:
1. install Qt Creator using Qt Online Installer at https://doc.qt.io/qt-6/get-and-install-qt.html
2. open the project code/3004PRJ.pro with qt creator
3. click "configure" (if Qt shows the configure page)
4. run the code using qt creator (click bottom left green arrow)


youtube project demo link:
https://www.youtube.com/watch?v=fQgcmzmLnqI&ab_channel=Curtis

github repository:
https://github.com/doorknob7/3004-EEG-PRJ



Once the code is running, proper use is as follows:
1. Select a sample dataset to use by clicking "dataset 1, dataset 2, alpha,  beta, delta, theta, gamma"
2. If you desire to set the time of the session, navigate to "TIME AND DATE" in the menu by clicking on the up and down arrows.
Then, press select to enter the time and date screen. Enter the desired time using the arrows and select buttons.
3. Navigate to "NEW SESSION" and press select. This will begin the session.
4. You will be prompted to connect the sensors. Press "conncet" on the left side to connect the EEG Sensors in the headset.
5. The treatment will now begin. Notice the blue light, the flashing green light during treatment, and the red light when the 
headset is either disconnected or paused. Note: to change the speed of the device for testing, navigate to "Sessions.h", 
where you can adjust the "baseline_time" and "treatment_time" to change the speed of the treatment.
6. Upon session completion, view the session log by navigating to and selecting "SESSION LOG". It will have the time you entered before,
formatted Day/Month/Year Hour/Minute.
7. To view computer logs, press "Upload Logs" on the right, under the PC UI screen. You can also print computer logs to the console by
pressing "print computer logs" on the left.
8. After repeated uses, the battery will deplete, and can be recharged through the "charge battery" button on the left.

If there are any additional testing questions, please email one of our members at firstnamelastname@cmail.carleton.ca
