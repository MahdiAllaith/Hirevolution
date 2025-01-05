import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    var messages: [ChatMessage] = []  // Store all chat messages
    var currentUser: User?  // Store the current logged-in user

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell class (no NIB required)
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")

        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self

        // Add send button action
        sendButton.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)

        // Add observers for keyboard appearance
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Initialize current user (or fetch from auth)
        currentUser = getCurrentUser()
    }

    // Action for the Send button
    @objc func sendButtonTapped(_ sender: Any) {
        print("Send button tapped!")
        sendMessage()
    }

    // Send message function
    func sendMessage() {
        guard let messageText = messageTextField.text, !messageText.isEmpty else {
            return // Return if the message is empty
        }

        // Ensure we have a current user
        guard let currentUserID = currentUser?.id else {
            return
        }

        // Create a new message
        let newMessage = ChatMessage(userID: currentUserID, message: messageText)

        // Append the new message to the messages array
        messages.append(newMessage)

        print("Message sent: \(newMessage.message)") // Debug print

        // Reload the TableView on the main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToBottom() // Scroll to the latest message
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

    // Return the number of messages
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredMessages = messages.filter { $0.userID == currentUser?.id }
        return filteredMessages.count
    }

    //configure the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell

        let filteredMessages = messages.filter { $0.userID == currentUser?.id }
        let message = filteredMessages[indexPath.row]

        let isSender = message.userID == currentUser?.id
        cell.configure(with: message, isSender: isSender)

        return cell
    }
}
