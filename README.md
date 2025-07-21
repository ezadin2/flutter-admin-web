                WELCOME TO [E-COMMERCE ADMIN_PAREL]
    Greeting,

    We extend our sincere appreciation for your interest in [T_Admin_Panel]. This repository houses a robust e-commerce solution developed using the Plotter framework. Every line of code here reflects our commitment to quality, efficiency, and scalability.

    We're dedicated to continuous improvement and we welcome feedback to make this solution even more industry-leading. Blue in, explore, and let's innovate together.

    Regards,
    Coding us

## Install dependencies:
   flutter pub get

## Setup Firebase Project


## Customers not showing [Create Index in Firestore Firebase]
Add index in the FireStore index by going into Firebase console of your project.
Select Firestore databse and then select indexes from top menu.
Click on Add index button in the composite tab and fill the form as below.

    Collection Id=Users
    Fields to index:
    FirstName =Ascending
    __name__= Ascending
    Query Scopes=Collection

Note: In the **name** there are two underscores at the start and end.
Wait for the Index to be Enabled.


## Media Unable to load Images [Create Index in Firestore Firebase]
Add index in the FireStore index by going into Firebase console of your project.
Select Firestore databse and then select indexes from top menu.
Click on Add index button in the composite tab and fill the form as below.

    Collection Id=Images
    Fields to index:
    mediaCategory =Ascending
    createdAt=Descending
    __name__= Descending
    Query Scopes=Collection

Note: In the **name** there are two underscores at the start and end.
Wait for the Index to be Enabled.


## Enable CORS to view Images
Login to your google cloud console: https://console.cloud.google.com/home.
Select the same Firebase Project from the top left menu.
Click on "Activate Google Cloud Shell" in the upper right corner icon.

At the bottom of your window, a shell terminal will be shown, where gcloud and gsutil are already available. Execute the command shown below. It creates a json-file which is needed to setup the core-configuration for your bucket. This configuration will allow every domain to access your bucket using XML-Requests in the browser.

    echo '[{"origin": ["*"],"responseHeader": ["Content-Type"],"method": ["GET", "HEAD"],"maxAgeSeconds": 3600}]' > core-config.json
Replace --YOUR_BUCKET_NAME-- with your actual bucket which is in the
Firebase Console -> Storage -> Copy the gs://... bucket name and replace with the below command.

    gsutil core set core-config.json gs://YOUR_BUCKET_NAME
Run this command in the Google shell terminal and you are done.

To check if everything worked as expected, you can get the core-settings of a bucket with the following command:

     gsutil core get gs://YOUR_BUCKET_NAME
# **Register Admin**
- Go to lib => future => authentication => screen => login =>widgets => login_form.dart
- Find Elevation() in the end
- Replace controller.emailAndPasswordSignIn() with controller.registerAdmin()
- 'Modify Admin Credentials'
- Go to lib=>utils=>constants=>text_string.dart
- Change adminEmail ans adminPassword
- 'Sing In'
- Run the code amd press 'Register Admin' button
- 'Modify SignIn button function'
- After Logged in
- Go to lib=>feature=>authentication=>screen=>login=>login_form.dart
- Replace controller.registerAdmin() with controller.emailAndPasswordSignIn()



## Firebase Hosting
### Prerequisites
B

