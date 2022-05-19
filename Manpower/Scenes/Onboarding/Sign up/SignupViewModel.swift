//
//  File.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol BakcableInput {

}

protocol SignupViewModelInputs {
  func set(companyName: String)
  func set(email: String)
  func set(password: String)
  func set(passwordConfirmation: String)
  func signup()
  func didTapLeftBarButtonItem()
  func viewDidLoad()
}

protocol BackableOutputs {
  var willGoBack: BehaviorRelay<Void?> { get }
}

protocol SignupViewModelOutputs: BackableOutputs {
  var isNameValid: BehaviorRelay<TextFieldStatus?> { get }
  var isEmailValid: BehaviorRelay<TextFieldStatus?> { get }
  var isPasswordValid: BehaviorRelay<TextFieldStatus?> { get }
  var isPasswordConfirmationValid: BehaviorRelay<TextFieldStatus?> { get }
  var nameNotValidErrMssg: BehaviorRelay<String?> { get }
  var emailNotValidErrMssg: BehaviorRelay<String?> { get }
  var passwordNotValidErrMssg: BehaviorRelay<String?> { get }
  var passwordConfirmationNotValidErrMssg: BehaviorRelay<String?> { get }
  var isSignupButtonEnabled: BehaviorRelay<Bool?> { get }
  var createdUser: BehaviorRelay<User?> { get }
  var error: BehaviorRelay<Error?> { get }
}

protocol SignupViewModelTypes {
  var inputs: SignupViewModelInputs { get }
  var outputs: SignupViewModelOutputs { get }
}

struct SignupViewModel: SignupViewModelTypes, SignupViewModelOutputs, SignupViewModelInputs {
  var inputs: SignupViewModelInputs { return self }
  var outputs: SignupViewModelOutputs { return self }

  var isNameValid: BehaviorRelay<TextFieldStatus?>
  var isEmailValid: BehaviorRelay<TextFieldStatus?>
  var isPasswordValid: BehaviorRelay<TextFieldStatus?>
  var isPasswordConfirmationValid: BehaviorRelay<TextFieldStatus?>
  var nameNotValidErrMssg: BehaviorRelay<String?>
  var emailNotValidErrMssg: BehaviorRelay<String?>
  var passwordNotValidErrMssg: BehaviorRelay<String?>
  var passwordConfirmationNotValidErrMssg: BehaviorRelay<String?>
  var isSignupButtonEnabled: BehaviorRelay<Bool?>
  var createdUser: BehaviorRelay<User?>
  var error: BehaviorRelay<Error?>
  var willGoBack: BehaviorRelay<Void?>

  private let name = BehaviorRelay(value: "")
  private let email = BehaviorRelay(value: "")
  private let password = BehaviorRelay(value: "")
  private let disposeBag = DisposeBag()
  private var authService: AuthServiceable

  init(authServiceable: AuthServiceable) {
    authService = authServiceable
    isNameValid = BehaviorRelay(value: nil)
    isEmailValid = BehaviorRelay(value: nil)
    isPasswordValid = BehaviorRelay(value: nil)
    isPasswordConfirmationValid = BehaviorRelay(value: nil)
    nameNotValidErrMssg = BehaviorRelay(value: nil)
    emailNotValidErrMssg = BehaviorRelay(value: nil)
    passwordNotValidErrMssg = BehaviorRelay(value: nil)
    passwordConfirmationNotValidErrMssg = BehaviorRelay(value: nil)
    isSignupButtonEnabled = BehaviorRelay(value: nil)
    createdUser = BehaviorRelay(value: nil)
    error = BehaviorRelay(value: nil)
    willGoBack = BehaviorRelay(value: nil)
    setupBindings()
  }

  private var viewDidLoadProperty = PublishSubject<Void>()
  func viewDidLoad() {
    viewDidLoadProperty.onNext(())
  }

  private var setCompanyNameProperty = PublishSubject<String>()
  func set(companyName: String) {
    setCompanyNameProperty.onNext(companyName)
  }

