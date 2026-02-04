# Database Schema for Bug Bounty KSP n8n Workflows

This document outlines the database schema required for the n8n workflows to function properly.

## Required Tables

### 1. blog_crawls
Stores initial blog crawl information for each user.

```sql
CREATE TABLE blog_crawls (
    crawl_id VARCHAR(100) PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    blog_url TEXT NOT NULL,
    posts_found INTEGER DEFAULT 0,
    crawl_data JSONB,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, blog_url)
);

CREATE INDEX idx_blog_crawls_user_id ON blog_crawls(user_id);
CREATE INDEX idx_blog_crawls_status ON blog_crawls(status);
```

### 2. blog_posts
Stores individual blog posts extracted from crawls.

```sql
CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    crawl_id VARCHAR(100) REFERENCES blog_crawls(crawl_id),
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    publish_date TIMESTAMP,
    content TEXT,
    is_new BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    last_seen_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, url)
);

CREATE INDEX idx_blog_posts_user_id ON blog_posts(user_id);
CREATE INDEX idx_blog_posts_url ON blog_posts(url);
CREATE INDEX idx_blog_posts_is_new ON blog_posts(is_new);
```

### 3. security_aggregations
Stores aggregated cybersecurity news and vulnerability information.

```sql
CREATE TABLE security_aggregations (
    agg_id SERIAL PRIMARY KEY,
    aggregation_id VARCHAR(100),
    title TEXT NOT NULL,
    url TEXT NOT NULL UNIQUE,
    description TEXT,
    publish_date TIMESTAMP,
    source VARCHAR(100),
    category VARCHAR(50),
    severity VARCHAR(20),
    tags JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    last_seen_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_security_agg_category ON security_aggregations(category);
CREATE INDEX idx_security_agg_severity ON security_aggregations(severity);
CREATE INDEX idx_security_agg_created ON security_aggregations(created_at DESC);
CREATE INDEX idx_security_agg_tags ON security_aggregations USING GIN(tags);
```

### 4. weekly_summaries
Stores weekly aggregation summaries.

```sql
CREATE TABLE weekly_summaries (
    summary_id SERIAL PRIMARY KEY,
    aggregation_id VARCHAR(100) NOT NULL,
    week_ending DATE NOT NULL,
    total_items INTEGER,
    statistics JSONB,
    generated_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(aggregation_id)
);

CREATE INDEX idx_weekly_summaries_week ON weekly_summaries(week_ending DESC);
```

### 5. comments
Stores user comments with spam detection results.

```sql
CREATE TABLE comments (
    comment_id VARCHAR(100) PRIMARY KEY,
    post_id VARCHAR(100),
    author_id VARCHAR(100),
    author_name VARCHAR(255),
    author_email VARCHAR(255),
    comment_text TEXT NOT NULL,
    parent_comment_id VARCHAR(100),
    spam_score INTEGER DEFAULT 0,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_comments_status ON comments(status);
CREATE INDEX idx_comments_spam_score ON comments(spam_score);
```

### 6. blocked_comments
Logs blocked spam comments.

```sql
CREATE TABLE blocked_comments (
    id SERIAL PRIMARY KEY,
    comment_id VARCHAR(100),
    author_name VARCHAR(255),
    author_email VARCHAR(255),
    comment_text TEXT,
    spam_score INTEGER,
    spam_reasons JSONB,
    blocked_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_blocked_comments_blocked_at ON blocked_comments(blocked_at DESC);
```

### 7. users
Stores user information and preferences.

```sql
CREATE TABLE users (
    user_id VARCHAR(100) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    notification_preferences JSONB DEFAULT '{"comments": true, "security": true, "learning": true}'::jsonb,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

### 8. learning_paths
Stores AI-generated learning paths.

```sql
CREATE TABLE learning_paths (
    path_id SERIAL PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL,
    request_id VARCHAR(100) UNIQUE,
    title TEXT NOT NULL,
    description TEXT,
    path_data JSONB NOT NULL,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_learning_paths_user_id ON learning_paths(user_id);
CREATE INDEX idx_learning_paths_status ON learning_paths(status);
```

### 9. learning_milestones
Tracks progress on learning path milestones.

```sql
CREATE TABLE learning_milestones (
    milestone_id SERIAL PRIMARY KEY,
    path_id INTEGER REFERENCES learning_paths(path_id) ON DELETE CASCADE,
    user_id VARCHAR(100) NOT NULL,
    milestone_id_ref INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    duration VARCHAR(50),
    skills JSONB,
    resources JSONB,
    projects JSONB,
    assessment TEXT,
    status VARCHAR(50) DEFAULT 'not_started',
    progress INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_learning_milestones_path_id ON learning_milestones(path_id);
CREATE INDEX idx_learning_milestones_user_id ON learning_milestones(user_id);
CREATE INDEX idx_learning_milestones_status ON learning_milestones(status);
```

## Setup Script

Run this script to create all tables:

```bash
# Using psql
psql -U your_username -d your_database -f schema.sql

# Or using environment variables
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f schema.sql
```

## Notes

- All timestamps are stored in UTC
- JSONB columns are used for flexible data storage and efficient querying
- Indexes are created on frequently queried columns
- Foreign key relationships maintain data integrity
- Unique constraints prevent duplicate entries
