//
//  OnboardingViewModel.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 5/5/22.
//

import RxCocoa
import RxSwift

protocol OnboardingViewModelInputs {
  func signinIsTapped()
  func signupIsTapped()
}

protocol OnboardingViewModelOutputs {
  var didTapSignin: BehaviorRelay<Void?> { get }
  var didTapSignup: BehaviorRelay<Void?> { get }
}

protocol OnboardingViewModelType {
  var inputs: OnboardingViewModelInputs { get }
  var outputs: OnboardingViewModelOutputs { get }
}

struct OnboardingViewModel: OnboardingViewModelType, OnboardingViewModelOutputs, OnboardingViewModelInputs {
  var inputs: OnboardingViewModelInputs { return self }

  var outputs: OnboardingViewModelOutputs { return self }

  var didTapSignin: BehaviorRelay<Void?>
  var didTapSignup: BehaviorRelay<Void?>

  private let disposeBag = DisposeBag()

  init() {
    didTapSignin = .init(value: nil)
    didTapSignup = .init(value: nil)

    setupBindings()
  }

  private func setupBindings() {
    signinIsTappedProperty.bind(to: didTapSignin).disposed(by: disposeBag)
    signupIsTappedProperty.bind(to: didTapSignup).disposed(by: disposeBag)
  }

  private let signinIsTappedProperty = PublishSubject<Void>()
  func signinIsTapped() {
    signinIsTappedProperty.onNext(())
  }

  private let signupIsTappedProperty = PublishSubject<Void>()
  func signupIsTapped() {
    signupIsTappedProperty.onNext(())
  }
}
