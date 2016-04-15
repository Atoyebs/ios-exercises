import UIKit

/*

Strings

*/

func favoriteCheeseStringWithCheese(cheese: String) -> String {
    // WORK HERE
    
    let partialString = "My favorite cheese is \(cheese)"
    
    return partialString
}

let fullSentence = favoriteCheeseStringWithCheese("cheddar")
// Make fullSentence say "My favorite cheese is cheddar."



/*

Arrays & Dictionaries

*/

var numberArray = [1, 2, 3, 4]
// Add 5 to this array
// WORK HERE

numberArray.append(5)



var numberDictionary = [1 : "one", 2 : "two", 3 : "three", 4 : "four"]
// Add 5 : "five" to this dictionary
// WORK HERE

numberDictionary.updateValue("five", forKey: 5)




/*

Loops

*/

// Use a closed range loop to print 1 - 10, inclusively
// WORK HERE

for number in 1...10
{
    print("printed number for full closed loop is \(number)")
}


// Use a half-closed range loop to print 1 - 10, inclusively
// WORK HERE

print("\n")

for number in 1 ..< 11
{
   print("printed number for half closed loop is \(number)")
}



//a dictionary called worf
let worf = [
    "name": "Worf",
    "rank": "lieutenant",
    "information": "son of Mogh, slayer of Gowron",
    "favorite drink": "prune juice",
    "quote" : "Today is a good day to die."]

//a dictionary called picard
let picard = [
    "name": "Jean-Luc Picard",
    "rank": "captain",
    "information": "Captain of the USS Enterprise",
    "favorite drink": "tea, Earl Grey, hot"]

//an array that holds two dictionaries
let characters = [worf, picard]


//this function will take an array of dictionaries as an argument and return an array of strings
func favoriteDrinksArrayForCharacters(characters:[[String : String]]) -> [String] {
    
    // return an array of favorite drinks, like ["prune juice", "tea, Earl Grey, hot"]
    // WORK HERE
    
    var arrayOfFavoriteDrinks = [String]()
    
    for characterDictionary in characters {
    
        let character = characterDictionary["favorite drink"]
        
        arrayOfFavoriteDrinks.append(character!)
        
    }
    
    return arrayOfFavoriteDrinks
}

let favoriteDrinks = favoriteDrinksArrayForCharacters(characters)

favoriteDrinks

/*

Optionals

*/

//takes in a dictionary of string key and value pair and returns a string
func emailFromUserDict(userDict : [String : String]) -> String {
    // Return the user's email address from userDict, or return "" if they don't have one
    // WORK HERE
    
    var finalEmailAddress: String

    if userDict["email"] != nil
    {
        finalEmailAddress = userDict["email"]!
    }
    else
    {
        finalEmailAddress = ""
    }
    
    return finalEmailAddress
    
}


let mostafaElSayedUser = ["name" : "Mostafa A. El-Sayed", "occupation" : "Chemical Physicist", "email" : "mael-sayed@gatech.edu", "awards" : "Langmuir Award in Chemical Physics, Arabian Nobel Prize, Ahmed Zewail prize, The Class of 1943 Distinguished Professor, 2007 US National Medal of Science", "birthday" : "8 May 1933"]

let marjorieBrowneUser = ["name" : "Marjorie Lee Browne", "occupation" : "Mathematician", "birthday" : "September 9, 1914"]


// If your emailFromUserDict function is implemented correctly, both of these should output "true":

emailFromUserDict(mostafaElSayedUser) == "mael-sayed@gatech.edu"
emailFromUserDict(marjorieBrowneUser) == ""


/*

Functions

*/

// Make a function that inputs an array of strings and outputs the strings separated by a semicolon

let strings = ["milk", "eggs", "bread", "challah"]

// WORK HERE - make your function and pass `strings` in

func stringsSeparatedBySemiColon(passedArray:[String]) -> String {
    
    let newString = passedArray.joinWithSeparator(";")
    
    return newString
}

let expectedOutput = "milk;eggs;bread;challah"

stringsSeparatedBySemiColon(strings) == expectedOutput


/*

Closures

*/

let cerealArray = ["Golden Grahams", "Cheerios", "Trix", "Cap'n Crunch OOPS! All Berries", "Cookie Crisp"]

// Use a closure to sort this array alphabetically

let sortedCerealArray = cerealArray.sort { (cereal1, cereal2) -> Bool in
    cereal1.localizedCaseInsensitiveCompare(cereal2) == NSComparisonResult.OrderedAscending
}


print(sortedCerealArray)


//sorted method is now deprecated and .sort method is used on the array itself

// WORK HERE
