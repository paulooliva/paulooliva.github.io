# Simple Python phonebook

class Person:

    def __init__(self, name, age):
        # instance variables, unique to each Person
        self.name = name
        self.age = age

    def __str__(self):
        return "Name: " + self.name + "\n" + "Age: " + self.age + "\n"

persons = []

def createPerson():
    print("\nNew person")
    name = input('  | Name : ')
    age  = input('  | Age  : ')
    print("Creating person...\n")
    person = Person(name, age)
    persons.append(person)

def searchPerson():
    print("\nSearch person")
    key = input('  | Name starts with : ')
    print("Searching...\n")
    # Find names that start with given keyword
    match = [p for p in persons if p.name.startswith(key)]
    print(str(len(match)) + ' user(s) found :\n')
    for p in match:
        print(p)

if __name__ == '__main__':
    choices = { "1" : createPerson , "2" : searchPerson }
    x = "0"
    while x != "3":
        print(' (1) Create new person')
        print(' (2) Search for a person')    
        print(' (3) Quit')
        x = input('Select an option -> ')
        if x == "1" or x == "2": choices[x]()

