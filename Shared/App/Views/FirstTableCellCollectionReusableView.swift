//
//  FirstTableCellCollectionReusableView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 26.04.2023.
//

import UIKit
#if os(iOS)
import SnapKit
#endif

class FirstTableCellCollectionReusableView: UICollectionReusableView, Reusable, ReusableViewConfigurable {

    private let timeLabel: UILabel = .init()
    private let horizontalLineView: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    func setup(viewModel: RawViewModel) {
        guard let viewModel = viewModel as? TimeRepresentationViewModel else { return }
        
        timeLabel.text = viewModel.timeRepresentation
    }
    
    private func setupViews() {
        backgroundColor = .blue
        horizontalLineView.backgroundColor = .white
        addSubview(horizontalLineView)
        
        timeLabel.textColor = .white
        timeLabel.numberOfLines = 2
        timeLabel.font = .systemFont(ofSize: 12.0)
        addSubview(timeLabel)
        
#if os(iOS)
        timeLabel.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(horizontalLineView.snp.top)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.width.equalToSuperview()
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5.0)
        }
#else
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: horizontalLineView.topAnchor)
            
        ])
        
        horizontalLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalLineView.heightAnchor.constraint(equalToConstant: 2.0),
            horizontalLineView.widthAnchor.constraint(equalTo: self.widthAnchor),
            horizontalLineView.leftAnchor.constraint(equalTo: self.leftAnchor),
            horizontalLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0)
            
        ])
#endif
    }
    
}
