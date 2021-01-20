import Foundation

// I. Add arithmetic operators (add, subtract, multiply, divide) to make the following expressions true. You can use any parentheses you’d like.

// Solution I
// (3 + 1) / 3 * 9 = 12
var value: Double = (3 + 1) / 3 * 9
print("Challeng I \(value)")

// ******************************************************************************

//II. Write a function/method utilizing Swift to determine whether two strings are anagrams or not (examples of anagrams: debit card/bad credit, punishments/nine thumps, etc.)

// Solution II
func checkForAnagram(firstString: String, secondString: String) -> Bool {
    
    let firstString = Array(firstString.lowercased().replacingOccurrences(of: " ", with: "")).sorted()
    let secondString = Array(secondString.lowercased().replacingOccurrences(of: " ", with: "")).sorted()
    return firstString == secondString
}

print("Is Anagram \(checkForAnagram(firstString: "debit card", secondString: "bad credit"))")
print("Is Anagram \(checkForAnagram(firstString: "punishment", secondString: "nine thumps"))")

// ******************************************************************************

//III. Write a method in Swift to generate the nth Fibonacci number (1, 1, 2, 3, 5, 8, 13, 21, 34)

// Solution III
// A. recursive approach

func recursiveFibonacci(n: Int) -> Int {
    
    if n <= 1 {
        return n
    }
    
    return recursiveFibonacci(n: n - 1) + recursiveFibonacci(n: n - 2)
}

print("Is Recursive Fibonacci \(recursiveFibonacci(n: 9))")

// B. iterative approach
func iterativeFibonacci(n: Int) -> Int {
    
    var fibonacci = Array<Int>()
    fibonacci.append(0)
    fibonacci.append(1)
    
    for i in 2...n {
        fibonacci.append(fibonacci[i-1] + fibonacci[i-2])
    }
    
    return fibonacci[n]
}

print("Is Iterative Fibonacci \(iterativeFibonacci(n: 12))")
