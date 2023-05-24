//
//  ProgramSelectionDefaultView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import UIKit
#if os(iOS)
import SnapKit
#endif

class ProgramSelectionDefaultView: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<ChannelViewModel, ProgramViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ChannelViewModel, ProgramViewModel>
    
    var presenter: ProgramSelectionPresenter?
    
    weak var activityIndicator: UIActivityIndicatorView!
    var collectionView: UICollectionView?
        
    private lazy var dataSource: DataSource? = makeDataSource()
    
    override func loadView() {
        super.loadView()
        
        configureActivityIndicator()
        configureCollectionView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        self.presenter?.reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let visibleRect = presenter?.visibleFrameForCurrentTime() {
            collectionView?.scrollRectToVisible(visibleRect, animated: false)
        }
    }
    
    private func configureActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        
        self.activityIndicator = activityIndicator
        
#if os(iOS)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
#else
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
#endif
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCustomLayout())
        
        collectionView.backgroundColor = .blue
        collectionView.bounces = false
        collectionView.allowsSelection = true
        collectionView.delegate = self
        
        collectionView.register(ProgramCollectionViewCell.self)
        collectionView.register(ChannelCollectionReusableView.self, ofKind: ListingLayout.ViewKindType.rowHeader.rawValue)
        collectionView.register(TimeLineCollectionReusableView.self, ofKind: ListingLayout.ViewKindType.columnHeader.rawValue)
        collectionView.register(FirstTableCellCollectionReusableView.self, ofKind: ListingLayout.ViewKindType.decorationFirstHeaderCell.rawValue)
        
        view.addSubview(collectionView)
        
#if os(iOS)
        collectionView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
#else
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
#endif
        
        self.collectionView = collectionView
    }
    
    private func createCustomLayout() -> UICollectionViewLayout {
        let layout = ListingLayout(delegate: self, firstHeaderCellDecorationViewClass: FirstTableCellCollectionReusableView.self)
        layout.stickyRowHeader = true
        layout.stickyColumnHeader = true
        layout.useFirstTableView = true
        
        return layout
    }
    
    private func makeDataSource() -> DataSource? {
        guard let collectionView = collectionView else { return nil }
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, program) -> UICollectionViewCell? in
                let cell: ProgramCollectionViewCell = collectionView.dequeueReusableCell(forItemAt: indexPath)
                cell.setup(viewModel: program)
                
                return cell
            })
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.supplementaryView(for: collectionView, kind: kind, indexPath: indexPath)
        }
        
        return dataSource
    }
    
    private func supplementaryView(for collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard let viewKind = ListingLayout.ViewKindType(rawValue: kind) else {
            fatalError("View Kind not available for string: \(kind)")
        }
        
        var supplementaryView: UICollectionReusableView = .init()
        
        switch viewKind {
        case .rowHeader:
            guard let channel = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else {
                fatalError("Can't get program for IndexPath: \(indexPath)")
            }
            
            let view: ChannelCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChannelCollectionReusableView.reuseIdentifier, for: indexPath) as! ChannelCollectionReusableView
            view.setup(viewModel: channel)
            
            supplementaryView = view
        case .columnHeader:
            guard let viewModel = presenter?.timeRepresentationViewModel(for: indexPath.item) else {
                fatalError("Can't get timestamp for IndexPath: \(indexPath)")
            }
            
            let view: TimeLineCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            view.setup(viewModel: viewModel)
            
            supplementaryView = view
        case .decorationFirstHeaderCell:
            guard let viewModel = presenter?.firstCellTimeRepresentation() else {
                fatalError("Can't get timestamp for First Header Cell: \(indexPath)")
            }
            
            let view: FirstTableCellCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            view.setup(viewModel: viewModel)
            
            supplementaryView = view
        }
        
        return supplementaryView
    }
    
    private func applySnapshot(for viewModel: [ChannelViewModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel)
        viewModel.forEach { channel in
            snapshot.appendItems(channel.programs, toSection: channel)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
}

extension ProgramSelectionDefaultView: ProgramSelectionView {

    func displayLoading() {
        activityIndicator.isHidden = false
        collectionView?.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func display(_ channelViewModel: [ChannelViewModel]) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        collectionView?.isHidden = false
    
        applySnapshot(for: channelViewModel, animatingDifferences: false)
    }

    func display(_ error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        collectionView?.isHidden = true
        
        //show actual error...
        print(error.localizedDescription)
    }
    
}

extension ProgramSelectionDefaultView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: ProgramCollectionViewCell = collectionView.dequeueReusableCell(forItemAt: indexPath)

        print(dataSource?.snapshot().sectionIdentifiers[indexPath.section].programs[indexPath.item].name as Any)
        
        cell.isSelected = true
    }
    
}

extension ProgramSelectionDefaultView: ListingLayoutDelegate {
    
    func listingLayout(_ layout: ListingLayout, offsetForItemAt indexPath: IndexPath) -> CGFloat {
        let calendar = Calendar.current
        // Create a Date object with the desired date
        let date = dataSource?.snapshot().sectionIdentifiers[indexPath.section].programs[indexPath.item].startTime
        // Get the components of the date
        let components = calendar.dateComponents([.hour, .minute], from: date!)
        // Calculate the minutes from midnight
        let minutesFromMidnight = components.hour! * 60 + components.minute!
        
        return CGFloat(minutesFromMidnight * 5)
    }
    
    func listingLayout(_ layout: ListingLayout, widthForItemAt indexPath: IndexPath) -> CGFloat {
        guard let length = dataSource?.snapshot().sectionIdentifiers[indexPath.section].programs[indexPath.item].length else {
            return 0
        }
        
        return CGFloat(length * 5)
    }
    
    func listingLayout(_ layout: ListingLayout, heightForRowsInSection section: Int) -> CGFloat {
        50
    }
        
    func listingLayout(_ layout: ListingLayout, widthForColumnAtIndex index: Int) -> CGFloat {
        30 * 5
    }
    
    
    func heightOfHeaderRow(in layout: ListingLayout) -> CGFloat? {
        40
    }
    
    func widthsOfSideColumn(in layout: ListingLayout) -> CGFloat? {
        100
    }
    
}
