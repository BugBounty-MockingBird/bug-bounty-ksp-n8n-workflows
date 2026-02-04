# Workflow Documentation

## Overview

This repository contains 5 n8n workflows designed for a bug bounty/cybersecurity platform:

1. **Initial Blog Crawl** - One-time crawl of user blogs to extract posts
2. **Weekly Cybersecurity Aggregation** - Automated aggregation of security news
3. **Comment Notification Pipeline** - Real-time comment processing with spam detection
4. **Fabric-Powered Learning Path Generation** - AI-generated personalized learning paths
5. **Discord Community Integration** - Bot commands and automated notifications

---

## Workflow 1: Initial Blog Crawl

**File:** `workflows/1-initial-blog-crawl.json`

### Purpose
Performs a one-time crawl of a user's blog to extract and index all posts. This establishes the baseline for tracking new content.

### Trigger
- **Type:** Webhook (HTTP POST)
- **Endpoint:** `/webhook/start-blog-crawl`
- **Method:** POST

### Input Payload
```json
{
  "userId": "user123",
  "blogUrl": "https://example.com/blog",
  "userName": "John Doe"
}
```

### Process Flow
1. **Validate Input** - Checks required parameters
2. **Fetch Blog Page** - Downloads blog HTML
3. **Parse Blog Posts** - Extracts posts using regex patterns
4. **Check Posts Found** - Validates extraction success
5. **Store Results** - Saves to database
6. **Split & Store Posts** - Individual post records
7. **Respond** - Returns success/failure status

### Output
- Crawl metadata stored in `blog_crawls` table
- Individual posts stored in `blog_posts` table
- HTTP response with crawl statistics

### Configuration Required
- PostgreSQL credential: `postgres-main`
- Database tables: `blog_crawls`, `blog_posts`

### Use Cases
- Initial user onboarding
- Blog migration/import
- Baseline establishment for change detection

### Error Handling
- Invalid URL → 500 response with error message
- No posts found → 200 response with warning
- Database errors → Logged and returned to caller

---

## Workflow 2: Weekly Cybersecurity Aggregation

**File:** `workflows/2-weekly-cybersecurity-aggregation.json`

### Purpose
Automatically aggregates cybersecurity news, vulnerabilities, and advisories from multiple sources on a weekly basis.

### Trigger
- **Type:** Schedule (Cron)
- **Schedule:** Every Monday at 9:00 AM
- **Frequency:** Weekly

### Data Sources
- CVE Database (MITRE)
- The Hacker News RSS Feed
- Bugcrowd Programs
- GitHub Security Advisories
- NIST NVD

### Process Flow
1. **Initialize Aggregation** - Set up sources and date range
2. **Split Sources** - Process each source independently
3. **Fetch Source Data** - HTTP requests to each source
4. **Parse Feed Data** - Handle RSS, JSON, XML, HTML formats
5. **Categorize Items** - Apply ML-based categorization
6. **Store Data** - Save to `security_aggregations` table
7. **Generate Summary** - Create weekly statistics
8. **Notify** - Send Slack notification (optional)

### Categories
- `vulnerability` - Security vulnerabilities
- `bug-bounty` - Bug bounty programs
- `exploit` - Exploit releases
- `patch` - Security patches
- `malware` - Malware reports

### Severity Levels
- `critical` - Immediate action required
- `high` - High priority
- `medium` - Medium priority
- `info` - Informational

### Output
- Security items in `security_aggregations` table
- Weekly summary in `weekly_summaries` table
- Slack notification to security channel

### Configuration Required
- PostgreSQL credential: `postgres-main`
- Slack credential: `slack-main` (optional)
- Environment variable: `SLACK_CHANNEL_SECURITY`

### Customization
To add new sources, modify the `Initialize Aggregation` node:
```javascript
sources: [
  { name: 'Your Source', url: 'https://your-source.com/feed' }
]
```

---

## Workflow 3: Comment Notification Pipeline

**File:** `workflows/3-comment-notification-pipeline.json`

### Purpose
Processes incoming comments with spam detection, stores approved comments, and sends notifications to post authors.

### Trigger
- **Type:** Webhook (HTTP POST)
- **Endpoint:** `/webhook/comment-webhook`
- **Method:** POST

### Input Payload
```json
{
  "commentId": "comment_123",
  "postId": "post_456",
  "postTitle": "My Blog Post",
  "postUrl": "https://example.com/posts/456",
  "authorId": "author_789",
  "authorName": "Jane Smith",
  "authorEmail": "jane@example.com",
  "commentText": "Great article! Thanks for sharing."
}
```

