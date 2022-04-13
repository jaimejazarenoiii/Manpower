//
//  DashboardViewController.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import UIKit
import RxSwift

protocol DashboardViewControllerDelegate: AnyObject {
    func didSignout(source: DashboardViewController)
    func willAddEmployee(source: DashboardViewController)
    func willEditEmployee(source: DashboardViewController, employee: Employee)
}

class DashboardViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    var viewModel: DashboardViewModelTypes!
    weak var delegate: DashboardViewControllerDelegate?

    private let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        setupScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.outputs.employees
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [weak self] tableView, row, item -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell") as! EmployeeTableViewCell
                cell.set(employee: item)
                cell.delegate = self
                return cell
            }
            .disposed(by: disposeBag)

        addButton.rx.tap
            .bind { [unowned self] _ in
                self.delegate?.willAddEmployee(source: self)
            }
            .disposed(by: disposeBag)

        signoutButton.rx.tap.bind(onNext: { [unowned self] _ in
            self.delegate?.didSignout(source: self)
        }).disposed(by: disposeBag)

        viewModel.inputs.viewDidLoad()
    }
}

extension DashboardViewController {
    func setupScene() {
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
    }
}

extension DashboardViewController: EmployeeTableViewCellDelegate {
    func didTapEdit(source: EmployeeTableViewCell, employee: Employee) {
        self.delegate?.willEditEmployee(source: self, employee: employee)
    }

    func didTapDelete(source: EmployeeTableViewCell, employee: Employee) {
        viewModel.inputs.delete(employee: employee)
    }

    func didToggleStatus(source: EmployeeTableViewCell, employee: Employee, isOn: Bool) {
        viewModel.inputs.toggle(from: employee, isOn: isOn)
    }
}
