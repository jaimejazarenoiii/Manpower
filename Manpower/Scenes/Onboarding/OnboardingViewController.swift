//
//  OnboardingViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol OnboardingViewControllerDelegate: AnyObject {
    func didTapSignin(source: OnboardingViewController)
    func didTapSignup(source: OnboardingViewController)
}

class OnboardingViewController: UIViewController, Storyboarded {
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    weak var delegate: OnboardingViewControllerDelegate?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        signinButton.rx.tap.bind { [unowned self] _ in
            self.delegate?.didTapSignin(source: self)
        }.disposed(by: disposeBag)
        signupButton.rx.tap.bind { [unowned self] _ in
            self.delegate?.didTapSignup(source: self)
        }.disposed(by: disposeBag)
    }
}
