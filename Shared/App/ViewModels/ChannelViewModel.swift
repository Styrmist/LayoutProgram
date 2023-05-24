//
//  ChannelViewModel.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import UIKit

struct ChannelViewModel: RawViewModel {
    
    let id: Int
    let order: Int
    let access: Int
    let title: String
    var programs: [ProgramViewModel]
    
}

extension ChannelViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChannelViewModel, rhs: ChannelViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
}
