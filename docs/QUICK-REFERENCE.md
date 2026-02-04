# Quick Reference Guide

## Workflow Endpoints

### Workflow 1: Blog Crawl
```
POST /webhook/start-blog-crawl
```
**Payload:**
```json
{
  "userId": "string",
  "blogUrl": "string",
  "userName": "string"
}
```

### Workflow 3: Comment Notification
```
POST /webhook/comment-webhook
```
**Payload:**
```json
{
  "commentId": "string",
  "postId": "string",
  "postTitle": "string",
  "postUrl": "string",
  "authorName": "string",
  "authorEmail": "string",
  "commentText": "string"
}
```

### Workflow 4: Learning Path Generation
```
POST /webhook/generate-learning-path
```
**Payload:**
```json
{
  "userId": "string",
  "userName": "string",
  "userLevel": "beginner|intermediate|advanced",
  "targetSkills": ["array", "of", "skills"],
  "learningGoals": "string"
}
```

### Workflow 5: Discord Bot
```
POST /webhook/discord-webhook
```
**Commands in Discord:**
- `!help` - Show all commands
- `!search <keyword>` - Search vulnerabilities
- `!stats` - Show your statistics
- `!leaderboard` - Community rankings
- `!subscribe <category>` - Subscribe to alerts
- `!learning` - Learning path progress

## Scheduled Workflows

### Workflow 2: Security Aggregation
- **Schedule:** Every Monday at 9:00 AM
- **Action:** Aggregates security news from multiple sources
- **Output:** Stored in `security_aggregations` table

### Workflow 5: Discord Digest
- **Schedule:** Every 6 hours
- **Action:** Posts security digest to Discord
- **Output:** Discord channel message

## Database Tables Quick Reference

| Table | Purpose |
|-------|---------|
| `blog_crawls` | Blog crawl metadata |
| `blog_posts` | Extracted blog posts |
| `security_aggregations` | Security news items |
| `weekly_summaries` | Aggregation summaries |
| `comments` | User comments |
| `blocked_comments` | Spam logs |
| `users` | User information |
| `learning_paths` | AI-generated paths |
| `learning_milestones` | Progress tracking |

## Environment Variables Quick Reference

### Essential
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `OPENAI_API_KEY` (for Workflow 4)
- `DISCORD_BOT_TOKEN` (for Workflow 5)

### Optional
- `SMTP_HOST`, `SMTP_USER`, `SMTP_PASSWORD`
- `SLACK_WEBHOOK_URL`
- `DISCORD_WEBHOOK_SECURITY`

## n8n Credentials Required

1. **postgres-main** - PostgreSQL database
2. **smtp-main** - Email sending (optional)
3. **openai-main** - OpenAI API (for Workflow 4)
4. **discord-bot-auth** - Discord bot (for Workflow 5)
5. **slack-main** - Slack notifications (optional)

## Common Issues & Solutions

### Issue: Workflow not triggering
**Solution:** 
- Check if workflow is activated (toggle switch)
- Verify webhook URL is correct
- Check n8n logs for errors

### Issue: Database connection failed
**Solution:**
- Verify PostgreSQL is running
- Check credentials in n8n
- Ensure database tables are created
- Check firewall/network settings

### Issue: Email not sending
**Solution:**
- Verify SMTP credentials
- Check SMTP port (587 for TLS, 465 for SSL)
- Enable "Less secure apps" for Gmail
- Use app-specific password for Gmail

### Issue: Discord bot not responding
**Solution:**
- Verify bot token is correct
- Check bot has proper permissions
- Ensure bot is invited to server
- Verify channel IDs are correct

### Issue: OpenAI API error
**Solution:**
- Check API key is valid
- Verify you have credits/billing enabled
- Check rate limits
- Ensure model name is correct

## Testing Commands

### Test Blog Crawl
```bash
curl -X POST http://localhost:5678/webhook/start-blog-crawl \
  -H "Content-Type: application/json" \
  -d '{"userId":"test","blogUrl":"https://example.com","userName":"Test"}'
```

### Test Comment Pipeline
```bash
curl -X POST http://localhost:5678/webhook/comment-webhook \
  -H "Content-Type: application/json" \
  -d '{"commentId":"test123","postId":"post456","authorName":"Test","commentText":"Test comment"}'
```

### Test Learning Path
```bash
curl -X POST http://localhost:5678/webhook/generate-learning-path \
  -H "Content-Type: application/json" \
  -d '{"userId":"test","userLevel":"beginner","targetSkills":["web-security"]}'
```

## Useful SQL Queries

### Check recent activity
```sql
-- Recent crawls
SELECT * FROM blog_crawls ORDER BY created_at DESC LIMIT 10;

-- Recent comments
SELECT * FROM comments ORDER BY created_at DESC LIMIT 10;

-- Security items today
SELECT * FROM security_aggregations 
WHERE created_at > CURRENT_DATE 
ORDER BY severity DESC;
```

### Statistics
```sql
-- Spam statistics
SELECT status, COUNT(*), AVG(spam_score) 
FROM comments GROUP BY status;

-- Security by category
SELECT category, COUNT(*) 
FROM security_aggregations 
GROUP BY category ORDER BY COUNT(*) DESC;

-- Learning path progress
SELECT status, COUNT(*) 
FROM learning_milestones 
GROUP BY status;
```

## Monitoring

### Check n8n Health
```bash
curl http://localhost:5678/healthz
```

### View Workflow Executions
1. Open n8n UI
2. Click "Executions"
3. Filter by workflow, status, or date
4. Click execution to see details

### Database Health
```sql
-- Table sizes
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

## Performance Tuning

### Database Indexes
All required indexes are created by the schema. Monitor query performance:
```sql
-- Slow queries
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

### n8n Settings
- Adjust `MAX_CONCURRENT_WORKFLOWS` in environment
- Increase `REQUEST_TIMEOUT` for slow endpoints
- Enable execution data pruning

### Rate Limiting
- Monitor external API calls
- Implement retry logic with exponential backoff
- Cache frequently accessed data

## Security Checklist

- [ ] Database credentials secured
- [ ] API keys not in code
- [ ] Webhooks use HTTPS in production
- [ ] SMTP credentials secured
- [ ] Discord bot token secured
- [ ] Rate limiting enabled
- [ ] Input validation in place
- [ ] SQL injection prevention (parameterized queries)
- [ ] Regular credential rotation
- [ ] Monitoring and alerting configured

## Support Resources

- **Documentation:** `docs/` folder
- **Workflow Details:** `docs/workflow-documentation.md`
- **Database Schema:** `docs/database-schema.md`
- **Environment Setup:** `docs/environment-variables.md`
- **README:** Full setup guide

## Version Information

- **Workflows Version:** 1.0.0
- **n8n Compatibility:** v1.0.0+
- **PostgreSQL:** 12+
- **Node.js:** 18+ (if self-hosting)
