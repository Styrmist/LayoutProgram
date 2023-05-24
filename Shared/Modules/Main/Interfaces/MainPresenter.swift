//
//  MainPresenter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol MainPresenter: AnyObject {
    
    var router: MainRouter? { get set }
    var interactor: MainInteractor? { get set }
    var view: MainView? { get set }
    
    func viewDidAppear()
    
}
