//
//  DetailTableViewController.swift
//  Hotel (with delegate)
//
//  Created by Timur Saidov on 23/10/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var roomTypePicker: UIPickerView!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var roomPriceLabel: UILabel!
    
    var roomType: [RoomType] = [
        RoomType(id: 0, name: "Single", shortName: "SNGL", price: 100),
        RoomType(id: 1, name: "Double", shortName: "DBL", price: 200),
        RoomType(id: 2, name: "Triple", shortName: "TRPL", price: 300),
        RoomType(id: 3, name: "Quadriple", shortName: "QDPL", price: 400),
        RoomType(id: 4, name: "Double + Extra bed", shortName: "EXB", price: 265),
        RoomType(id: 5, name: "Single + Infant", shortName: "SNGL+INF", price: 125),
        RoomType(id: 6, name: "Single + Child", shortName: "SNGL+CHL", price: 145),
        RoomType(id: 7, name: "Double + Infant", shortName: "DBL+INF", price: 225),
        RoomType(id: 8, name: "Double + Child", shortName: "DBL+CHL", price: 245),
        ]
    
    var isRoomTypePickerShown: Bool = false
    var delegate: SelectedRoomTypeDelegate?
    var selectedRoomType: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTypePicker.dataSource = self
        roomTypePicker.delegate = self
        
        if let roomType = selectedRoomType {
            roomTypeLabel.text = roomType.name
            roomPriceLabel.text = "$\(roomType.price) / 1 day"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 1, section: 0):
            if isRoomTypePickerShown {
                return 216
            } else {
                return 0
            }
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if isRoomTypePickerShown {
                isRoomTypePickerShown = false
            } else {
                isRoomTypePickerShown = true
                // Нажимая на ячейку Type-Price (0-ая ячейка 0-ой секции), эти label'ы заменяются первым элементом roomTypePicker, а именно RoomType(id: 0, name: "Single", shortName: "SNGL", price: 100).
                pickerUpdate()
            }
        default:
            isRoomTypePickerShown = false
        }
        tableView.reloadData()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomType.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(roomType[row].name) - $\(roomType[row].price)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerUpdate()
    }
    
    func pickerUpdate() {
        let selectedRow = roomTypePicker.selectedRow(inComponent: 0)
        let selectedRoomType = roomType[selectedRow]
        
        roomTypeLabel.text = selectedRoomType.name
        roomPriceLabel.text = "$\(selectedRoomType.price) / 1 day"
        
        // Вызывается делегат, т.е. AddRegistrationTableViewController, и его метод didSelect. где сразу при выборе типа комнаты, она отображается в lable'e AddRegistrationTableViewController'а.
        delegate?.didSelect(roomType: selectedRoomType)
    }
}

protocol SelectedRoomTypeDelegate {
    func didSelect(roomType: RoomType)
}