### Process Flow
1. **Extract Comment Data** - Parse webhook payload
2. **Spam Detection** - ML-based spam scoring
3. **Filter Spam** - Block high-score comments
4. **Store Comment** - Save to database
5. **Get Post Author** - Fetch notification preferences
6. **Prepare Notification** - Format email content
7. **Send Notifications** - Email + Slack
8. **Respond** - Confirmation to caller

### Spam Detection Rules
- Keyword matching (viagra, casino, etc.)
- URL density analysis
- Repeated character detection
- Suspicious email patterns
- Comment length analysis

### Spam Scoring
- **0-24**: Approved automatically
- **25-49**: Requires manual review
- **50+**: Blocked as spam

### Output
- Approved comments in `comments` table
- Blocked comments in `blocked_comments` table
- Email notification to post author
- Slack notification (optional)
- HTTP response with status

### Configuration Required
- PostgreSQL credential: `postgres-main`
- SMTP credential: `smtp-main`
- Slack webhook URL in environment

### Email Template
Rich HTML email with:
- Comment content
- Author information
- Direct link to comment
- Moderation link (if required)
- Unsubscribe option

---

## Workflow 4: Fabric-Powered Learning Path Generation

**File:** `workflows/4-fabric-learning-path-generation.json`

### Purpose
Generates personalized cybersecurity learning paths using AI (OpenAI GPT-4 or Fabric) based on user profile and interests.

### Trigger
- **Type:** Webhook (HTTP POST)
- **Endpoint:** `/webhook/generate-learning-path`
- **Method:** POST

### Input Payload
```json
{
  "userId": "user123",
  "userName": "John Doe",
  "userLevel": "intermediate",
  "targetSkills": ["web-security", "bug-bounty"],
  "currentSkills": ["basic-networking", "python"],
  "learningGoals": "Master bug bounty hunting",
  "timeCommitment": "10 hours/week",
  "preferredFormat": "hands-on"
}
```

### Process Flow
1. **Extract User Profile** - Parse request data
2. **Fetch User Context** - Get user's blog posts and history
3. **Aggregate Context** - Analyze interests and topics
4. **Prepare AI Prompt** - Build comprehensive prompt
5. **Generate with AI** - OpenAI/Fabric API call
6. **Parse Response** - Extract structured learning path
7. **Store Learning Path** - Save to database
8. **Create Milestones** - Individual tracking records
9. **Send Email** - Beautiful notification email
10. **Respond** - Return path ID and summary

### AI Model
- **Default:** GPT-4 Turbo Preview
- **Alternative:** Local Fabric instance
- **Temperature:** 0.7 (balanced creativity)
- **Max Tokens:** 3000

### Learning Path Structure
```json
{
  "title": "Path Title",
  "description": "Overview",
  "totalDuration": "12 weeks",
  "milestones": [
    {
      "id": 1,
      "title": "Milestone Title",
      "description": "What you'll learn",
      "duration": "2 weeks",
      "skills": ["skill1", "skill2"],
      "resources": [
        {
          "title": "Resource Title",
          "url": "https://...",
          "type": "video",
          "free": true
        }
      ],
      "projects": ["Project description"],
      "assessment": "Completion criteria"
    }
  ]
}
```

### Output
- Learning path in `learning_paths` table
- Milestones in `learning_milestones` table
- Beautiful HTML email notification
- JSON response with path details

### Configuration Required
- PostgreSQL credential: `postgres-main`
- OpenAI credential: `openai-main`
- SMTP credential: `smtp-main`
- Environment: `APP_URL`, `OPENAI_API_KEY`

### Customization
Modify the system prompt in the **OpenAI Generate Learning Path** node to adjust:
- Teaching style
- Resource preferences
- Assessment criteria
- Learning pace

---

## Workflow 5: Discord Community Integration

**File:** `workflows/5-discord-community-integration.json`

### Purpose
Provides Discord bot commands and automated security digest notifications to the community server.

### Triggers
1. **Webhook** - For Discord bot commands
2. **Schedule** - Every 6 hours for security digest

### Bot Commands

#### !help
Shows all available commands
```
!help
```

#### !search
Search for vulnerabilities
```
!search sql injection
```

#### !subscribe
Subscribe to category notifications
```
!subscribe vulnerability
```

#### !unsubscribe
Unsubscribe from notifications
```
!unsubscribe exploit
```

#### !stats
Show your bug bounty statistics
```
!stats
```

#### !leaderboard
Display community leaderboard
```
!leaderboard
```

#### !report
Get information about submitting reports
```
!report
```

