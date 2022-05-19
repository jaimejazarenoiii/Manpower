//
//  Coordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

protocol Coordinator: AnyObject {
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators : [Coordinator] { get set }
  func start()
  func didFinish()
}

// MARK: extension
extension Coordinator {
  /*
   Called when the current coordinator will start a new coordinator
   */
  func store(coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }

  /*
   Called when the child coordinator return result to the Parent coordinator
   */
  func free(coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
}

// MARK: BaseCoordinator
class BaseCoordinator: Coordinator {

  /*
   Hold the previous coordinator
   */
  weak var parentCoordinator: Coordinator?

  /*
   Storage of coordinators started by the current coordinator
   */
  var childCoordinators : [Coordinator] = []

  /*
   Used to by the child coordinator to return result to the parent coordinator
   */
  var isCompleted: ((_ identifier: String?) -> ())?

  /*
   Used to start the current ViewController
   */
  func start() {
    fatalError("Children should implement `start`.")
  }

  /*
   Used to by the child coordinator to return result to the parent coordinator
   */
  func didFinish() {
    fatalError("Children should implement `did Finish`.")
  }
}
