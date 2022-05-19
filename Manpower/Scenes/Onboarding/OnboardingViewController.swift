//
//  OnboardingViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController, Storyboarded {
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var signupButton: UIButton!
  let disposeBag = DisposeBag()
  var viewModel: OnboardingViewModelType?

  deinit {
    print("OnboardingViewController#deinit")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
  }

  private func setupBindings() {
    signinButton.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.viewModel?.inputs.signinIsTapped()
    }).disposed(by: disposeBag)
    signupButton.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.viewModel?.inputs.signupIsTapped()
    }).disposed(by: disposeBag)
  }
}
