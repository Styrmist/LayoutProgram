//
//  ChannelCollectionReusableView.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import UIKit
#if os(iOS)
import SnapKit
#endif

class ChannelCollectionReusableView: UICollectionReusableView, Reusable, ReusableViewConfigurable {

    private let numberLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }
    
    func setup(viewModel: RawViewModel) {
        guard let viewModel = viewModel as? ChannelViewModel else { return }
        
        titleLabel.text = viewModel.title
        numberLabel.text = String(viewModel.access)
    }
    
    private func setupViews() {
        self.backgroundColor = .blue
    
        let borderView = UIView()
        borderView.backgroundColor = .black.withAlphaComponent(0.7)
        addSubview(borderView)
        
        numberLabel.textColor = .white
        addSubview(numberLabel)
        
        titleLabel.textColor = .white
        addSubview(titleLabel)

#if os(iOS)
        borderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        numberLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5.0)
            $0.right.equalToSuperview().offset(-5.0)
            $0.top.equalToSuperview()
            
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5.0)
            $0.right.equalToSuperview().offset(-5.0)
            $0.top.equalTo(numberLabel.snp.bottom).offset(2.0)
            $0.bottom.equalToSuperview()
        }
#else
        borderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            borderView.leftAnchor.constraint(equalTo: self.leftAnchor),
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            numberLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            numberLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
            numberLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 2.0),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5.0),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0)
        ])
#endif
    }
    
}
