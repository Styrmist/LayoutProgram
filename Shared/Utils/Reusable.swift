//
//  Reusable.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 23.04.2023.
//

protocol Reusable: AnyObject {
    
    static var reuseIdentifier: String { get }
    
}

extension Reusable {
    
    static var reuseIdentifier: String {
        get {
            String(describing: self)
        }
    }
    
}
