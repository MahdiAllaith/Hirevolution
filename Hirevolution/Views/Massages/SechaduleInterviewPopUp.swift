import UIKit

class SechaduleInterviewPopUp: UIViewController {

    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var SendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the date picker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime // This will show both date and time
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels

        // Set the date picker as input view for the text field
        dateTF.inputView = datePicker
        dateTF.text = formatDate(date: Date()) // Set current date and time
    }

    // Method to handle date changes in the picker
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = formatDate(date: datePicker.date)
    }

    // Method to format the date to a string
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy, h:mm a"
        return formatter.string(from: date)
    }

    // Action when the "Send" button is tapped
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        // Check if a valid date is selected
        if let selectedDateText = dateTF.text, !selectedDateText.isEmpty, let selectedDate = DateFormatter().date(from: selectedDateText) {
            // Create a ScheduledInterview object
            let interview = ScheduledInterview(interviewDate: selectedDate)
            
            // Save the schedule using the DataHandler singleton
            InterviewTime.shared.addSchedule(interview: interview)
            
            // Print confirmation (for testing)
            print("Interview scheduled for: \(selectedDate)")
            
            // Optionally, you can dismiss the pop-up or show another alert here
        } else {
            print("No valid date selected.")
        }
    }
}
