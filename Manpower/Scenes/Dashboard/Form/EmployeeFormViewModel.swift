//
//  EmployeeFormViewModel.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/8/22.
//

import RxCocoa
import RxSwift
import RxRelay
import Foundation

protocol EmployeeFormViewModelnputs {
    func viewDidLoad()
    func save()
    func set(name: String)
    func set(email: String)
    func set(employee: Employee)
    func set(procedure: EmployeeFormViewModel.EmployeeFormViewModelProcedure)
}

protocol EmployeeFormViewModelOutputs {
    var isSuccess: BehaviorRelay<Bool?> { get }
    var isNameValid: BehaviorRelay<TextFieldStatus?> { get }
    var isEmailValid: BehaviorRelay<TextFieldStatus?> { get }
    var nameNotValidErrMssg: BehaviorRelay<String?> { get }
    var emailNotValidErrMssg: BehaviorRelay<String?> { get }
    var error: BehaviorRelay<Error?> { get }
    var employee: BehaviorRelay<Employee?> { get }
}

protocol EmployeeFormViewModelTypes {
    var inputs: EmployeeFormViewModelnputs { get }
    var outputs: EmployeeFormViewModelOutputs { get }
}

struct EmployeeFormViewModel: EmployeeFormViewModelTypes, EmployeeFormViewModelOutputs, EmployeeFormViewModelnputs {
    enum EmployeeFormViewModelProcedure {
        case add, edit
    }
    var inputs: EmployeeFormViewModelnputs { return self }
    var outputs: EmployeeFormViewModelOutputs { return self }

    var isSuccess: BehaviorRelay<Bool?>
    var isNameValid: BehaviorRelay<TextFieldStatus?>
    var isEmailValid: BehaviorRelay<TextFieldStatus?>
    var nameNotValidErrMssg: BehaviorRelay<String?>
    var emailNotValidErrMssg: BehaviorRelay<String?>
    var employee: BehaviorRelay<Employee?>
    var error: BehaviorRelay<Error?>

    var employeeService: EmployeeServiceable
    private var name: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    private var email: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()

    init(employeeServiceable: EmployeeServiceable) {
        employeeService = employeeServiceable

        isSuccess = BehaviorRelay(value: nil)
        error = BehaviorRelay(value: nil)
        isNameValid = BehaviorRelay(value: nil)
        isEmailValid = BehaviorRelay(value: nil)
        nameNotValidErrMssg = BehaviorRelay(value: nil)
        emailNotValidErrMssg = BehaviorRelay(value: nil)
        employee = BehaviorRelay(value: nil)
        setupBindings()
    }

    private var viewDidLoadProperty = PublishSubject<Void>()
    func viewDidLoad() {
        viewDidLoadProperty.onNext(())
    }

    private var saveProperty = PublishSubject<Void>()
    func save() {
        saveProperty.onNext(())
    }

    private var setEmployeeProperty = PublishSubject<Employee>()
    func set(employee: Employee) {
        setEmployeeProperty.onNext(employee)
    }

    private var setNameProperty = PublishSubject<String>()
    func set(name: String) {
        setNameProperty.onNext(name)
    }

    private var setEmailProperty = PublishSubject<String>()
    func set(email: String) {
        setEmailProperty.onNext(email)
    }

    private var setProcedureProperty = BehaviorRelay<EmployeeFormViewModelProcedure>(value: .add)
    func set(procedure: EmployeeFormViewModelProcedure) {
        setProcedureProperty.accept(procedure)
    }

}

extension EmployeeFormViewModel: EmailValidateable {
    func setupBindings() {
        setEmployeeProperty.bind(to: employee).disposed(by: disposeBag)
        setEmployeeProperty
            .map { $0.name }
            .bind(to: name)
            .disposed(by: disposeBag)
        setEmployeeProperty
            .map { $0.email }
            .bind(to: email)
            .disposed(by: disposeBag)
        setNameProperty.bind(to: name).disposed(by: disposeBag)
        setEmailProperty.bind(to: email).disposed(by: disposeBag)

        name
            .skip(1)
            .filter { $0 != nil }
            .map { $0! }
            .map { $0.count > 4 ? .valid : .invalid }
            .bind(to: isNameValid).disposed(by: disposeBag)
        email
            .skip(1)
            .filter { $0 != nil }
            .map { $0! }
            .map(isValidEmail(_:)).bind(to: isEmailValid).disposed(by: disposeBag)

        isEmailValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .invalid }
            .map { _ in "Entered email is not valid." }
            .bind(to: emailNotValidErrMssg)
            .disposed(by: disposeBag)

        isNameValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .invalid }
            .map { _ in "Name should be at least 5 in characters." }
            .bind(to: nameNotValidErrMssg)
            .disposed(by: disposeBag)

        isNameValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: nameNotValidErrMssg)
            .disposed(by: disposeBag)

        isEmailValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: emailNotValidErrMssg)
            .disposed(by: disposeBag)

        isNameValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .valid }
            .subscribe(onNext: { _ in
                if var newEmployee = employee.value {
                    newEmployee.name = name.value!
                    employee.accept(newEmployee)
                } else {
                    let newEmployee = Employee(name: name.value!)
                    employee.accept(newEmployee)
                }

            }).disposed(by: disposeBag)

        isEmailValid
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0 == .valid }
            .subscribe(onNext: { _ in
                if var newEmployee = employee.value {
                    newEmployee.email = email.value!
                    employee.accept(newEmployee)
                } else {
                    let newEmployee = Employee(email: email.value!)
                    employee.accept(newEmployee)
                }
            }).disposed(by: disposeBag)

        saveProperty
            .subscribe(onNext: { _ in
                guard var employee = employee.value,
                      let name = name.value,
                      let email = email.value,
                      isNameValid.value == .valid && isEmailValid.value == .valid else {
                    return error.accept(NSError(domain: "Manpower",
                                                code: 500,
                                                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Error", value: "Please fix form", comment: "")]))
                }
                employee.name = name
                employee.email = email
                setProcedureProperty.value == .add ? employeeService.add(employee: employee) : employeeService.edit(employee: employee)
                isSuccess.accept(true)
            }).disposed(by: disposeBag)
    }
}
