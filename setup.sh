#!/bin/bash
# Setup script for Bug Bounty KSP n8n Workflows

set -e

echo "🚀 Bug Bounty KSP n8n Workflows Setup"
echo "======================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check for psql
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL client (psql) not found. Please install PostgreSQL."
    exit 1
fi
echo "✓ PostgreSQL client found"

# Check for curl
if ! command -v curl &> /dev/null; then
    echo "⚠️  curl not found. Please install curl."
    exit 1
fi
echo "✓ curl found"

echo ""
echo "Prerequisites check passed!"
echo ""

# Database setup
read -p "Do you want to setup the database schema? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Enter PostgreSQL host (default: localhost): " DB_HOST
    DB_HOST=${DB_HOST:-localhost}
    
    read -p "Enter PostgreSQL port (default: 5432): " DB_PORT
    DB_PORT=${DB_PORT:-5432}
    
    read -p "Enter database name: " DB_NAME
    read -p "Enter database user: " DB_USER
    read -sp "Enter database password: " DB_PASSWORD
    echo ""
    
    echo ""
    echo "Creating database schema..."
    
    # Extract SQL from markdown and execute
    sed -n '/```sql/,/```/p' docs/database-schema.md | grep -v '```' > /tmp/schema.sql
    
    PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f /tmp/schema.sql
    
    if [ $? -eq 0 ]; then
        echo "✓ Database schema created successfully!"
    else
        echo "✗ Database schema creation failed. Please check your credentials and try again."
        exit 1
    fi
    
    rm /tmp/schema.sql
fi

echo ""
echo "Environment variables setup"
echo "============================"
echo ""

if [ ! -f .env ]; then
    echo "Creating .env file from template..."
    
    # Create basic .env file
    cat > .env << EOF
# Database Configuration
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-bugbounty_ksp}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-your_password}

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
NOTIFICATION_FROM_EMAIL=noreply@bugbounty.com

# Discord Configuration
DISCORD_BOT_TOKEN=your_discord_bot_token
DISCORD_WEBHOOK_SECURITY=https://discord.com/api/webhooks/YOUR_WEBHOOK
DISCORD_WEBHOOK_GENERAL=https://discord.com/api/webhooks/YOUR_WEBHOOK

# OpenAI Configuration
OPENAI_API_KEY=sk-your-openai-api-key

# Application URLs
APP_URL=https://bugbounty.com
N8N_WEBHOOK_BASE_URL=http://localhost:5678
EOF
    
    echo "✓ .env file created"
    echo "⚠️  Please edit .env and fill in your actual credentials"
else
    echo ".env file already exists, skipping..."
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env with your actual credentials"
echo "2. Import workflows into n8n:"
echo "   - Open n8n UI"
echo "   - Go to Workflows → Import from File"
echo "   - Import each workflow from workflows/ directory"
echo "3. Configure credentials in n8n"
echo "4. Activate workflows"
echo ""
echo "For detailed instructions, see README.md"
echo ""
