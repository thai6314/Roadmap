//
//  Example1.swift
//  Core Foundation
//
//  Created by ThaiDV on 12/5/26.
//

import Foundation

class Person {
    var name: String
    var age: Int
    var apartment: Apartment?
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Apartment {
    var number: String
    var owner: Person?
    
    init(number: String) {
        self.number = number
    }
}

class  Example1 {
    let person1 = Person(name: "ThaiDV", age: 26)
    let apartment1 = Apartment(number: "101")
    
    func run() {
        person1.apartment = apartment1
        apartment1.owner = person1
    }
}
