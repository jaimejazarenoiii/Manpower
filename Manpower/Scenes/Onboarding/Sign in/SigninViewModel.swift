//
//  SigninViewModel.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol SigninViewModelInputs {
    func set(email: String)
    func set(password: String)
    func signin()
    func viewDidLoad()
}

protocol SigninViewModelOutputs {
    var signedinUser: BehaviorRelay<User?> { get }
    var isEmailValid: BehaviorRelay<TextFieldStatus?> { get }
    var isPasswordValid: BehaviorRelay<TextFieldStatus?> { get }
    var emailNotValidErrMssg: BehaviorRelay<String?> { get }
    var passwordNotValidErrMssg: BehaviorRelay<String?> { get }
    var isSigninButtonEnabled: BehaviorRelay<Bool?> { get }
    var error: BehaviorRelay<Error?> { get }
}

protocol SigninViewModelTypes {
    var inputs: SigninViewModelInputs { get }
    var outputs: SigninViewModelOutputs { get }
}

struct SigninViewModel: SigninViewModelTypes, SigninViewModelOutputs, SigninViewModelInputs {
    var inputs: SigninViewModelInputs { return self }
    var outputs: SigninViewModelOutputs { return self }

    var isEmailValid: BehaviorRelay<TextFieldStatus?>
    var isPasswordValid: BehaviorRelay<TextFieldStatus?>
    var emailNotValidErrMssg: BehaviorRelay<String?>
    var passwordNotValidErrMssg: BehaviorRelay<String?>
    var signedinUser: BehaviorRelay<User?>
    var isSigninButtonEnabled: BehaviorRelay<Bool?>
    var error: BehaviorRelay<Error?>
    var authService: AuthServiceable

    private let email = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    private let disposeBag = DisposeBag()

    init(authServiceable: AuthServiceable) {
        authService = authServiceable

        isEmailValid = BehaviorRelay(value: nil)
        isPasswordValid = BehaviorRelay(value: nil)
        emailNotValidErrMssg = BehaviorRelay(value: nil)
        passwordNotValidErrMssg = BehaviorRelay(value: nil)
        signedinUser = BehaviorRelay(value: nil)
        error = BehaviorRelay(value: nil)
        isSigninButtonEnabled = BehaviorRelay(value: nil)
        setupBindings()
    }

    private var setEmailProperty = PublishSubject<String>()
    func set(email: String) {
        setEmailProperty.onNext(email)
    }

    private var setPasswordProperty = PublishSubject<String>()
    func set(password: String) {
        setPasswordProperty.onNext(password)
    }

    private var viewDidLoadProperty = PublishSubject<Void>()
    func viewDidLoad() {
        viewDidLoadProperty.onNext(())
    }

    private var signinProperty = PublishSubject<Void>()
    func signin() {
        signinProperty.onNext(())
    }
}

extension SigninViewModel: EmailValidateable {
    func setupBindings() {
        setEmailProperty.bind(to: email).disposed(by: disposeBag)
        setPasswordProperty.bind(to: password).disposed(by: disposeBag)

        setEmailProperty.map(isValidEmail(_:))
            .bind(to: isEmailValid)
            .disposed(by: disposeBag)
        setPasswordProperty
            .map { $0.count > 5 && $0.count < 21 ? .valid : .invalid }
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)

        isEmailValid
            .filter { $0 == .invalid }
            .map { _ in "Entered email is not valid." }
            .bind(to: emailNotValidErrMssg)
            .disposed(by: disposeBag)

        isPasswordValid.filter { $0 == .invalid }
            .map { _ in "Password has to be from 6 to 20 characters long." }
            .bind(to: passwordNotValidErrMssg)
            .disposed(by: disposeBag)

        isEmailValid.filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: emailNotValidErrMssg)
            .disposed(by: disposeBag)

        isPasswordValid.filter { $0 == .valid }
            .map { _ in "" }
            .bind(to: passwordNotValidErrMssg)
            .disposed(by: disposeBag)

        Observable.combineLatest(isEmailValid, isPasswordValid)
            .map { $0 == TextFieldStatus.valid && $1 == TextFieldStatus.valid }
            .bind(to: isSigninButtonEnabled)
            .disposed(by: disposeBag)

        signinProperty
            .subscribe(onNext: { user in
                do {
                    let user = try authService.signIn(email: email.value, password: password.value)
                    signedinUser.accept(user!)
                } catch(let err) {
                    error.accept(err)
                }
            }).disposed(by: disposeBag)
    }
}
