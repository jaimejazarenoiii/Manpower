//
//  DashboardViewModel.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/8/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol DashboardViewModelInputs {
  func viewDidLoad()
  func refresh()
  func add(employee: Employee)
  func edit(employee: Employee)
  func delete(employee: Employee)
  func toggle(from: Employee, isOn: Bool)
  func addButtonTapped()
  func signOutButtonTapped()
  func willEdit(employee: Employee)
}

protocol DashboardViewModelOutputs {
  var employees: BehaviorRelay<[Employee]> { get }
  var error: PublishRelay<Error> { get }
  var didSignout: BehaviorRelay<Void?> { get }
  var willAddEmployee: BehaviorRelay<Void?> { get }
  var willEditEmployee: BehaviorRelay<Employee?> { get }
}

protocol DashboardViewModelTypes {
  var inputs: DashboardViewModelInputs { get }
  var outputs: DashboardViewModelOutputs { get }
}

class DashboardViewModel: DashboardViewModelTypes, DashboardViewModelOutputs, DashboardViewModelInputs {
  var inputs: DashboardViewModelInputs { return self }
  var outputs: DashboardViewModelOutputs { return self }

  var employees: BehaviorRelay<[Employee]>
  var error: PublishRelay<Error>
  var didSignout: BehaviorRelay<Void?>
  var willAddEmployee: BehaviorRelay<Void?>
  var willEditEmployee: BehaviorRelay<Employee?>

  var employeeService: EmployeeServiceable
  private let disposeBag = DisposeBag()

  init(employeeServiceable: EmployeeServiceable) {
    employeeService = employeeServiceable

    error = PublishRelay()
    didSignout = .init(value: nil)
    willAddEmployee = .init(value: nil)
    willEditEmployee = .init(value: nil)

    employees = BehaviorRelay(value: [])
    setupBindings()
  }

  private var refreshProperty = PublishSubject<Void>()
  func refresh() {
    refreshProperty.onNext(())
  }

  private var viewDidLoadProperty = PublishSubject<Void>()
  func viewDidLoad() {
    viewDidLoadProperty.onNext(())
  }

  private var addEmployeeProperty = PublishSubject<Employee>()
  func add(employee: Employee) {
    addEmployeeProperty.onNext(employee)
  }

  private var editEmployeeProperty = PublishSubject<Employee>()
  func edit(employee: Employee) {
    editEmployeeProperty.onNext(employee)
  }

  private var deleteEmployeeProperty = PublishSubject<Employee>()
  func delete(employee: Employee) {
    deleteEmployeeProperty.onNext(employee)
  }

  private var toggleStatusProperty = PublishSubject<(Employee, Bool)?>()
  func toggle(from: Employee, isOn: Bool) {
    toggleStatusProperty.onNext((from, isOn))
  }

  private var addButtonTappedProperty = PublishSubject<Void>()
  func addButtonTapped() {
    addButtonTappedProperty.onNext(())
  }

  private var signOutButtonTappedProperty = PublishSubject<Void>()
  func signOutButtonTapped() {
    signOutButtonTappedProperty.onNext(())
  }

  private var willEditEmployeeProperty = PublishSubject<Employee>()
  func willEdit(employee: Employee) {
    willEditEmployeeProperty.onNext(employee)
  }
}

extension DashboardViewModel {
  func setupBindings() {
    Observable.merge(viewDidLoadProperty, refreshProperty)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        let employeesReturned = self.employeeService.getList()
        self.employees.accept(employeesReturned)
      })
      .disposed(by: disposeBag)

    editEmployeeProperty
      .map { [weak self] employee -> [Employee] in
        guard let self = self else { return [] }
        self.employeeService.edit(employee: employee)
        return self.employeeService.getList()
      }
      .bind(to: employees)
      .disposed(by: disposeBag)

    deleteEmployeeProperty
      .map { [weak self] employee -> [Employee] in
        guard let self = self else { return [] }
        return self.employeeService.delete(employee: employee)
      }
      .subscribe(onNext: { [weak self] employees in
        guard let self = self else { return }
        self.employees.accept(employees)
      })
      .disposed(by: disposeBag)

    toggleStatusProperty
      .filter { $0 != nil }
      .map { value -> Employee in
        let status: Employee.Status = value!.1 ? .active : .inactive
        var tmpEmployee = value!.0
        tmpEmployee.status = status
        return tmpEmployee
      }
      .subscribe(onNext: { [weak self] employee in
        guard let self = self else { return }
        self.employeeService.edit(employee: employee)
        let employeesReturned = self.employeeService.getList()
        self.employees.accept(employeesReturned)
      })
      .disposed(by: disposeBag)

    addButtonTappedProperty.bind(to: willAddEmployee).disposed(by: disposeBag)
    signOutButtonTappedProperty.bind(to: didSignout).disposed(by: disposeBag)
  }
}
