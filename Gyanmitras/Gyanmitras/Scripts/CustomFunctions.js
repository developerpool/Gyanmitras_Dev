var email_regex = /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
var mobile_regex = /\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*(\d{1,2})$/;
//Only numbers, hypens (-), plus sign (+), spaces along with round brackets ( ) like +91 1234567891
var name_regex = /^[a-zA-Z ]+$/;
//string only contains letters with one space
var password_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
//Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
var username_regex = /^[a-zA-Z][a-z0-9_.-]{4,19}$/;
    //The syntax of the username is:
    //First character = letter
    //Following chars = letter OR number OR _ (underscore) . (point) - (dash)
    //Minimum length 5 chars
    //Maximum length 20 chars

