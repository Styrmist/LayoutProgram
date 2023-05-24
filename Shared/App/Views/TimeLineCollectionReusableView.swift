//
//  TimeLineCollectionReusableView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 26.04.2023.
//

import UIKit
#if os(iOS)
import SnapKit
#endif

class TimeLineCollectionReusableView: UICollectionReusableView, Reusable, ReusableViewConfigurable {
    
    private let timeLabel: UILabel = .init()
    private let verticalLineView: UIView = .init()
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
        

        verticalLineView.backgroundColor = .white
        addSubview(verticalLineView)
    
        timeLabel.textColor = .white
        addSubview(timeLabel)
        
#if os(iOS)
        horizontalLineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.width.equalToSuperview()
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5.0)
        }
        
        verticalLineView.snp.makeConstraints {
            $0.width.equalTo(2.0)
            $0.bottom.equalToSuperview().offset(-5.0)
            $0.left.equalToSuperview().offset(1.0)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.bottom.equalTo(verticalLineView.snp.top)
        }
#else
        horizontalLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalLineView.heightAnchor.constraint(equalToConstant: 2.0),
            horizontalLineView.leftAnchor.constraint(equalTo: self.leftAnchor),
            horizontalLineView.widthAnchor.constraint(equalTo: self.widthAnchor),
            horizontalLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
        ])
        
        verticalLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalLineView.widthAnchor.constraint(equalToConstant: 2.0),
            verticalLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1.0),
            verticalLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
            verticalLineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: verticalLineView.topAnchor)
        ])
#endif
    }
    
}
