//
//  PullRequestDetailView.swift
//  GitHubList
//
//  Created by Filipe Oliveira on 01/08/20.
//  Copyright © 2020 Filipe Oliveira. All rights reserved.
//

import UIKit

final class PullRequestDetailView: UIView {
    
    private(set) lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        
        return l
    }()
    
    private(set) lazy var watcherLabel: UILabel = {
        let l = UILabel()
        
        l.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        l.font = .systemFont(ofSize: UIFont.buttonFontSize, weight: .black)
        
        return l
    }()
    
    private(set) lazy var licenseLabel: UILabel = {
        let l = UILabel()
        
        l.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return l
    }()
    
    private(set) lazy var updateAtLabel: UILabel = {
        let l = UILabel()
        
        l.font = .italicSystemFont(ofSize: UIFont.labelFontSize)
        
        return l
    }()
    
    private lazy var topStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [descriptionLabel, watcherLabel])
        
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 5
        
        return sv
    }()
    
    private lazy var centerStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [licenseLabel, updateAtLabel])
        
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fillEqually
        sv.spacing = 10
        
        return sv
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [topStackView, centerStackView])
        
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 10
        
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        
        v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        v.layer.cornerRadius = 25
        v.layer.shadowRadius = 2
        v.layer.shadowOpacity = 0.4
        v.layer.shadowOffset = .init(width: 2, height: 2)
        
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initComponents()
    }
}

extension PullRequestDetailView {
    private func initComponents() {
        
        addSubview(contentView)
        
        contentView.addSubview(contentStackView)
        
        contentView.autoPinEdgesToSuperviewEdges(with: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        contentStackView.autoPinEdgesToSuperviewEdges(with: .init(top: 15, left: 15, bottom: 15, right: 15))
        
        NSLayoutConstraint.autoSetPriority(.defaultLow) {
            descriptionLabel.autoSetContentCompressionResistancePriority(for: .horizontal)
            descriptionLabel.autoSetContentHuggingPriority(for: .horizontal)
        }
        
        NSLayoutConstraint.autoSetPriority(.defaultHigh) {
            watcherLabel.autoSetContentHuggingPriority(for: .horizontal)
        }
    }
}
