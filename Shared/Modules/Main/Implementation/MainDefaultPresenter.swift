//
//  MainDefaultPresenter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class MainDefaultPresenter {
    
    var router: MainRouter?
    var interactor: MainInteractor?
    weak var view: MainView?
    
}

extension MainDefaultPresenter: MainPresenter {

    func viewDidAppear() {
        self.router?.showProgramSelection()
    }
    
}
