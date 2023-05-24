//
//  ProgramViewModel.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import UIKit

struct ProgramViewModel: RawViewModel {
    
    let id: Int
    let startTime: Date
    let length: Int
    let name: String
    
}

extension ProgramViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProgramViewModel, rhs: ProgramViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
}

