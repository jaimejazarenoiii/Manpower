//
//  EmployeeTableViewCell.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import UIKit
import RxSwift

protocol EmployeeTableViewCellDelegate: AnyObject {
    func didTapEdit(source: EmployeeTableViewCell, employee: Employee)
    func didTapDelete(source: EmployeeTableViewCell, employee: Employee)
    func didToggleStatus(source: EmployeeTableViewCell, employee: Employee, isOn: Bool)
}

class EmployeeTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var contextButton: UIButton!
    weak var delegate: EmployeeTableViewCellDelegate?

    private var employee: Employee?
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupMenu()
        setupBindings()
    }

    private func setupMenu() {
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self, let employee = self.employee else { return }
            self.delegate?.didTapEdit(source: self, employee: employee)
        }

        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [weak self] action in
            guard let self = self, let employee = self.employee else { return }
            self.delegate?.didTapDelete(source: self, employee: employee)
        }

        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        contextButton.menu = menu
        contextButton.showsMenuAsPrimaryAction = true
    }

    func set(employee: Employee) {
        self.employee = employee
        nameLabel.text = employee.name
        emailLabel.text = employee.email
        let isOn = employee.status == .active
        statusSwitch.setOn(isOn, animated: false)
    }

    private func setupBindings() {
        statusSwitch.rx.isOn
            .subscribe(onNext: { [unowned self] isOn in
                self.delegate?.didToggleStatus(source: self, employee: self.employee!, isOn: isOn)
            }).disposed(by: disposeBag)

    }
}