#### !learning
Check learning path progress
```
!learning
```

### Process Flow

#### Command Processing
1. **Parse Command** - Extract command and arguments
2. **Validate** - Check if command exists
3. **Execute** - Run command logic
4. **Search Database** - If search command
5. **Format Response** - Create Discord embed
6. **Send Response** - Post to Discord channel

#### Scheduled Digest
1. **Fetch Content** - Get critical/high items from last 6h
2. **Format Digest** - Create rich embed
3. **Check Should Send** - Skip if no items
4. **Send to Discord** - Post digest to security channel

### Discord Embed Format
```javascript
{
  "title": "Embed Title",
  "description": "Description text",
  "color": 3447003, // Blue
  "fields": [
    {
      "name": "Field Name",
      "value": "Field Value",
      "inline": false
    }
  ],
  "footer": {
    "text": "Footer text"
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### Output
- Bot responses in Discord channels
- Security digests every 6 hours
- Command execution logging

### Configuration Required
- Discord bot token in environment
- Discord webhook URLs
- PostgreSQL credential: `postgres-main`
- HTTP Header Auth credential: `discord-bot-auth`

### Setting Up Discord Bot

1. **Create Application**
   - Go to https://discord.com/developers/applications
   - Click "New Application"
   - Give it a name

2. **Create Bot**
   - Go to "Bot" section
   - Click "Add Bot"
   - Copy bot token

3. **Set Permissions**
   - Go to "OAuth2" → "URL Generator"
   - Select scopes: `bot`, `applications.commands`
   - Select permissions: `Send Messages`, `Read Messages`, `Embed Links`
   - Copy generated URL

4. **Invite Bot**
   - Use generated URL to add bot to your server

5. **Configure Environment**
   ```bash
   DISCORD_BOT_TOKEN=your_bot_token_here
   DISCORD_WEBHOOK_SECURITY=your_webhook_url_here
   ```

### Webhook Setup
1. Server Settings → Integrations → Webhooks
2. Create webhook for security channel
3. Copy webhook URL
4. Add to environment variables

---

## Common Configuration

### Database Setup
All workflows require PostgreSQL. See `docs/database-schema.md` for setup.

### Credentials in n8n

1. **PostgreSQL** (`postgres-main`)
   - Host, Port, Database, User, Password

2. **SMTP** (`smtp-main`)
   - Host, Port, User, Password, Secure

3. **Slack** (`slack-main`) [Optional]
   - OAuth Token or Webhook URL

4. **OpenAI** (`openai-main`)
   - API Key

5. **Discord Bot** (`discord-bot-auth`)
   - Header Auth with `Authorization: Bot YOUR_TOKEN`

### Environment Variables
See `docs/environment-variables.md` for complete list.

---

## Testing Workflows

### Test Workflow 1 (Blog Crawl)
```bash
curl -X POST http://localhost:5678/webhook/start-blog-crawl \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "blogUrl": "https://example.com/blog",
    "userName": "Test User"
  }'
```

### Test Workflow 3 (Comment)
```bash
curl -X POST http://localhost:5678/webhook/comment-webhook \
  -H "Content-Type: application/json" \
  -d '{
    "commentId": "test_123",
    "postId": "post_456",
    "authorName": "Tester",
    "commentText": "This is a test comment"
  }'
```

### Test Workflow 4 (Learning Path)
```bash
curl -X POST http://localhost:5678/webhook/generate-learning-path \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "userLevel": "beginner",
    "targetSkills": ["web-security"]
  }'
```

---

## Monitoring & Logs

### n8n Execution Logs
- View in n8n UI: Executions tab
- Filter by workflow, status, date
- View detailed execution data

### Database Monitoring
```sql
-- Check recent crawls
SELECT * FROM blog_crawls ORDER BY created_at DESC LIMIT 10;

-- Check security aggregations
SELECT category, severity, COUNT(*) 
FROM security_aggregations 
GROUP BY category, severity;

-- Check comment spam stats
SELECT status, COUNT(*) 
FROM comments 
GROUP BY status;
```

### Error Handling
All workflows include error nodes that:
- Log errors to n8n
- Return user-friendly error messages
- Continue processing where possible

---

## Maintenance

### Weekly Tasks
- Review spam detection accuracy
- Check aggregation source availability
- Monitor database size and performance

### Monthly Tasks
- Update AI prompts based on feedback
- Review and update security sources
- Analyze learning path effectiveness
- Update Discord bot commands

### As Needed
- Add new security sources
- Adjust spam detection thresholds
- Update email templates
- Enhance Discord bot features