  private var setEmailProperty = PublishSubject<String>()
  func set(email: String) {
    setEmailProperty.onNext(email)
  }

  private var setPasswordProperty = PublishSubject<String>()
  func set(password: String) {
    setPasswordProperty.onNext(password)
  }

  private var setPasswordConfirmationProperty = PublishSubject<String>()
  func set(passwordConfirmation: String) {
    setPasswordConfirmationProperty.onNext(passwordConfirmation)
  }

  private var signupProperty = PublishSubject<Void>()
  func signup() {
    signupProperty.onNext(())
  }

  private var didTapLeftBarButtonItemProperty = PublishSubject<Void>()
  func didTapLeftBarButtonItem() {
    didTapLeftBarButtonItemProperty.onNext(())
  }
}

extension SignupViewModel: EmailValidateable {
  func setupBindings() {
    setCompanyNameProperty.bind(to: name).disposed(by: disposeBag)
    setEmailProperty.bind(to: email).disposed(by: disposeBag)
    setPasswordProperty.bind(to: password).disposed(by: disposeBag)
    didTapLeftBarButtonItemProperty.bind(to: willGoBack).disposed(by: disposeBag)

    setCompanyNameProperty.map { $0.count > 4 ? .valid : .invalid }.bind(to: isNameValid).disposed(by: disposeBag)
    setPasswordConfirmationProperty
      .map { isPasswordValid.value == TextFieldStatus.valid && $0 == password.value ? .valid : .invalid }
      .bind(to: isPasswordConfirmationValid).disposed(by: disposeBag)
    setEmailProperty.map(isValidEmail(_:)).bind(to: isEmailValid).disposed(by: disposeBag)

    isEmailValid
      .filter { $0 == .invalid }
      .map { _ in "Entered email is not valid." }
      .bind(to: emailNotValidErrMssg)
      .disposed(by: disposeBag)

    isNameValid
      .filter { $0 == .invalid }
      .map { _ in "Name should be at least 5 in characters." }
      .bind(to: nameNotValidErrMssg)
      .disposed(by: disposeBag)

    setPasswordProperty
      .map { $0.count > 5 && $0.count < 21 ? .valid : .invalid }
      .bind(to: isPasswordValid)
      .disposed(by: disposeBag)

    isPasswordValid.filter { $0 == .invalid }
      .map { _ in "Password has to be from 6 to 20 characters long." }
      .bind(to: passwordNotValidErrMssg)
      .disposed(by: disposeBag)

    isPasswordConfirmationValid.filter { $0 == .invalid }
      .map { _ in "Doesn't match the password." }
      .bind(to: passwordConfirmationNotValidErrMssg)
      .disposed(by: disposeBag)

    isNameValid.filter { $0 == .valid }
      .map { _ in "" }
      .bind(to: nameNotValidErrMssg)
      .disposed(by: disposeBag)

    isEmailValid.filter { $0 == .valid }
      .map { _ in "" }
      .bind(to: emailNotValidErrMssg)
      .disposed(by: disposeBag)

    isPasswordValid.filter { $0 == .valid }
      .map { _ in "" }
      .bind(to: passwordNotValidErrMssg)
      .disposed(by: disposeBag)

    isPasswordConfirmationValid.filter { $0 == .valid }
      .map { _ in "" }
      .bind(to: passwordConfirmationNotValidErrMssg)
      .disposed(by: disposeBag)

    Observable.combineLatest(isNameValid, isEmailValid, isPasswordValid, isPasswordConfirmationValid)
      .map { $0 == TextFieldStatus.valid && $1 == TextFieldStatus.valid && $2 == TextFieldStatus.valid && $3 == TextFieldStatus.valid }
      .bind(to: isSignupButtonEnabled)
      .disposed(by: disposeBag)

    signupProperty
      .subscribe(onNext: { _ in
        do {
          let user = try authService.signUp(name: name.value, email: email.value, password: password.value)
          createdUser.accept(user!)
        } catch(let err) {
          error.accept(err)
        }
      }).disposed(by: disposeBag)
  }
}
