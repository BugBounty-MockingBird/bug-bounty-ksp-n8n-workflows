# Bug Bounty KSP n8n Workflows

Complete automation workflows for a bug bounty and cybersecurity platform, built with [n8n](https://n8n.io).

## 🎯 Overview

This repository contains 5 production-ready n8n workflows designed for cybersecurity platforms, bug bounty programs, and security research communities:

1. **Initial Blog Crawl** - One-time crawl of user blogs to extract and index posts
2. **Weekly Cybersecurity Aggregation** - Automated aggregation of security news from multiple sources
3. **Comment Notification Pipeline** - Real-time comment processing with spam detection and notifications
4. **Fabric-Powered Learning Path Generation** - AI-generated personalized cybersecurity learning paths
5. **Discord Community Integration** - Bot commands and automated security digest notifications

## ✨ Features

### Workflow 1: Initial Blog Crawl
- 🔍 Automated HTML parsing and post extraction
- 📊 Duplicate detection
- 💾 PostgreSQL storage
- 🔄 Incremental update support
- ⚡ Webhook-triggered execution

### Workflow 2: Weekly Cybersecurity Aggregation
- 📰 Multi-source aggregation (CVE, NVD, security blogs)
- 🏷️ Automatic categorization (vulnerability, exploit, patch, etc.)
- 🔴 Severity classification (critical, high, medium, info)
- 📈 Weekly summary reports
- 🔔 Slack notifications (optional)
- ⏰ Scheduled execution (every Monday 9 AM)

### Workflow 3: Comment Notification Pipeline
- 🛡️ ML-based spam detection
- ✉️ Beautiful HTML email notifications
- 💬 Slack integration (optional)
- 👥 User preference handling
- 🚫 Automatic spam blocking
- ⚠️ Manual review flagging

### Workflow 4: Fabric-Powered Learning Path Generation
- 🤖 OpenAI GPT-4 powered generation
- 🎓 Personalized milestone creation
- 📚 Curated resource recommendations
- 📊 Progress tracking
- 💌 Beautifully designed email notifications
- 🔄 Context-aware based on user history

### Workflow 5: Discord Community Integration
- 🤖 Full-featured Discord bot
- 🔍 Vulnerability search commands
- 📊 User statistics and leaderboards
- 🔔 Automated security digests (every 6 hours)
- 📱 Real-time command responses
- 🎨 Rich Discord embeds

## 📋 Prerequisites

### Required
- [n8n](https://n8n.io) (self-hosted or cloud)
- PostgreSQL database (v12+)
- Node.js 18+ (if self-hosting n8n)

### Optional (for specific workflows)
- SMTP server or email service (for notifications)
- Discord bot token and webhook (for Discord integration)
- OpenAI API key (for AI learning paths)
- Slack workspace and webhooks (for Slack notifications)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/BugBounty-MockingBird/bug-bounty-ksp-n8n-workflows.git
cd bug-bounty-ksp-n8n-workflows
```

### 2. Setup Database

Run the database schema setup:

```bash
# Connect to your PostgreSQL database
psql -U your_username -d your_database -f docs/database-schema.md

# Or using environment variables
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME < docs/database-schema.md
```

See `docs/database-schema.md` for detailed schema information.

### 3. Configure Environment Variables

Copy the environment template and configure:

```bash
cp docs/environment-variables.md .env
# Edit .env with your actual credentials
```

See `docs/environment-variables.md` for all available options.

### 4. Import Workflows into n8n

#### Method 1: Using n8n UI (Recommended)

1. Open your n8n instance
2. Click on **Workflows** in the left sidebar
3. Click **Import from File** or **Import from URL**
4. Select or paste the workflow JSON file
5. Click **Import**
6. Repeat for all 5 workflows

#### Method 2: Using n8n CLI

```bash
# Install n8n CLI globally
npm install -g n8n

# Import workflows
n8n import:workflow --input=workflows/1-initial-blog-crawl.json
n8n import:workflow --input=workflows/2-weekly-cybersecurity-aggregation.json
n8n import:workflow --input=workflows/3-comment-notification-pipeline.json
n8n import:workflow --input=workflows/4-fabric-learning-path-generation.json
n8n import:workflow --input=workflows/5-discord-community-integration.json
```

#### Method 3: Using n8n API

```bash
# Set your n8n API endpoint and key
N8N_API_URL="http://localhost:5678"
N8N_API_KEY="your_api_key"

# Import each workflow
for workflow in workflows/*.json; do
  curl -X POST "$N8N_API_URL/api/v1/workflows" \
    -H "Content-Type: application/json" \
    -H "X-N8N-API-KEY: $N8N_API_KEY" \
    -d @"$workflow"
done
```

### 5. Configure Credentials

After importing, configure credentials in n8n:

1. **PostgreSQL** (`postgres-main`)
   - Go to Credentials → New Credential → Postgres
   - Enter: Host, Port, Database, User, Password
   - Test connection

2. **SMTP** (`smtp-main`) - For email notifications
   - Go to Credentials → New Credential → SMTP
   - Enter your SMTP server details
   - Test by sending a test email

3. **OpenAI API** (`openai-main`) - For learning paths
   - Go to Credentials → New Credential → OpenAI API
   - Enter your OpenAI API key

4. **Discord Bot** (`discord-bot-auth`) - For Discord integration
   - Go to Credentials → New Credential → Header Auth
   - Name: `Authorization`
   - Value: `Bot YOUR_DISCORD_BOT_TOKEN`

5. **Slack** (`slack-main`) - Optional
   - Go to Credentials → New Credential → Slack API
   - Choose OAuth2 or Webhook method

### 6. Activate Workflows

For each workflow:
1. Open the workflow in n8n
2. Click the toggle switch to **Active**
3. Verify the schedule or webhook is configured

## 📖 Documentation

- **[Workflow Documentation](docs/workflow-documentation.md)** - Detailed guide for each workflow
- **[Database Schema](docs/database-schema.md)** - Database tables and setup
- **[Environment Variables](docs/environment-variables.md)** - Configuration options
- **[Architecture](#architecture)** - System design overview

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      n8n Workflows                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Workflow 1 │  │   Workflow 2 │  │   Workflow 3 │     │
│  │ Blog Crawl   │  │ Weekly Agg.  │  │  Comments    │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │              │
│  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐     │
│  │   Workflow 4 │  │   Workflow 5 │  │  PostgreSQL  │     │
│  │  AI Learning │  │   Discord    │  │   Database   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
         │                     │                    │
         ▼                     ▼                    ▼
  ┌──────────┐         ┌──────────┐         ┌──────────┐
  │  OpenAI  │         │ Discord  │         │  Email   │
  │   API    │         │  Server  │         │  (SMTP)  │
  └──────────┘         └──────────┘         └──────────┘
```

### Data Flow

1. **Blog Crawl**: User triggers → Fetch HTML → Parse → Store in DB
2. **Aggregation**: Scheduled → Fetch feeds → Categorize → Store → Notify
3. **Comments**: Webhook → Spam check → Store → Notify author
4. **Learning Path**: User request → Fetch context → AI generate → Store → Email
5. **Discord**: Schedule/Command → Process → Database query → Send embed

## 🧪 Testing

### Test Individual Workflows

#### Test Blog Crawl
```bash
curl -X POST http://localhost:5678/webhook/start-blog-crawl \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_123",
    "blogUrl": "https://example.com/blog",
    "userName": "Test User"
  }'
```

#### Test Comment Pipeline
```bash
curl -X POST http://localhost:5678/webhook/comment-webhook \
  -H "Content-Type: application/json" \
  -d '{
    "commentId": "comment_123",
    "postId": "post_456",
    "postTitle": "Test Post",
    "postUrl": "https://example.com/posts/456",
    "authorName": "John Doe",
    "authorEmail": "john@example.com",
    "commentText": "Great article, thanks for sharing!"
  }'
```

#### Test Learning Path Generation
```bash
curl -X POST http://localhost:5678/webhook/generate-learning-path \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "userName": "Jane Smith",
    "userLevel": "intermediate",
    "targetSkills": ["web-security", "bug-bounty"],
    "learningGoals": "Master bug bounty hunting"
  }'
```

#### Test Discord Bot
Send a message in your Discord channel:
```
!help
!search sql injection
!stats
```

## 🔧 Customization

### Adding New Security Sources

Edit Workflow 2 (`2-weekly-cybersecurity-aggregation.json`):

```javascript
// In the "Initialize Aggregation" node
sources: [
  // ... existing sources
  { 
    name: 'Your Custom Source', 
    url: 'https://your-source.com/rss-feed' 
  }
]
```

### Adjusting Spam Detection

Edit Workflow 3 (`3-comment-notification-pipeline.json`):

```javascript
// In the "Spam Detection" node
// Modify spam thresholds
if (spamScore >= 50) {  // Change from 50 to your preferred threshold
  status = 'spam';
}
```

### Changing AI Model

Edit Workflow 4 (`4-fabric-learning-path-generation.json`):

```javascript
// In the "OpenAI Generate Learning Path" node
model: "gpt-4-turbo-preview"  // Change to gpt-3.5-turbo or other models
```

### Discord Bot Commands

Edit Workflow 5 (`5-discord-community-integration.json`):

Add new commands in the `Execute Command` node:
```javascript
case 'yournewcommand':
  response.embeds.push({
    title: 'Your Command',
    description: 'Command response'
  });
  break;
```

## 📊 Monitoring

### View Workflow Executions

1. Go to **Executions** in n8n UI
2. Filter by workflow, status, date
3. Click on any execution to see detailed logs

### Database Queries

```sql
-- Check recent blog crawls
SELECT * FROM blog_crawls ORDER BY created_at DESC LIMIT 10;

-- View security aggregation stats
SELECT category, severity, COUNT(*) as count
FROM security_aggregations 
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY category, severity
ORDER BY count DESC;

-- Comment spam statistics
SELECT 
  status,
  COUNT(*) as count,
  AVG(spam_score) as avg_spam_score
FROM comments 
GROUP BY status;

-- Learning path completion rate
SELECT 
  status,
  COUNT(*) as count,
  AVG(progress) as avg_progress
FROM learning_milestones 
GROUP BY status;
```

## 🛡️ Security Considerations

1. **Never commit `.env` files** - Use environment variables
2. **Rotate credentials regularly** - Change API keys and tokens periodically
3. **Use HTTPS in production** - Secure webhook endpoints
4. **Validate webhook signatures** - Implement webhook secret validation
5. **Rate limit external APIs** - Prevent abuse and API quota exhaustion
6. **Sanitize user inputs** - Prevent SQL injection and XSS
7. **Use read-only database users** - Where possible, limit permissions

## 🔄 Updates & Maintenance

### Weekly Tasks
- ✅ Review spam detection accuracy
- ✅ Check aggregation source availability
- ✅ Monitor database size

### Monthly Tasks
- ✅ Update AI prompts based on feedback
- ✅ Review security sources
- ✅ Analyze learning path effectiveness
- ✅ Discord bot feature enhancements

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [n8n](https://n8n.io) - Workflow automation platform
- [OpenAI](https://openai.com) - AI language models
- [Discord](https://discord.com) - Community platform
- Security data sources: MITRE CVE, NVD, GitHub Advisories

## 📧 Support

- **Documentation**: See `docs/` folder
- **Issues**: [GitHub Issues](https://github.com/BugBounty-MockingBird/bug-bounty-ksp-n8n-workflows/issues)
- **Discussions**: [GitHub Discussions](https://github.com/BugBounty-MockingBird/bug-bounty-ksp-n8n-workflows/discussions)

## 🗺️ Roadmap

- [ ] Telegram bot integration
- [ ] Advanced ML-based vulnerability scoring
- [ ] Real-time threat intelligence feeds
- [ ] Multi-language support
- [ ] Mobile app push notifications
- [ ] GraphQL API endpoints
- [ ] Kubernetes deployment templates

---

**Built with ❤️ for the cybersecurity community**
