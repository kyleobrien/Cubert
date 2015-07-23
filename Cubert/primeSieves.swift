//
//  primeSieves.swift
//  ProjectEuler
//
//  Created by Kyle O'Brien on 2015.7.16.
//  Copyright (c) 2015 Kyle O'Brien. All rights reserved.
//

import Foundation

enum SieveType {
    case Eratosthenes
    case Sundaram
}

func primesUpTo(limit: Int, withSieveType: SieveType) -> [Int] {
    var primeNumbers: [Int]
    
    switch withSieveType {
        case .Eratosthenes:
            primeNumbers = sieveWithEratosthenesUpTo(limit)
        case .Sundaram:
            primeNumbers = sieveWithSundaramUpTo(limit)
    }
    
    return primeNumbers
}

/**
    Simple implementation of the Sieve of Eratosthenes.

    - Parameter limit: The upper bound (inclusive) when searching for primes.
    - Returns An array of prime numbers.
*/
func sieveWithEratosthenesUpTo(limit: Int) -> [Int] {
    var primeNumbers = [Int]()
    
    if limit >= 2 {
        var isCompositeNumber = [Int: Bool]()
        var candidate = 3
        
        primeNumbers.append(2)
        
        while candidate <= limit {
            let isCandidateComposite = isCompositeNumber[candidate] ?? false
            if !isCandidateComposite {
                primeNumbers.append(candidate)
                
                // Optimization 1: Start marking composites at candidate squared.
                var compositeNumber = candidate * candidate
                
                repeat {
                    isCompositeNumber[compositeNumber] = true
                    compositeNumber += candidate
                } while compositeNumber < limit
            }
            
            // Optimization 2: Only iterate over odd numbers, since even numbers after 2 aren't prime.
            candidate += 2
        }
    }
    
    return primeNumbers
}

/**
    Simple implementation of the Sieve of Sundaram.

    - Parameter limit: The upper bound (inclusive) when searching for primes.
    - Returns An array of prime numbers.
*/
func sieveWithSundaramUpTo(limit: Int) -> [Int] {
    var primeNumbers = [Int]()
    
    if limit >= 2 {
        var i = 1, j = 1
        var isNumberExcluded = [Int: Bool]()
        
        primeNumbers.append(2)
        
        // Generate a list of numbers that will not have the prime generating
        // formula applied, with the following two conditions:
        // 1.) i, j ∈ ℕ, 1 ≤ i ≤ j
        // 2.) i + j + 2ij ≤ n
        while (i + j + (2 * i * j)) <= limit {
            while (i + j + (2 * i * j)) <= limit {
                isNumberExcluded[i + j + (2 * i * j)] = true
                j += 1
            }
            
            i += 1
            j = i
        }

        // Apply the formula p = 2k + 1 to all the numbers not excluded above.
        for k in 1...limit {
            let isCandidateCrossedOut = isNumberExcluded[k] ?? false
            if !isCandidateCrossedOut {
                let primeNumber = (2 * k) + 1
                
                if primeNumber > limit {
                    break
                }
                else {
                    primeNumbers.append(primeNumber)
                }
            }
        }
    }
    
    return primeNumbers
}
