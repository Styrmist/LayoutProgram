//
//  ProgramCollectionViewCell.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 23.04.2023.
//

import UIKit
#if os(iOS)
import SnapKit
#endif

class ProgramCollectionViewCell: UICollectionViewCell, Reusable, ReusableViewConfigurable {
    
    private let titleView: UILabel = .init()
    private let borderView = UIView()
    
    override var canBecomeFocused: Bool {
        true
    }
    
    override var isSelected: Bool {
        didSet {
            handleSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        borderView.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        borderView.backgroundColor = isFocused ? .white.withAlphaComponent(0.5) : .black.withAlphaComponent(0.5)
    }
    
    func setup(viewModel: RawViewModel) {
        guard let viewModel = viewModel as? ProgramViewModel else { return }
        
        titleView.text = viewModel.name
    }
    
    private func setupViews() {
        borderView.backgroundColor = .black.withAlphaComponent(0.5)
        contentView.addSubview(borderView)

        titleView.textColor = .white
        contentView.addSubview(titleView)
        
#if os(iOS)
        borderView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3.0)
            $0.left.equalToSuperview().offset(2.0)
            $0.bottom.equalToSuperview().offset(-3.0)
            $0.right.equalToSuperview().offset(-2.0)
        }
        
        titleView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(3.0)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-3.0)
        }
#else
        borderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.0),
            borderView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2.0),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.0),
            borderView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2.0)
        ])
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3.0),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3.0)
        ])
#endif
        
    }
    
    private func handleSelection() {
        borderView.backgroundColor = isSelected ? .white.withAlphaComponent(0.5) : .black.withAlphaComponent(0.5)
    }
    
}
