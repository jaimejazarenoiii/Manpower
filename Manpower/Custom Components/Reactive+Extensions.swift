//
//  Reactive+Extensions.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxSwift

extension Reactive where Base: UITextField {
    public var borderColor: Binder<CGColor> {
        return Binder(base, binding: { textField, active in
            textField.layer.borderColor = active
        })
    }
}
