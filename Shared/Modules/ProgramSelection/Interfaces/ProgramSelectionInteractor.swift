//
//  ProgramSelectionInteractor.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol ProgramSelectionInteractor {
    
    var presenter: ProgramSelectionPresenter? { get set }
    
    func channels(_ completion: @escaping (Result<[Channel], APIError>) -> Void)
    func programs(_ completion: @escaping (Result<[Program], APIError>) -> Void)
    
}
