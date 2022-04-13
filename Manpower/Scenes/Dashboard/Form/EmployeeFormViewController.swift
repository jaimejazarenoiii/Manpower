//
//  EmployeeFormViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/8/22.
//

import UIKit
import RxCocoa
import RxSwift

class EmployeeFormViewController: UIViewController, Storyboarded {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    var viewModel: EmployeeFormViewModelTypes!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let employee = viewModel.outputs.employee.value {
            nameTextField.text = employee.name
            emailTextField.text = employee.email
        }
        setupBindings()
    }

    private func setupBindings() {
        nameTextField.rx.text.orEmpty.distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .skip(1)
            .bind(onNext: viewModel.inputs.set(name:))
            .disposed(by: disposeBag)

        emailTextField.rx.text.orEmpty.distinctUntilChanged()
            .skip(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: viewModel.inputs.set(email:))
            .disposed(by: disposeBag)

        viewModel.outputs.isNameValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: nameTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.isEmailValid
            .filter { $0 != nil }
            .map { $0!.borderColor }
            .bind(to: emailTextField.rx.borderColor)
            .disposed(by: disposeBag)

        viewModel.outputs.nameNotValidErrMssg
            .bind(to: nameErrLabel.rx.text).disposed(by: disposeBag)
        viewModel.outputs.emailNotValidErrMssg.bind(to: emailErrLabel.rx.text).disposed(by: disposeBag)

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

        viewModel.outputs.isSuccess
            .filter { $0 != nil }
            .map { $0! }
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.successAdd()
            })
            .disposed(by: disposeBag)
        viewModel.outputs.error
            .filter { $0 != nil }
            .map { $0! }
            .bind(onNext: show(err:))
            .disposed(by: disposeBag)

        saveButton.rx.tap.bind(onNext: { [unowned self] _ in
            self.viewModel.inputs.save()
        }).disposed(by: disposeBag)

        cancelButton.rx.tap.bind { [unowned self] _ in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)

        viewModel.inputs.viewDidLoad()
    }

    private func successAdd() {
        dismiss(animated: true)
    }

    private func show(err: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: err.localizedDescription,
                                      preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
