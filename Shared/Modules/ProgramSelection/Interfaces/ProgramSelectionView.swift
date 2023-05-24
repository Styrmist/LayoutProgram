//
//  ProgramSelectionView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

protocol ProgramSelectionView: AnyObject {
    
    var presenter: ProgramSelectionPresenter? { get set }

    func displayLoading()
    func display(_ error: Error)
    func display(_ channelViewModel: [ChannelViewModel])
    
}
