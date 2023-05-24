//
//  ProgramSelectionDefaultPresenter.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import Foundation

class ProgramSelectionDefaultPresenter: ProgramSelectionPresenter {
    
    var router: ProgramSelectionRouter?
    var interactor: ProgramSelectionInteractor?
    weak var view: ProgramSelectionView?
    
    private let minutesInHour = 60
    private let timeLineGap = 30

    func reload() {
        view?.displayLoading()
        updateData()
    }
    
    func timeRepresentationViewModel(for index: Int) -> TimeRepresentationViewModel {
        var date = Date.now.stripTime()
        date.addTimeInterval(TimeInterval(integerLiteral: Double(index * minutesInHour * timeLineGap)))
        
        return TimeRepresentationViewModel(timeRepresentation: date.formatted(date: .omitted, time: .shortened))
    }
    
    func firstCellTimeRepresentation() -> TimeRepresentationViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Today,' MMMM d"
        
        return TimeRepresentationViewModel(timeRepresentation: dateFormatter.string(from: Date.now))
    }
    
    func visibleFrameForCurrentTime() -> CGRect {
        let calendar = Calendar.current
        let date = Date.now
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let minutesFromMidnight = components.hour! * minutesInHour + (components.minute! < timeLineGap ? 0 : timeLineGap)
        
        return CGRect(
            x: minutesFromMidnight * 10 + 120,
            y: 0,
            width: minutesInHour * 10,
            height: 10
        )
    }
    
    private func updateData() {
        var channels: [Channel]?
        var programs: [Program]?
        var error: Error?
        
        let group = DispatchGroup()
        
        group.enter()
        interactor?.channels { result in
            switch result {
            case .success(let success):
                channels = success
            case .failure(let failure):
                error = failure
            }
            group.leave()
        }
        
        group.enter()
        interactor?.programs { result in
            switch result {
            case .success(let success):
                programs = success
            case .failure(let failure):
                error = failure
            }
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let view = self?.view else { return }
            
            if let error = error {
                view.display(error)
                
                return
            }
            
            guard let channels = channels, let programs = programs else {
                // han happen due to api limitations, last page, ect. Need more info to process.
                print("Unexpected behavior")
                
                return
            }
            
            let channelViewModel = channels.compactMap { channel in
                ChannelViewModel(
                    id: channel.id,
                    order: channel.order,
                    access: channel.access,
                    title: channel.callSign,
                    programs: programs.filter { $0.recentAirTime.channelId == channel.id}.compactMap { program in
                        ProgramViewModel(
                            id: program.recentAirTime.id,
                            startTime: program.startTime,
                            length: program.length,
                            name: program.name
                        )
                    }
                )
            }
            
            view.display(channelViewModel)
        }
    }
    
}
