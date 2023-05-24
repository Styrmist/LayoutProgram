//
//  MainDefaultView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation
import UIKit

class MainDefaultView: UIViewController {
    
    var presenter: MainPresenter?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.presenter?.viewDidAppear()
    }
    
}

extension MainDefaultView: MainView { }
