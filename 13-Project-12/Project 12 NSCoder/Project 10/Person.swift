//
//  Person.swift
//  Project 10
//
//  Created by User on 23.11.2021.
//

import UIKit

class Person: NSObject, NSCoding {
    var name:String
    var image:String
    init(name:String, image:String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
