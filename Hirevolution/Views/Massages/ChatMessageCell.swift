import UIKit

class ChatMessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!  // The message bubble UIView
    @IBOutlet weak var messageTextView: UITextView!  // The UITextView for the message text
    @IBOutlet weak var senderLabel: UILabel!   // (Optional) Sender's name

    override func awakeFromNib() {
        super.awakeFromNib()

        // Customizing the message bubble
        messageBubble.layer.cornerRadius = 16
        messageBubble.clipsToBounds = true  // Ensures that the content (text) is confined within the bubble

        // Make the UITextView non-editable so it behaves like a label
        messageTextView.isEditable = false
        messageTextView.isSelectable = false
    }

    // Configure the cell with the message and sender info
    func configure(with message: ChatMessage, isSender: Bool) {
        // Set the message text and sender's name
        messageTextView.text = message.message
        senderLabel.text = message.userID // Using userID instead of 'sender' as 'sender' doesn't exist

        // Adjust the appearance based on whether it's the sender or receiver
        if isSender {
            messageBubble.backgroundColor = UIColor.systemBlue  // Blue for sender's bubble
            messageTextView.textColor = .white
            senderLabel.textColor = .white
            senderLabel.textAlignment = .right
        } else {
            messageBubble.backgroundColor = UIColor.systemGray  // Gray for receiver's bubble
            messageTextView.textColor = .black
            senderLabel.textColor = .gray
            senderLabel.textAlignment = .left
        }

        // Adjust the position of the message bubble based on the sender/receiver
        if isSender {
            messageBubble.frame.origin.x = self.contentView.frame.width - messageBubble.frame.width - 10
        } else {
            messageBubble.frame.origin.x = 10
        }
    }
}
