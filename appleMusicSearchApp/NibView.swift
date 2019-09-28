//
//  NibView.swift
//  appleMusicSearchApp
//
//  Created by Narek Stepanyan on 28/09/2019.
//  Copyright © 2019 NRKK dev.studio. All rights reserved.
//

import Foundation
import UIKit


/// Загрузка view из xib-файла с таким же названием, что и у наследуемого класса
open class NibView: UIView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    open func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        var mirror: Mirror! = Mirror(reflecting: self)
        repeat {
            let nibName = String(describing: mirror.subjectType)
            let bundle = Bundle(for: type(of: self))
            if bundle.path(forResource: nibName, ofType: "nib") != nil {
                if let contentView = bundle.loadNibNamed(nibName, owner: self, options: [:])?.first as? UIView {
                    addSubview(contentView)
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                    contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                } else { print("Ошибка при загрузке NibView: \(nibName) ") }
                mirror = nil
            } else { mirror = mirror.superclassMirror }
        } while mirror != nil
    }
}
