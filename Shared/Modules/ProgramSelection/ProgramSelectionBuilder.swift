//
//  ProgramSelectionBuilder.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

import Foundation
import UIKit

class ProgramSelectionBuilder: Buildable {

    func build() -> UIViewController {
        let view = ProgramSelectionDefaultView()
        
        let channelService = MockService<Channel>(fileName: "Channels")
        let programService = MockService<Program>(fileName: "Programs")
        let interactor = ProgramSelectionDefaultInteractor(channelService: channelService, programService: programService)
        let presenter = ProgramSelectionDefaultPresenter()
        let router = ProgramSelectionDefaultRouter()

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
