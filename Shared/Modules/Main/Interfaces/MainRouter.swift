//
//  MainRouter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol MainRouter {
    
    var presenter: MainPresenter? { get set }
    
    func showProgramSelection()
    
}
