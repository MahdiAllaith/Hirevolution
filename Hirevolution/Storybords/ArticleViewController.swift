//
//  ArticleViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var viewLayoutHead: UIView!
    @IBOutlet weak var ArticleCollectionCard: UICollectionView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgArticlePage: UIImageView!
    var arrofContent = [Content]()
    var selectedCardTitle: String?
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Ensure tab bar is hidden when returning to SecondLibraryViewController
            self.tabBarController?.tabBar.isHidden = true
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = selectedCardTitle {
                    loadContent(for: title)
                }
                
                // Setup collection view delegate and data source
                ArticleCollectionCard.delegate = self
                ArticleCollectionCard.dataSource = self
        imgArticlePage.image = UIImage(named: "workCardImage")
        // Round the image corners
                imgArticlePage.layer.cornerRadius = 6 // Set a corner radius (adjustable)
                imgArticlePage.layer.masksToBounds = true
            }
            
            // Load the content based on the selected card title
            func loadContent(for title: String) {
                if title == " Interview Tips" {
                    arrofContent = [
                        Content(header: "1. Research the Company", article: "Take time to understand the company’s mission, values, and recent achievements. Familiarize yourself with their industry, competitors, and any recent news. This knowledge will show the interviewer that you’re genuinely interested and prepared."),
                        Content(header: "2. Practice Common Questions", article: "While you can't predict every question, preparing answers for common interview questions can help you feel confident. Think about your strengths, weaknesses, achievements, and how your skills align with the job role. Practicing with a friend or recording yourself can be helpful to refine your answers."),
                        Content(header: "3. Use the STAR Method", article: "For questions about past experiences, try the STAR method: Situation, Task, Action, Result. Describe a relevant situation, what you had to accomplish, the steps you took, and the outcome. This structured approach helps showcase your skills and problem-solving abilities effectively."),
                        Content(header: "4. Dress Appropriately", article: "First impressions matter, so choose attire that reflects the company's culture. If you're unsure, err on the side of formality. Looking polished and professional can boost your confidence and show respect for the interview process."),
                        Content(header: "5. Ask Thoughtful Questions", article: "Prepare questions to ask the interviewer that show your interest in the role and the company, like “What are the team’s main goals for the next year?” or “How do you define success in this position?” Thoughtful questions demonstrate that you're serious about finding a good fit."),
                        Content(header: "6. Follow Up with a Thank-You Note", article: "Send a brief thank-you email after the interview to express your appreciation. Mention something specific you discussed during the interview to make it personal. It’s a small gesture that can leave a positive impression.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 7, 2024"
                    
                } else if title == " Time Management Tips" {
                    arrofContent = [
                        Content(header: "1. Prioritize Tasks with the Eisenhower Matrix", article: "Use the Eisenhower Matrix to categorize tasks into four groups: urgent and important, important but not urgent, urgent but not important, and neither urgent nor important. Focus on high-priority tasks first to make sure you’re spending your time on what truly matters."),
                        Content(header: "2. Set Specific Goals and Deadlines", article: "Break down big projects into smaller, actionable steps with clear deadlines. Setting realistic goals and giving yourself target dates for each task can help you stay on track and motivated."),
                        Content(header: "3. Use the Pomodoro Technique", article: "Work in 25-minute intervals (or 'Pomodoros') followed by a 5-minute break. After four cycles, take a longer break of 15-30 minutes. This method helps maintain focus, prevents burnout, and boosts productivity."),
                        Content(header: "4. Limit Distractions", article: "Identify common distractions and minimize them as much as possible. Silence notifications, close unrelated tabs, and set boundaries with others during focused work periods. For tasks requiring deep concentration, consider using ‘do not disturb’ or noise-canceling tools."),
                        Content(header: "5. Batch Similar Tasks Together", article: "Group similar tasks together to increase efficiency. For example, check emails in batches rather than constantly switching between tasks. This reduces task-switching time and mental load."),
                        Content(header: "6. Reflect and Adjust Regularly", article: "Take time each week to review what worked well and where you can improve. Reflecting on your productivity helps you adjust your approach, refine your time management techniques, and set yourself up for success in the week ahead.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 7, 2024"
                } else if title == " CV Building Tips" {
                    arrofContent = [
                        Content(header: "1. Tailor Your CV to the Job", article: "Each job application is unique, so take time to adjust your CV to highlight the most relevant skills and experiences. Incorporate keywords from the job description and emphasize accomplishments that directly relate to the position you’re applying for."),
                        Content(header: "2. Use a Clean and Professional Format", article: "Choose a simple, professional layout that’s easy to read. Avoid flashy graphics or fonts, which can be distracting. Use headings, bullet points, and consistent font sizes to create a well-organized CV that makes it easy for recruiters to find key information."),
                        Content(header: "3. Highlight Achievements, Not Just Responsibilities", article: "Employers want to know what impact you made in your previous roles. Focus on achievements rather than just listing responsibilities. For example, instead of saying “Handled customer complaints,” you could say “Resolved 95% of customer complaints within 24 hours, improving satisfaction ratings.”"),
                        Content(header: "4. Include a Strong Profile Summary", article: "A brief profile summary at the top can provide a quick overview of your experience, skills, and career goals. Keep it concise, and focus on what makes you a valuable candidate. For example, “Experienced marketing professional with a track record of boosting online engagement by 30%.”"),
                        Content(header: "5. Quantify Where Possible", article: "Numbers make accomplishments more impactful. Use metrics like percentages, revenue increases, or customer satisfaction scores to add weight to your achievements. For example, “Increased team productivity by 20%” gives a clearer sense of your contributions than general statements."),
                        Content(header: "6. Proofread Thoroughly", article: "Even small errors can reflect poorly on your attention to detail. Carefully proofread your CV, and consider asking a friend or mentor to review it as well. Ensure consistent formatting, correct dates, and error-free content.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 7, 2024"
                    
                } else if title == " Public Speaking Tips" {
                    arrofContent = [
                        Content(header: "1. Know Your Audience", article: "Tailor your content to fit the interests and knowledge level of your audience. Knowing who you’re speaking to helps you craft relevant examples, anticipate questions, and create a connection with your listeners."),
                        Content(header: "2. Prepare Thoroughly", article: "Practice your speech multiple times. Familiarize yourself with key points rather than memorizing everything word-for-word. Practicing with a friend, recording yourself, or using a mirror can help you refine your delivery and work out any nervousness."),
                        Content(header: "3. Use Body Language Effectively", article: "Your body language conveys confidence and engages your audience. Maintain eye contact, use purposeful gestures, and avoid fidgeting. Standing tall and moving naturally makes you appear confident and more approachable."),
                        Content(header: "4. Pace Yourself", article: "Speaking too quickly can make you seem nervous and can be difficult for the audience to follow. Practice slowing down and pausing occasionally to emphasize key points and allow listeners to absorb information. Breathing deeply and regularly also helps maintain a steady pace."),
                        Content(header: "5. Engage with Your Audience", article: "Interact by asking questions, inviting opinions, or encouraging feedback. Making your presentation interactive keeps the audience’s attention and helps them feel more involved in your message."),
                        Content(header: "6. Use Visual Aids Wisely", article: "Visuals can enhance your presentation, but they should complement your message, not overwhelm it. Keep slides simple and uncluttered, and use images or graphics to emphasize key points. Make sure you’re not reading directly from slides, as this can disengage your audience.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 7, 2024"
                } else if title == " The Rise of IOT" {
                    arrofContent = [
                        Content(header: "What is IoT?", article: "IoT refers to physical devices connected to the internet that collect and exchange data. These devices range from simple sensors in thermostats to complex machinery in factories."),
                        Content(header: "Why is IoT Growing So Quickly?", article: "Advancements in technology and the demand for automation are fueling the growth of IoT. Big Data and AI also play a role in analyzing IoT data to improve performance."),
                        Content(header: "Where is IoT Used?", article: "IoT is used in smart homes (smart lights, thermostats, door locks), healthcare (wearable devices), agriculture (sensors for crops), transportation (connected cars), and Industry 4.0 (factories using IoT for predictive maintenance)."),
                        Content(header: "Challenges Ahead", article: "Despite the growth, IoT faces challenges such as security concerns, privacy issues, and interoperability between different devices and platforms."),
                        Content(header: "Looking Ahead", article: "IoT will continue to reshape industries and daily life, making cities smarter and personal conveniences more automated.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 6, 2024"
                    
                } else if title == " Introduction to Cloud Computing" {
                    arrofContent = [
                        Content(header: "What is Cloud Computing?", article: "Cloud computing allows users to access and store data and applications over the internet instead of using a local server or computer. It provides scalable and on-demand computing resources."),
                        Content(header: "Types of Cloud Computing", article: "There are three main types of cloud computing: IaaS (Infrastructure as a Service), PaaS (Platform as a Service), and SaaS (Software as a Service). Each type offers different levels of control, flexibility, and management."),
                        Content(header: "Benefits of Cloud Computing", article: "Cloud computing offers numerous benefits, including cost savings, scalability, flexibility, and accessibility. Businesses can easily scale their operations without having to invest in expensive hardware."),
                        Content(header: "Popular Cloud Providers", article: "Major cloud providers like Amazon Web Services (AWS), Microsoft Azure, and Google Cloud dominate the market. These platforms provide a range of services from storage to machine learning and analytics."),
                        Content(header: "The Future of Cloud Computing", article: "Cloud computing is evolving with advancements like edge computing, serverless computing, and AI integration. As businesses continue to adopt cloud technology, the demand for cloud-based solutions will only grow.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Dec 10, 2024"

                } else if title == " What is CyberSecurity?" {
                    arrofContent = [
                        Content(header: "Introduction to CyberSecurity", article: "Cybersecurity involves protecting systems, networks, and programs from digital attacks that aim to steal data or damage systems. It is critical in safeguarding personal, corporate, and government information."),
                        Content(header: "Common Types of Cybersecurity Threats", article: "Cyber threats include malware (viruses, worms), phishing attacks, ransomware, denial-of-service (DoS) attacks, and data breaches. Understanding these threats is the first step to protecting systems."),
                        Content(header: "Cybersecurity Best Practices", article: "Some best practices include using strong passwords, encrypting sensitive data, installing antivirus software, and educating employees on recognizing phishing attempts."),
                        Content(header: "The Role of Encryption in CyberSecurity", article: "Encryption is a key tool in protecting sensitive data. By converting data into a code, encryption ensures that even if hackers access it, they will not be able to read or use it."),
                        Content(header: "The Future of CyberSecurity", article: "As the number of connected devices increases, cybersecurity challenges will grow. AI and machine learning will play a significant role in detecting and responding to cyber threats in real time.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Oct 12, 2024"

                } else if title == " How to Start a Career in Software Development" {
                    arrofContent = [
                        Content(header: "Understanding Software Development", article: "Software development involves creating computer programs and applications. It requires knowledge of programming languages like Python, Java, or C++, and a deep understanding of problem-solving and algorithms."),
                        Content(header: "Learning Programming Languages", article: "Start by learning popular programming languages such as Python, JavaScript, or Java. Choose a language based on the type of software you want to develop (e.g., web apps, mobile apps, etc.)."),
                        Content(header: "Building Your First Project", article: "A great way to learn is by building your own project. Start with simple projects like a personal website or a to-do list app. This helps you apply what you've learned and gain experience."),
                        Content(header: "Getting Experience and Networking", article: "Participate in open-source projects, attend coding boot camps, and network with professionals in the field. Experience and connections can significantly boost your career opportunities."),
                        Content(header: "Job Opportunities and Career Paths", article: "Software developers have various career paths, from web development to mobile app development and machine learning. With experience, you can specialize in areas like AI or cybersecurity.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Jun 20, 2024"

                } else if title == " How to Choose the Right Engineering Field" {
                    arrofContent = [
                        Content(header: "Identify Your Interests", article: "Think about the subjects or activities you enjoy most. Are you fascinated by machines and design? Mechanical engineering might be a good fit. Interested in building infrastructure? Civil engineering could be the right choice."),
                        Content(header: "Assess Your Strengths", article: "Consider your strengths in subjects like math, science, or problem-solving. Some engineering fields require a stronger foundation in certain areas, such as electrical engineering for physics knowledge."),
                        Content(header: "Research the Job Market", article: "Look into the demand for engineers in different fields. Software engineering, data engineering, and environmental engineering are currently in high demand. Researching the job market will help you make an informed decision."),
                        Content(header: "Consider Your Long-Term Goals", article: "Think about what kind of impact you want to have. Do you want to contribute to sustainable energy (environmental engineering) or improve healthcare (biomedical engineering)?"),
                        Content(header: "Gain Hands-On Experience", article: "Consider internships or shadowing professionals to get a feel for what different engineering fields are like. This will help you make a more informed decision.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Aug 14, 2024"

                } else if title == " What is Civil Engineering?" {
                    arrofContent = [
                        Content(header: "The Role of Civil Engineering", article: "Civil engineering involves designing, building, and maintaining infrastructure like roads, bridges, buildings, and water systems. It’s one of the oldest and most essential engineering disciplines."),
                        Content(header: "Key Areas of Civil Engineering", article: "Civil engineering includes several sub-disciplines such as structural, environmental, transportation, and geotechnical engineering. Each field focuses on specific aspects of construction and design."),
                        Content(header: "Skills Needed in Civil Engineering", article: "Civil engineers need strong math, physics, and problem-solving skills. They also need to have knowledge in project management, construction techniques, and materials science."),
                        Content(header: "The Future of Civil Engineering", article: "As the world faces challenges like climate change and urbanization, civil engineers will be crucial in designing sustainable, resilient infrastructure. Innovations in materials and construction methods will play a big role."),
                        Content(header: "Career Path in Civil Engineering", article: "Civil engineers can work in various industries such as construction, government, consulting, and research. Many civil engineers eventually become project managers or start their own engineering firms.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Apr 22, 2024"

                }else if title == " The Importance of Ethics in Engineering" {
                    arrofContent = [
                        Content(header: "Why Ethics Matter in Engineering", article: "Ethics in engineering ensures that the work engineers do does not harm society. It covers the safety, reliability, and welfare of the public."),
                        Content(header: "Key Ethical Issues in Engineering", article: "Issues like safety regulations, environmental impact, and equitable access to technology are crucial. Engineers must consider these factors while designing products or systems."),
                        Content(header: "Case Studies in Engineering Ethics", article: "Examples like the Challenger Disaster or the Volkswagen emissions scandal demonstrate the severe consequences of unethical decisions in engineering."),
                        Content(header: "Ethical Guidelines", article: "Engineering ethics guidelines help professionals navigate moral dilemmas. These guidelines are enforced by organizations like IEEE, NSPE, and other professional bodies."),
                        Content(header: "The Future of Ethics in Engineering", article: "As technology advances, new ethical issues like AI, machine learning, and autonomous vehicles will require engineers to consider new ethical frameworks.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Nov 2, 2024"
                    
                } else if title == " How to Land Your First Engineering Job" {
                    arrofContent = [
                        Content(header: "Start with a Strong Resume", article: "Highlight your engineering skills, projects, and any internships or volunteer work. Tailor your resume to each job application."),
                        Content(header: "Build a Portfolio", article: "Having a portfolio with your best work (like projects, designs, or software) helps demonstrate your skills to potential employers."),
                        Content(header: "Network and Make Connections", article: "Attending engineering conferences, joining professional organizations, and networking with industry professionals can open doors to opportunities."),
                        Content(header: "Prepare for Interviews", article: "Research the company, practice your answers to common interview questions, and be prepared to discuss how your skills and experience align with the role."),
                        Content(header: "Stay Open to Entry-Level Opportunities", article: "Don't hesitate to apply for entry-level roles or internships to gain experience. These roles often lead to better opportunities down the line.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Sep 21, 2024"
                    
                } else if title == " How to Start Your Own Business" {
                    arrofContent = [
                        Content(header: "Find Your Business Idea", article: "Think about a product or service that solves a problem. Validate your idea by doing market research and talking to potential customers."),
                        Content(header: "Create a Business Plan", article: "A solid business plan outlines your goals, target market, competition, financial projections, and operational strategy."),
                        Content(header: "Register Your Business", article: "Decide on your business structure (LLC, Sole Proprietorship, Corporation) and register with the appropriate authorities."),
                        Content(header: "Secure Funding", article: "Consider funding options like personal savings, loans, crowdfunding, or investors. Having clear financial projections will help secure investors or loans."),
                        Content(header: "Launch and Market Your Business", article: "Develop a marketing strategy using social media, SEO, content marketing, and networking to attract your first customers.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Oct 4, 2024"
                    
                
                } else if title == " The Impact of AI on Business Operations" {
                    arrofContent = [
                        Content(header: "AI in Business: An Overview", article: "Artificial Intelligence (AI) is transforming business operations by automating processes, improving decision-making, and enhancing customer experiences. AI applications range from chatbots to predictive analytics."),
                        Content(header: "Automation with AI", article: "AI can automate repetitive tasks like data entry, customer support, and inventory management, increasing efficiency and reducing operational costs. AI-driven tools improve accuracy and speed."),
                        Content(header: "AI for Decision Making", article: "AI systems analyze vast amounts of data to provide insights, helping businesses make more informed decisions. This includes forecasting trends, market analysis, and personalized marketing strategies."),
                        Content(header: "Improving Customer Experience with AI", article: "AI is used in chatbots, recommendation engines, and customer service automation to provide faster and more personalized interactions. These AI-driven tools enhance user satisfaction and engagement."),
                        Content(header: "AI-Powered Innovation", article: "AI fosters innovation by providing new ways to solve problems. In industries like healthcare, manufacturing, and finance, AI is driving innovations that improve service delivery, product development, and operational efficiency."),
                        Content(header: "Challenges and Future of AI in Business", article: "While AI brings many benefits, challenges such as data privacy concerns, integration issues, and a lack of skilled professionals persist. The future of AI in business is promising, with AI becoming an integral part of business strategies.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Jan 15, 2024"
                    
                } else if title == " The Basics of Digital Marketing" {
                    arrofContent = [
                        Content(header: "What is Digital Marketing?", article: "Digital marketing involves using online platforms and technologies to promote and sell products or services. It includes strategies like SEO, social media marketing, content marketing, and paid advertising."),
                        Content(header: "Search Engine Optimization (SEO)", article: "SEO is the process of improving a website's visibility in search engine results. By optimizing content, keywords, and website structure, businesses can increase organic traffic and reach a larger audience."),
                        Content(header: "Content Marketing", article: "Content marketing focuses on creating valuable, relevant content to attract and engage an audience. This can include blogs, videos, infographics, and podcasts aimed at building brand awareness and customer loyalty."),
                        Content(header: "Social Media Marketing", article: "Social media marketing leverages platforms like Facebook, Instagram, and Twitter to connect with potential customers. It's an effective way to build brand presence, engage with users, and drive traffic to websites."),
                        Content(header: "Paid Advertising", article: "Paid digital advertising includes strategies like Google Ads, display ads, and social media ads. These tactics can drive immediate traffic and help businesses target specific demographics based on behavior and interests."),
                        Content(header: "The Future of Digital Marketing", article: "As technology evolves, digital marketing will continue to integrate AI, big data, and automation tools to provide personalized experiences and increase campaign efficiency. The future will see even more interactive and immersive experiences for users.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Feb 20, 2024"
                    
                } else if title == " The Future of E-commerce" {
                    arrofContent = [
                        Content(header: "E-commerce: Current Trends", article: "E-commerce is evolving rapidly with trends like mobile shopping, voice commerce, and AI-powered recommendations. More consumers are shopping online, and businesses are adopting e-commerce as a primary sales channel."),
                        Content(header: "Personalization in E-commerce", article: "Personalization involves tailoring the shopping experience based on customer preferences, browsing history, and purchase behavior. E-commerce platforms use AI and machine learning to offer personalized product recommendations."),
                        Content(header: "Omnichannel Shopping Experience", article: "Omnichannel retail refers to providing a seamless shopping experience across multiple channels, including websites, mobile apps, brick-and-mortar stores, and social media. The future of e-commerce involves integrating these channels to enhance customer convenience."),
                        Content(header: "Payment Solutions in E-commerce", article: "Payment solutions like digital wallets, cryptocurrency, and Buy Now, Pay Later (BNPL) services are reshaping the e-commerce landscape. These methods provide flexibility, security, and convenience for online shoppers."),
                        Content(header: "AI and Automation in E-commerce", article: "AI is being used in e-commerce for chatbots, personalized recommendations, and inventory management. Automation streamlines operations, reduces costs, and improves customer service by enabling 24/7 support."),
                        Content(header: "The Future of E-commerce", article: "As technology advances, e-commerce will become even more sophisticated, integrating augmented reality, AI, and faster delivery services. Businesses will focus more on providing a personalized and convenient shopping experience for customers.")
                    ]
                    lblHead.text = title.trimmingCharacters(in: .whitespaces)
                    lblDate.text = "Mar 10, 2024"
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
