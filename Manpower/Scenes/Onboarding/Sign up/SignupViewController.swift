//
//  SignupViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignupViewControllerDelegate: AnyObject {
    func didSignupSuccessfully(source: SignupViewController, createdUser: User)
}

class SignupViewController: UIViewController, Storyboarded {
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var nameErrLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrLabel: UILabel!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordConfirmationErrLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    var viewModel: SignupViewModelTypes!
    weak var delegate: SignupViewControllerDelegate?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        companyNameTextField.rx.text.orEmpty.distinctUntilChanged()
            .skip(1)
            .bind(onNext: viewModel.inputs.set(companyName:))
            .disposed(by: disposeBag)

        emailTextField.rx.text.orEmpty.distinctUntilChanged()
            .skip(1)
            .bind(onNext: viewModel.inputs.set(email:))
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty.distinctUntilChanged()
            .skip(1)
            .bind(onNext: viewModel.inputs.set(password:))
            .disposed(by: disposeBag)

        passwordConfirmationTextField.rx.text.orEmpty.distinctUntilChanged()
            .skip(1)
            .bind(onNext: viewModel.inputs.set(passwordConfirmation:))
            .disposed(by: disposeBag)

        viewModel.outputs.isNameValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: companyNameTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isEmailValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: emailTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isPasswordValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: passwordTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isPasswordConfirmationValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: passwordConfirmationTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.nameNotValidErrMssg.bind(to: nameErrLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.emailNotValidErrMssg.bind(to: emailErrLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.passwordNotValidErrMssg.bind(to: passwordErrLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.passwordConfirmationNotValidErrMssg.bind(to: passwordConfirmationErrLabel.rx.text).disposed(by: disposeBag)

        viewModel.outputs.nameNotValidErrMssg
            .filter { $0 != nil }
            .map { $0!.isEmpty }
            .bind(to: nameErrLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.outputs.emailNotValidErrMssg
            .filter { $0 != nil }
            .map { $0!.isEmpty }
            .bind(to: emailErrLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.outputs.passwordNotValidErrMssg
            .filter { $0 != nil }
            .map { $0!.isEmpty }
            .bind(to: passwordErrLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.outputs.passwordConfirmationNotValidErrMssg
            .filter { $0 != nil }
            .map { $0!.isEmpty }
            .bind(to: passwordConfirmationErrLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.outputs.isSignupButtonEnabled
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.outputs.createdUser
            .filter { $0 != nil }
            .map { $0! }
            .bind(onNext: successSignup(createdUser:))
            .disposed(by: disposeBag)
        viewModel.outputs.error
            .filter { $0 != nil }
            .map { $0! }
            .bind(onNext: show(err:))
            .disposed(by: disposeBag)

        viewModel.inputs.viewDidLoad()

        signupButton.rx.tap.bind(onNext: { [unowned self] _ in
            self.viewModel.inputs.signup()
        }).disposed(by: disposeBag)
    }

    private func successSignup(createdUser: User) {
        delegate?.didSignupSuccessfully(source: self, createdUser: createdUser)
    }

    private func show(err: Error) {
        guard let error = err as? AuthService.AuthError else { return }
        let alert = UIAlertController(title: "Error",
                                      message: error.message,
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
