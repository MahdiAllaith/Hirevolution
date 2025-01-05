import UIKit

class ChatMessageCell: UITableViewCell {

    

    //links the elements
    var messageBubble: UIView!
    var messageTextView: UITextView!
    var senderLabel: UILabel!

    // Padding
    private let padding: CGFloat = 16
    
    // width of the message bubble
    private let bubbleMaxWidth: CGFloat = 250

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()}

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
    }


   
    private func setupSubviews() {
        
        // Initialize and configure the message bubble
        messageBubble = UIView()
        messageBubble.layer.cornerRadius = 16  // Make the bubble rounded
        messageBubble.clipsToBounds = true  // Ensure content stays within the bubble's bounds
        contentView.addSubview(messageBubble)  // Add bubble to the cell's content view

        // message info
        messageTextView = UITextView()
        
        messageTextView.isEditable = false
        
        messageTextView.isSelectable = false
        
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        
        messageTextView.isScrollEnabled = false
        
        messageTextView.textContainer.lineFragmentPadding = 0
        
        messageTextView.textContainerInset = .zero
        
        messageBubble.addSubview(messageTextView)

       // resever layout
        senderLabel = UILabel()
        
        senderLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        senderLabel.textColor = .gray
        
        contentView.addSubview(senderLabel)
    }


    // This method configures the cell with message data and sender info
    func configure(with message: ChatMessage, isSender: Bool) {
        messageTextView.text = message.message  // Set the message content in the text view
        senderLabel.text = message.userID  // Set the sender's name

        // bubble color
        if isSender {
            messageBubble.backgroundColor = UIColor.systemBlue
            
            messageTextView.textColor = .white
            
            senderLabel.textColor = .white
            
            senderLabel.textAlignment = .right
            
        } else {
            messageBubble.backgroundColor = UIColor.systemGray
            
            messageTextView.textColor = .black
            
            senderLabel.textColor = .gray
            
            senderLabel.textAlignment = .left
        }

        // Trigger layout update after configuration
        setNeedsLayout()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Calculate the width
        let textWidth = min(contentView.frame.width - 2 * padding, bubbleMaxWidth)
        
        // Calculate the height
        let textHeight = messageTextView.sizeThatFits(CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        // Calculate the height of the message bubble
        let bubbleHeight = textHeight + padding * 2

        //sender name
        senderLabel.frame = CGRect(x: padding, y: padding, width: contentView.frame.width - 2 * padding, height: 20)

        // sapose to set the position of the bubble couldnt test it
        let bubbleX: CGFloat
        if messageTextView.textAlignment == .right {
            bubbleX = contentView.frame.width - textWidth - padding
        } else {
 
            bubbleX = padding
        }

        
        messageBubble.frame = CGRect(x: bubbleX, y: senderLabel.frame.maxY + padding,
                                     width: textWidth, height: bubbleHeight)
        
        
        // message fits with the bubble
        messageTextView.frame = CGRect(x: 0, y: 0, width: textWidth, height: textHeight)
        messageTextView.sizeToFit()

        // Remove internal padding
        messageTextView.textContainer.lineFragmentPadding = 0
        
        messageTextView.textContainerInset = .zero
        
    }
}
