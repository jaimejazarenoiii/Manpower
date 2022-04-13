//
//  Coordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}
