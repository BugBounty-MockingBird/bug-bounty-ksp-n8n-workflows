# Environment Variables Template

Copy this file to `.env` and fill in your actual values.

## Database Configuration
```bash
# PostgreSQL Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=bugbounty_ksp
DB_USER=your_db_user
DB_PASSWORD=your_db_password
```

## Email Configuration (SMTP)
```bash
# Email notifications
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
NOTIFICATION_FROM_EMAIL=noreply@bugbounty.com
```

## Discord Configuration
```bash
# Discord Bot Token (for bot commands)
DISCORD_BOT_TOKEN=your_discord_bot_token_here

# Discord Webhook URLs (for notifications)
DISCORD_WEBHOOK_SECURITY=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN
DISCORD_WEBHOOK_GENERAL=https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN

# Discord Channel IDs
DISCORD_CHANNEL_SECURITY=123456789012345678
DISCORD_CHANNEL_GENERAL=123456789012345678
```

## Slack Configuration (Optional)
```bash
# Slack Integration
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
SLACK_BOT_TOKEN=xoxb-your-slack-bot-token
SLACK_CHANNEL_SECURITY=#security-alerts
```

## AI/ML Configuration
```bash
# OpenAI API (for Fabric-powered learning paths)
OPENAI_API_KEY=sk-your-openai-api-key-here
OPENAI_MODEL=gpt-4-turbo-preview

# Alternative: Local LLM or Fabric API
FABRIC_API_URL=http://localhost:8080/api/generate
FABRIC_API_KEY=your_fabric_api_key
```

## Application URLs
```bash
# Your application base URL
APP_URL=https://bugbounty.com

# n8n Configuration
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_WEBHOOK_BASE_URL=http://localhost:5678
```

## Security & Authentication
```bash
# API Keys for external services
GITHUB_TOKEN=ghp_your_github_token
BUGCROWD_API_KEY=your_bugcrowd_api_key
HACKERONE_API_TOKEN=your_hackerone_token

# Webhook secrets for validation
WEBHOOK_SECRET=your_random_secret_string_here
```

## Feature Flags
```bash
# Enable/disable specific features
ENABLE_SLACK_NOTIFICATIONS=true
ENABLE_DISCORD_BOT=true
ENABLE_EMAIL_NOTIFICATIONS=true
ENABLE_AI_LEARNING_PATHS=true
```

## Rate Limiting & Performance
```bash
# Workflow execution settings
MAX_CONCURRENT_WORKFLOWS=5
REQUEST_TIMEOUT=30000
MAX_RETRIES=3
```

## Logging & Monitoring
```bash
# Log levels: debug, info, warn, error
LOG_LEVEL=info
ENABLE_DEBUG_LOGS=false
```

## Notes

1. **Never commit .env file to git** - it contains sensitive credentials
2. Use strong, unique passwords for all services
3. For Discord bot token: https://discord.com/developers/applications
4. For Discord webhooks: Server Settings → Integrations → Webhooks
5. For OpenAI API key: https://platform.openai.com/api-keys
6. For production, use environment variables directly instead of .env file
7. Rotate credentials regularly for security
8. Use different credentials for development and production environments
