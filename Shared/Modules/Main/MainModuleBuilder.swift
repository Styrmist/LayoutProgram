//
//  MainModuleBuilder.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation
import UIKit

class MainModuleBuilder: Buildable {

    func build() -> UIViewController {
        let view = MainDefaultView()
        let interactor = MainDefaultInteractor()
        let presenter = MainDefaultPresenter()
        let router = MainDefaultRouter()

        view.presenter = presenter

        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router

        interactor.presenter = presenter

        router.presenter = presenter
        router.viewController = view
        
        return view
    }
    
}
