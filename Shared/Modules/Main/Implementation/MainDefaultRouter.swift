//
//  MainDefaultRouter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation
import UIKit

class MainDefaultRouter {

    weak var presenter: MainPresenter?
    weak var viewController: UIViewController?
    
}

extension MainDefaultRouter: MainRouter {

    func showProgramSelection() {
        let viewController = ProgramSelectionBuilder().build()
        viewController.modalPresentationStyle = .fullScreen
        
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
    
}
