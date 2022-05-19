//
//  DashboardCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/29/22.
//

import UIKit
import RxSwift

class DashboardCoordinator: BaseCoordinator {
  var navigationController: UINavigationController
  var authServiceable: AuthServiceable
  var employeeServiceable: EmployeeServiceable?
  var currentUser: User?

  private let disposeBag = DisposeBag()

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    authServiceable = AuthService()
    currentUser = authServiceable.getCurrentUser()!
    super.init()
    guard currentUser != nil else { return }
    setupAuthRequiredServices()
  }

  deinit {
    print("DashboardCoordinator#deinit")
  }

  override func start() {
    setupAuthRequiredServices()
    goToDashboard()
  }

  override func didFinish() {
    parentCoordinator?.free(coordinator: self)
  }

  func setupAuthRequiredServices() {
    employeeServiceable = EmployeeService(currentUser: currentUser!)
  }

  func goToDashboard() {
    let viewModel = DashboardViewModel(employeeServiceable: employeeServiceable!)
    let viewController = DashboardViewController.instantiate(from: .dashboard)
    viewController.viewModel = viewModel
    viewModel.outputs.willAddEmployee.observe(on: MainScheduler.instance)
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.willAddEmployee(source: viewController)
      })
      .disposed(by: disposeBag)
    viewModel.outputs.didSignout.observe(on: MainScheduler.instance)
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.didSignout(source: viewController)
        self.didFinish()
      })
      .disposed(by: disposeBag)
    viewModel.outputs.willEditEmployee.observe(on: MainScheduler.instance)
      .filter { $0 != nil }
      .map { $0! }
      .subscribe(onNext: { [weak self] employee in
        guard let self = self else { return }
        self.willEditEmployee(source: viewController, employee: employee)
      })
      .disposed(by: disposeBag)
    DispatchQueue.main.async { [weak self] () in
      guard let self = self else { return }
      self.navigationController.viewControllers = [viewController]
    }
  }

  func didSignout(source: DashboardViewController) {
    UserDefaults.standard.set(nil, forKey: "userId")
    NotificationCenter.default.post(name: NSNotification.Name("authChanged"), object: nil, userInfo: ["isAuth" : true])
  }

  func willAddEmployee(source: DashboardViewController) {
    presentAddEmployeeForm(source: source)
  }

  func willEditEmployee(source: DashboardViewController, employee: Employee) {
    presentAddEmployeeForm(source: source, employee: employee)
  }

  func presentAddEmployeeForm(source: DashboardViewController, employee: Employee? = nil) {
    let viewModel = EmployeeFormViewModel(employeeServiceable: employeeServiceable!)
    let viewController = EmployeeFormViewController.instantiate(from: .dashboard)
    if let employee = employee {
      viewModel.inputs.set(employee: employee)
      viewModel.inputs.set(procedure: .edit)
    }
    viewController.viewModel = viewModel
    let navVc = UINavigationController(rootViewController: viewController)
    navVc.modalPresentationStyle = .fullScreen
    source.present(navVc, animated: true)
  }
}
