//
//  ProgramSelectionPresenter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol ProgramSelectionPresenter: AnyObject {
    
    var router: ProgramSelectionRouter? { get set }
    var interactor: ProgramSelectionInteractor? { get set }
    var view: ProgramSelectionView? { get set }
    
    func reload()
    func timeRepresentationViewModel(for index: Int) -> TimeRepresentationViewModel
    func firstCellTimeRepresentation() -> TimeRepresentationViewModel
    func visibleFrameForCurrentTime() -> CGRect
    
}
