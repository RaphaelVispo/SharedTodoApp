# User Authentication and Automated Tests
## Exer 7

## Student Information 
* Name : Raphael S. Vispo
* Strudent Number : 2021-10210
* Section : D3L

## App Description 
The app is a todo app with user Authentication. The authentication can also add users first name and last name in database. The app also supplies Test cases of 2 of each happy and unhappy paths.

## Screenshots

Log in screen 

![login Screen](loginSC.PNG)

Sign up screen showing the validation errors

![login Screen](signupSC.PNG)


## Things that you did in the code

For the validation, I used the the forms and the textFormfields. The email validation I used Regex. I also added an firstNAme and lastName when signing up the user, and this is stored in the database using the providers and firebase api.

## Challenges faced

* The validation of email  is difficult, i solved it by this [link](https://stackoverflow.com/questions/16800540/how-should-i-check-if-the-input-is-an-email-address-in-flutter)

## Test Cases

The following are the test cases that I implemented for test.
The following are for the  `signUpPage`

### Happy Paths

* All widgets will be shown in the field
* if all are the fields have a valid input and the user signed up, the screen will pop and will go to the `TodoPage`

### Unhapppy Paths
*  Error will be shown if the user has invalid email and password
* Error will be shown if the user inputter nothing in the text field