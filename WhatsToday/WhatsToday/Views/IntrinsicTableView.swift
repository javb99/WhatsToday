//
//  IntrinsicTableView.swift
//  WhatsToday
//
//  Copied from: https://stackoverflow.com/a/48623673/4846592
//

import UIKit

/// Changes it's intrinsic content size based on it's content. This allows it to use constraints that make it fit to it's contents as long as it's contents don't go beyond it's max size based on other constraints.
class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
    
}
