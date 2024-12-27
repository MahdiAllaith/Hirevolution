import UIKit
import FirebaseFirestore

class SechaduleInterviewPopUp: UIViewController {
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // Declare a variable to store the userID passed from the ManageApplicant page
    var userID: String?  // This will be set when the pop-up is shown
    var jobID: String?   // This will be set when the pop-up is shown

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
        print("Send button tapped")  // Log when the button is tapped
        
        // Check if a valid date has been selected
        if let selectedDateText = dateTF.text {
            print("Selected Date Text: \(selectedDateText)")  // Log the value from the text field
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd yyyy, h:mm a"
            
            // Convert selected date string to Date object
            if let selectedDate = formatter.date(from: selectedDateText) {
                print("Converted Date: \(selectedDate)")  // Log the converted Date
                
                // Check if both userID and jobID are available
                if let userID = userID, let jobID = jobID {
                    // Create a ScheduledInterview object
                    let interview = ScheduledInterview(interviewDate: selectedDate, userID: userID, jobID: jobID)
                    
                    // Save the interview to Firebase using TimeHandler, passing the userID and jobID
                    TimeHandler.shared.saveInterviewToFirebase(interview) { success in
                        if success {
                            print("Interview scheduled for: \(selectedDate)")
                            
                            // Show alert when the interview is successfully scheduled
                            let alert = UIAlertController(title: "Interview Scheduled",
                                                          message: "Your interview has been scheduled for \(selectedDate).",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
                            // Present the alert
                            self.present(alert, animated: true, completion: nil)
                            
                            // Optionally, dismiss the pop-up
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("Failed to save interview.")
                        }
                    }
                } else {
                    print("User ID or Job ID is missing.")
                }
            } else {
                print("Invalid date format.")
            }
        } else {
            print("No valid date selected.")
        }
    }
}
