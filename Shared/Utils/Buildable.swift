//
//  Buildable.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import UIKit

protocol Buildable: AnyObject {
    
    func build() -> UIViewController
    
}
