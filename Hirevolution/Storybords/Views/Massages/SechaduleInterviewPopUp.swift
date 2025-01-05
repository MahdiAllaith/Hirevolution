import UIKit
import FirebaseFirestore

class SechaduleInterviewPopUp: UIViewController {
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var notes: UITextView!
    
    var userID: String = ""
    var jobID: String = ""
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy, h:mm a"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard dateTF != nil else {
            print("dateTF is not connected properly.")
            return
        }

        if userID.isEmpty {
            notes.text = "No scheduled interviews available for this user."
            return
        }

        setupDatePicker()
        dateTF.text = formatDate(date: Date())
        fetchScheduledInterviews()
    }

    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        dateTF.inputView = datePicker
    }

    @objc func dateChange(datePicker: UIDatePicker) {
        dateTF.text = formatDate(date: datePicker.date)
    }

    func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        print("Send button tapped")
        sendButton.isEnabled = false
        
        guard let selectedDateText = dateTF.text, !selectedDateText.isEmpty else {
            print("No valid date selected.")
            sendButton.isEnabled = true
            return
        }

        if let selectedDate = dateFormatter.date(from: selectedDateText) {
            let interview = ScheduledInterview(interviewDate: selectedDate, userID: userID, jobID: jobID)
            TimeHandler.shared.saveInterviewToFirebase(interview) { success in
                self.sendButton.isEnabled = true
                if success {
                    let alert = UIAlertController(title: "Interview Scheduled",
                                                  message: "Your interview has been scheduled for \(selectedDate).",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    })
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("Failed to save interview.")
                }
            }
        } else {
            sendButton.isEnabled = true
        }
    }

    private func fetchScheduledInterviews() {
        let db = Firestore.firestore()
        if userID.isEmpty {
            print("Error: userID is still empty when fetching scheduled interviews.")
            return
        }

        db.collection("users").document(userID).collection("interviews").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching scheduled interviews: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                self.notes.text = "No scheduled interviews available for this user."
                return
            }
            
            var scheduledTimes = ""
            for document in documents {
                if let interviewDate = (document.get("interviewDate") as? Timestamp)?.dateValue() {
                    scheduledTimes += "\(self.formatDate(date: interviewDate))\n"
                }
            }
            self.notes.text = scheduledTimes.isEmpty ? "No scheduled interviews found." : scheduledTimes
        }
    }
}
