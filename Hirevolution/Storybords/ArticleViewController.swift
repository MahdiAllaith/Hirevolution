//
//  ArticleViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ArticleCollectionCard: UICollectionView!
    var arrofContent = [Content]()
    var selectedCardTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = selectedCardTitle {
                    loadContent(for: title)
                }
                
                // Setup collection view delegate and data source
                ArticleCollectionCard.delegate = self
                ArticleCollectionCard.dataSource = self
            }
            
            // Load the content based on the selected card title
            func loadContent(for title: String) {
                if title == "Interview Tips" {
                    arrofContent = [
                        Content(header: "1. Research the Company", article: "Take time to understand the company’s mission, values, and recent achievements. Familiarize yourself with their industry, competitors, and any recent news. This knowledge will show the interviewer that you’re genuinely interested and prepared."),
                        Content(header: "2. Practice Common Questions", article: "While you can't predict every question, preparing answers for common interview questions can help you feel confident. Think about your strengths, weaknesses, achievements, and how your skills align with the job role. Practicing with a friend or recording yourself can be helpful to refine your answers."),
                        Content(header: "3. Use the STAR Method", article: "For questions about past experiences, try the STAR method: Situation, Task, Action, Result. Describe a relevant situation, what you had to accomplish, the steps you took, and the outcome. This structured approach helps showcase your skills and problem-solving abilities effectively."),
                        Content(header: "4. Dress Appropriately", article: "First impressions matter, so choose attire that reflects the company's culture. If you're unsure, err on the side of formality. Looking polished and professional can boost your confidence and show respect for the interview process."),
                        Content(header: "5. Ask Thoughtful Questions", article: "Prepare questions to ask the interviewer that show your interest in the role and the company, like “What are the team’s main goals for the next year?” or “How do you define success in this position?” Thoughtful questions demonstrate that you're serious about finding a good fit."),
                        Content(header: "6. Follow Up with a Thank-You Note", article: "Send a brief thank-you email after the interview to express your appreciation. Mention something specific you discussed during the interview to make it personal. It’s a small gesture that can leave a positive impression.")
                    ]
                } else if title == "Time Management Tips" {
                    arrofContent = [
                        Content(header: "1. Prioritize Tasks with the Eisenhower Matrix", article: "Use the Eisenhower Matrix to categorize tasks into four groups: urgent and important, important but not urgent, urgent but not important, and neither urgent nor important. Focus on high-priority tasks first to make sure you’re spending your time on what truly matters."),
                        Content(header: "2. Set Specific Goals and Deadlines", article: "Break down big projects into smaller, actionable steps with clear deadlines. Setting realistic goals and giving yourself target dates for each task can help you stay on track and motivated."),
                        Content(header: "3. Use the Pomodoro Technique", article: "Work in 25-minute intervals (or 'Pomodoros') followed by a 5-minute break. After four cycles, take a longer break of 15-30 minutes. This method helps maintain focus, prevents burnout, and boosts productivity."),
                        Content(header: "4. Limit Distractions", article: "Identify common distractions and minimize them as much as possible. Silence notifications, close unrelated tabs, and set boundaries with others during focused work periods. For tasks requiring deep concentration, consider using ‘do not disturb’ or noise-canceling tools."),
                        Content(header: "5. Batch Similar Tasks Together", article: "Group similar tasks together to increase efficiency. For example, check emails in batches rather than constantly switching between tasks. This reduces task-switching time and mental load."),
                        Content(header: "6. Reflect and Adjust Regularly", article: "Take time each week to review what worked well and where you can improve. Reflecting on your productivity helps you adjust your approach, refine your time management techniques, and set yourself up for success in the week ahead.")
                    ]
                } else if title == "CV Building Tips" {
                    arrofContent = [
                        Content(header: "1. Tailor Your CV to the Job", article: "Each job application is unique, so take time to adjust your CV to highlight the most relevant skills and experiences. Incorporate keywords from the job description and emphasize accomplishments that directly relate to the position you’re applying for."),
                        Content(header: "2. Use a Clean and Professional Format", article: "Choose a simple, professional layout that’s easy to read. Avoid flashy graphics or fonts, which can be distracting. Use headings, bullet points, and consistent font sizes to create a well-organized CV that makes it easy for recruiters to find key information."),
                        Content(header: "3. Highlight Achievements, Not Just Responsibilities", article: "Employers want to know what impact you made in your previous roles. Focus on achievements rather than just listing responsibilities. For example, instead of saying “Handled customer complaints,” you could say “Resolved 95% of customer complaints within 24 hours, improving satisfaction ratings.”"),
                        Content(header: "4. Include a Strong Profile Summary", article: "A brief profile summary at the top can provide a quick overview of your experience, skills, and career goals. Keep it concise, and focus on what makes you a valuable candidate. For example, “Experienced marketing professional with a track record of boosting online engagement by 30%.”"),
                        Content(header: "5. Quantify Where Possible", article: "Numbers make accomplishments more impactful. Use metrics like percentages, revenue increases, or customer satisfaction scores to add weight to your achievements. For example, “Increased team productivity by 20%” gives a clearer sense of your contributions than general statements."),
                        Content(header: "6. Proofread Thoroughly", article: "Even small errors can reflect poorly on your attention to detail. Carefully proofread your CV, and consider asking a friend or mentor to review it as well. Ensure consistent formatting, correct dates, and error-free content.")
                    ]
                } else if title == "Public Speaking Tips" {
                    arrofContent = [
                        Content(header: "1. Know Your Audience", article: "Tailor your content to fit the interests and knowledge level of your audience. Knowing who you’re speaking to helps you craft relevant examples, anticipate questions, and create a connection with your listeners."),
                        Content(header: "2. Prepare Thoroughly", article: "Practice your speech multiple times. Familiarize yourself with key points rather than memorizing everything word-for-word. Practicing with a friend, recording yourself, or using a mirror can help you refine your delivery and work out any nervousness."),
                        Content(header: "3. Use Body Language Effectively", article: "Your body language conveys confidence and engages your audience. Maintain eye contact, use purposeful gestures, and avoid fidgeting. Standing tall and moving naturally makes you appear confident and more approachable."),
                        Content(header: "4. Pace Yourself", article: "Speaking too quickly can make you seem nervous and can be difficult for the audience to follow. Practice slowing down and pausing occasionally to emphasize key points and allow listeners to absorb information. Breathing deeply and regularly also helps maintain a steady pace."),
                        Content(header: "5. Engage with Your Audience", article: "Interact by asking questions, inviting opinions, or encouraging feedback. Making your presentation interactive keeps the audience’s attention and helps them feel more involved in your message."),
                        Content(header: "6. Use Visual Aids Wisely", article: "Visuals can enhance your presentation, but they should complement your message, not overwhelm it. Keep slides simple and uncluttered, and use images or graphics to emphasize key points. Make sure you’re not reading directly from slides, as this can disengage your audience.")
                    ]
                }
                
                // Reload the collection view to reflect changes
                ArticleCollectionCard.reloadData()
            }
            
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return arrofContent.count  // One section for each content
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1  // One item per section, as each section corresponds to one article
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! ArticleCollectionViewCell
            
            // Get the content for the current section
            let content = arrofContent[indexPath.section]
            
            // Set the content for the cell (the article text)
            cell.lblContent.text = content.article
            
            // Debugging: Check if the content is properly assigned
            print("Article Content for section \(indexPath.section): \(content.article)")
            
            return cell
        }
        
        // MARK: - UICollectionView Delegate Flow Layout Methods
        
        // Set the header view for each section
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionReusableView
            header.lblHeader.text = arrofContent[indexPath.section].header
            return header
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Calculate the height dynamically if needed
            let content = arrofContent[indexPath.section]
            let articleText = content.article
            let estimatedHeight = estimateTextHeight(for: articleText)
            
            return CGSize(width: collectionView.frame.width, height: estimatedHeight + 20)  // Add padding
        }
        
        // Set the size for the header
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 50)  // Adjust as needed
        }
        
        // Helper method to estimate text height based on content
        func estimateTextHeight(for text: String) -> CGFloat {
            let maxWidth = self.view.frame.width - 40  // Subtract padding/margin
            let maxHeight: CGFloat = 1000  // Set a large max height to calculate properly
            
            let rect = (text as NSString).boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            return rect.height
        }
    }

struct Content {
    let header : String
    let article : String
}
