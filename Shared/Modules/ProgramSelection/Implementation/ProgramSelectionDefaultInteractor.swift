//
//  ProgramSelectionDefaultInteractor.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class ProgramSelectionDefaultInteractor: ProgramSelectionInteractor {

    weak var presenter: ProgramSelectionPresenter?
    
    let channelService: any APIServiceFetchable<Channel>
    let programService: any APIServiceFetchable<Program>

    init(channelService: any APIServiceFetchable<Channel>, programService: any APIServiceFetchable<Program>) {
        self.channelService = channelService
        self.programService = programService
    }
    
    func channels(_ completion: @escaping (Result<[Channel], APIError>) -> Void) {
        channelService.fetch { completion($0) }
    }
    
    func programs(_ completion: @escaping (Result<[Program], APIError>) -> Void) {
        programService.fetch { completion($0) }
    }

}
