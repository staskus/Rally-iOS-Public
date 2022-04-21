//
//  UIViewController+MultilineTitle.swift
//  
//
//  Created by Povilas Staskus on 10/19/19.
//

import UIKit
import SnapKit

public extension UIViewController {
    func setMultilineTitle(_ title: String, subtitle: String) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let titleView = UIView()
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.textAlignment = .left
        let titleAttributedString = NSMutableAttributedString(string: title)
        titleAttributedString.addAttribute(
            .font,
            value: Theme.Font.large,
            range: NSRange(location: 0, length: title.count)
        )
        
        let subtitleAttributedString = NSMutableAttributedString(string: subtitle)
        subtitleAttributedString.addAttribute(
            .font,
            value: Theme.Font.small,
            range: NSRange(location: 0, length: subtitle.count)
        )
        
        titleAttributedString.append(NSAttributedString(string: "\n"))
        titleAttributedString.append(subtitleAttributedString)
        label.attributedText = titleAttributedString
        
        titleView.addSubviews(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.top)
            make.leading.equalTo(titleView.snp.leading)
            make.bottom.equalTo(titleView.snp.bottom)
            make.trailing.equalTo(titleView.snp.trailing)
        }
        
        titleView.snp.makeConstraints { $0.width.equalTo(UIScreen.main.bounds.width) }
        
        navigationItem.titleView = titleView
        navigationItem.titleView?.layoutIfNeeded()
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.top)
            $0.bottom.equalTo(navigationBar.snp.bottom)
        }
        
        self.title = nil
    }
}


