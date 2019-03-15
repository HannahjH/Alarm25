//
//  AlarmDetailTableViewController.swift
//  Alarm25
//
//  Created by Hannah Hoff on 3/11/19.
//  Copyright © 2019 Hannah Hoff. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool = true
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   private func updateViews() {
        guard let alarm = alarm else  { return }
    if alarmIsOn == alarm.enabled {
        enableButton.setTitle("On", for: .normal)
        enableButton.backgroundColor = .white
    } else {
        enableButton.setTitle("Off", for: .normal)
        enableButton.backgroundColor = .purple
    }
        datePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.name
    
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = alarmNameTextField.text else { return }
        guard title != "" else { return }
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: title, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: title, enabled: alarmIsOn)
        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmDetailCell", for: indexPath)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
