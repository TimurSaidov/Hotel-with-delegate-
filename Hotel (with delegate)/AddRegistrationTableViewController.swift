//
//  AddRegistrationTableViewController.swift
//  Hotel (with delegate)
//
//  Created by Timur Saidov on 23/10/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    // Первая секция.
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // Вторая секция.
    @IBOutlet weak var arrivalDate: UILabel!
    @IBOutlet weak var arrivalDatePicker: UIDatePicker!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    
    let arrivalDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let departureDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    var isArrivalDatePickerShown: Bool = false {
        didSet {
            arrivalDatePicker.isHidden = !isArrivalDatePickerShown
        }
    }
    var isDepartureDatePickerShown: Bool = false {
        didSet {
            departureDatePicker.isHidden = !isDepartureDatePickerShown
        }
    }
    
    // Третья секция.
    @IBOutlet weak var adultsCount: UILabel!
    @IBOutlet weak var adultsStepper: UIStepper!
    @IBOutlet weak var childrenCount: UILabel!
    @IBOutlet weak var childrenStepper: UIStepper!
    
    var adultsCountInt = 0
    var childrenCountInt = 0
    var senderValueAdults = 0
    var senderValueChildren = 0
    
    // Четвертая секция.
    @IBOutlet weak var wifiSwitch: UISwitch!
    var wifi: Bool = false
    
    // Пятая секция.
    @IBOutlet weak var roomTypeLabel: UILabel!
    var selectedRoomType: RoomType?
    
    @IBAction func updateDate(_ sender: UIDatePicker) {
        updateDate()
    }
    
    @IBAction func countStepper(_ sender: UIStepper) {
        if sender == adultsStepper {
            if Int(sender.value) == senderValueAdults + 1 {
                senderValueAdults += 1
                adultsCountInt += 1
                adultsCount.text = String(adultsCountInt)
            } else if Int(sender.value) == senderValueAdults - 1 {
                senderValueAdults -= 1
                adultsCountInt -= 1
                adultsCount.text = String(adultsCountInt)
            }
        } else if sender == childrenStepper {
            if Int(sender.value) == senderValueChildren + 1 {
                senderValueChildren += 1
                childrenCountInt += 1
                childrenCount.text = String(childrenCountInt)
            } else if Int(sender.value) == senderValueChildren - 1 {
                senderValueChildren -= 1
                childrenCountInt -= 1
                childrenCount.text = String(childrenCountInt)
            }
        }
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            wifi = true
        } else {
            wifi = false
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        guard firstNameTextField.text != "" && lastNameTextField.text != "" && emailTextField.text != "" else {
            let ac = UIAlertController(title: "Enter all text fields please", message: "You should enter your name, surname and email adress", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
            
            return
        }
        
        guard adultsCountInt != 0 else {
            let ac = UIAlertController(title: "Select the number of adults and children", message: "The number of adults and children should not be equal 0", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
            
            return
        }
        
        guard let roomType = selectedRoomType else {
            let ac = UIAlertController(title: "Choise room type please", message: "You should choise any room type to make registration", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            ac.addAction(ok)
            self.present(ac, animated: true, completion: nil)
            
            return
        }
        
        print(firstNameTextField.text!, lastNameTextField.text!, emailTextField.text!, arrivalDatePicker.date, departureDatePicker.date, adultsCountInt, childrenCountInt, wifi, roomType)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        arrivalDatePicker.minimumDate = midnightToday
        arrivalDatePicker.date = midnightToday
        updateDate()
        
        adultsCount.text = String(adultsCountInt)
        childrenCount.text = String(childrenCountInt)
    }
    
    // Метод, вызывающийся при отображении ячеек. То есть когда приходит запрос на высоту ячейки indexPath.row  в секции indexPath.section.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case arrivalDatePickerCellIndexPath:
            if isArrivalDatePickerShown {
                return 216
            } else {
                return 0
            }
        case departureDatePickerCellIndexPath:
            if isDepartureDatePickerShown {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    // Метод, вызывающийся при нажатии на ячейку.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.beginUpdates()
        switch (indexPath.section, indexPath.row) {
        case (arrivalDatePickerCellIndexPath.section, arrivalDatePickerCellIndexPath.row - 1):
            if isArrivalDatePickerShown {
                isArrivalDatePickerShown = false
            } else if isDepartureDatePickerShown {
                isDepartureDatePickerShown = false
                isArrivalDatePickerShown = true
            } else {
                isArrivalDatePickerShown = true
            }
        case (departureDatePickerCellIndexPath.section, departureDatePickerCellIndexPath.row - 1):
            if isDepartureDatePickerShown {
                isDepartureDatePickerShown = false
            } else if isArrivalDatePickerShown {
                isArrivalDatePickerShown = false
                isDepartureDatePickerShown = true
            } else {
                isDepartureDatePickerShown = true
            }
        default:
            isArrivalDatePickerShown = false
            isDepartureDatePickerShown = false
        }
        tableView.endUpdates() // вместо этого блока beginUpdates()-endUpdates() можно tableView.reloadData(), но не имеет смысла, т.к. нет источника данных. Также reloadData() можно использовать, если не нужна анимация.
        
        tableView.endEditing(true) 
    }
    
    func updateDate() {
        departureDatePicker.minimumDate = arrivalDatePicker.date.addingTimeInterval(60 * 60 * 24) // При изменении даты в arrivalDatePicker (как только установили дату, сработал @IBAction updateDate) вызывается этот метод, где меняется минимальная дата departureDatePicker относительно выбранной даты в arrivalDatePicker на одень день вперед. Затем идет отображение этих дат в lable'ы. При изменении даты в departureDatePicker, его минимальная дата остается той же, т.к. arrivalDatePicker не трогали, но зато обновляется поле departureDate.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        arrivalDate.text = dateFormatter.string(from: arrivalDatePicker.date)
        departureDate.text = dateFormatter.string(from: departureDatePicker.date)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let detailTableViewController = navigationController.viewControllers.first as? DetailTableViewController else { return }
            
            if let roomType = selectedRoomType {
                detailTableViewController.selectedRoomType = roomType
            }
            
            detailTableViewController.delegate = self
        }
    }
}

extension AddRegistrationTableViewController: SelectedRoomTypeDelegate {
    func didSelect(roomType: RoomType) {
        selectedRoomType = roomType
        roomTypeLabel.text = roomType.name
    }
}
