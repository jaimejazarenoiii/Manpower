//
//  SigninViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxCocoa
import RxSwift

class SigninViewController: UIViewController, Storyboarded {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet var emailErrLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet var passwordErrLabel: UILabel!
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!

  var viewModel: SigninViewModelTypes!
  let disposeBag = DisposeBag()

  deinit {
    print("SigninViewController#deinit")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "Back",
      style: .plain,
      target: self,
      action: #selector(didTapLeftBarButtonItem(_:)))
  }

  @IBAction func didTapLeftBarButtonItem(_ sender: Any) {
    viewModel.inputs.didTapLeftBarButtonItem()
  }

  private func setupBindings() {
    emailTextField.rx.text.orEmpty.distinctUntilChanged()
      .skip(1)
      .bind(onNext: viewModel.inputs.set(email:))
      .disposed(by: disposeBag)

    passwordTextField.rx.text.orEmpty.distinctUntilChanged()
      .skip(1)
      .bind(onNext: viewModel.inputs.set(password:))
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

    viewModel.outputs.emailNotValidErrMssg.bind(to: emailErrLabel.rx.text).disposed(by: disposeBag)
    viewModel.outputs.passwordNotValidErrMssg.bind(to: passwordErrLabel.rx.text).disposed(by: disposeBag)

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
    viewModel.outputs.isSigninButtonEnabled
      .filter { $0 != nil }
      .map { $0! }
      .bind(to: signinButton.rx.isEnabled)
      .disposed(by: disposeBag)

    viewModel.outputs.error
      .filter { $0 != nil }
      .map { $0! }
      .bind(onNext: { [weak self] error in
        guard let self = self else { return }
        self.show(err: error)
      })
      .disposed(by: disposeBag)

    signinButton.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.viewModel.inputs.signin()
    }).disposed(by: disposeBag)
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
