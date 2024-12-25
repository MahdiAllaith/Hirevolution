import UIKit

class ChatViewController: UIViewController {

    // 1. IBOutlet for TableView, TextField, and Button
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var messages: [ChatMessage] = []  // Store all chat messages
    var currentUser: User?  // Store the current logged-in user

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the NIB for the custom cell
        let nib = UINib(nibName: "ChatMessageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatMessageCell")

        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self

        // Add send button action
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)

        // Add observers for keyboard appearance
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Action for the Send button
    @objc func sendButtonTapped() {
        print("Send button tapped!")
        sendMessage()
    }

    // Send message function
    func sendMessage() {
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
            return
        }

        // Ensure we have a current user
        guard let currentUserID = currentUser?.id else {
            return
        }

        // Create a new message
        let newMessage = ChatMessage(userID: currentUserID, message: messageText, timestamp: Date())
        messages.append(newMessage)

        print("Message sent: \(newMessage.message)") // Debug print

        // Reload the TableView on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToBottom()
        }

        // Clear the TextField
        messageTextField.text = ""
    }

    // Scroll to the bottom of the TableView to show the latest message
    func scrollToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    // Handle keyboard appearance and adjust view
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    // Dummy function to represent fetching the current user
    func getCurrentUser() -> User? {
        return User(id: "user1", fullName: "Alice Smith", eMail: "alice@example.com", password: "password123", option: "someOption")
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {

    // Return the number of messages in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // Dequeue and configure the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        
        // Determine if the message is from the current user
        let isSender = message.userID == currentUser?.id
        
        print("Configuring cell for message: \(message.message)") // Debug print
        
        cell.configure(with: message, isSender: isSender)
        
        return cell
    }
}
