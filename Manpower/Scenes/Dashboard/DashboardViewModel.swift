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
}

protocol DashboardViewModelOutputs {
    var employees: BehaviorRelay<[Employee]> { get }
    var error: PublishRelay<Error> { get }
}

protocol DashboardViewModelTypes {
    var inputs: DashboardViewModelInputs { get }
    var outputs: DashboardViewModelOutputs { get }
}

struct DashboardViewModel: DashboardViewModelTypes, DashboardViewModelOutputs, DashboardViewModelInputs {
    var inputs: DashboardViewModelInputs { return self }
    var outputs: DashboardViewModelOutputs { return self }

    var employees: BehaviorRelay<[Employee]>
    var error: PublishRelay<Error>

    var employeeService: EmployeeServiceable
    private let disposeBag = DisposeBag()

    init(employeeServiceable: EmployeeServiceable) {
        employeeService = employeeServiceable

        error = PublishRelay()

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
}

extension DashboardViewModel {
    func setupBindings() {
        Observable.merge(viewDidLoadProperty, refreshProperty)
            .subscribe(onNext: { _ in
                let employeesReturned = employeeService.getList()
                employees.accept(employeesReturned)
            })
            .disposed(by: disposeBag)

        editEmployeeProperty
            .map { employee -> [Employee] in
                employeeService.edit(employee: employee)
                return employeeService.getList()
            }
            .bind(to: employees)
            .disposed(by: disposeBag)

        deleteEmployeeProperty
            .map { employeeService.delete(employee: $0) }
            .subscribe(onNext: { employees in
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
            .subscribe(onNext: { employee in
                employeeService.edit(employee: employee)
                let employeesReturned = employeeService.getList()
                employees.accept(employeesReturned)
            })
            .disposed(by: disposeBag)
    }
}
