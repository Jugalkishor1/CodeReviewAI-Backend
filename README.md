# CodeReviewAI — Backend

Rails API for AI-powered GitHub pull request reviews.

**Frontend repo:** [CodeReviewAI-Frontend](https://github.com/Jugalkishor1/CodeReviewAI-Frontend)

## Stack

- Rails 8 (API-only)
- PostgreSQL
- GitHub OAuth + GitHub REST API
- Groq (AI reviews)

## Setup

### Requirements

- Ruby (see `.ruby-version`)
- PostgreSQL
- Bundler

### Install & run

```bash
cp .env.example .env
# fill in the values below

bundle install
bin/rails db:create db:migrate
bin/rails server
```

API: [http://localhost:3000](http://localhost:3000)

## Environment variables

Copy `.env.example` → `.env`:

```env
GITHUB_CLIENT_ID=your_github_oauth_client_id
GITHUB_CLIENT_SECRET=your_github_oauth_client_secret
GITHUB_REDIRECT_URI=http://localhost:5173
FRONTEND_ORIGIN=http://localhost:5173
GROQ_API_KEY=your_groq_api_key
```

| Variable | Description |
|---|---|
| `GITHUB_CLIENT_ID` | OAuth App Client ID (same as frontend) |
| `GITHUB_CLIENT_SECRET` | OAuth App secret — **backend only** |
| `GITHUB_REDIRECT_URI` | Must match frontend redirect + GitHub callback URL |
| `FRONTEND_ORIGIN` | Frontend origin for CORS (comma-separated if multiple) |
| `GROQ_API_KEY` | Groq API key for AI reviews |

### GitHub OAuth App

Create at [GitHub Developer Settings → OAuth Apps](https://github.com/settings/developers):

| Field | Local | Production |
|---|---|---|
| Homepage URL | `http://localhost:5173` | your Vercel URL |
| Authorization callback URL | `http://localhost:5173` | your Vercel URL |

Client ID + Client Secret identify **your app**. Any GitHub user can sign in with their own account.

## API

All routes except `POST /auth/github` require:

`Authorization: Bearer <session_token>`

| Method | Path | Description |
|---|---|---|
| `POST` | `/auth/github` | Exchange OAuth `code` for session (`{ code, redirect_uri }`) |
| `GET` | `/me` | Current user |
| `GET` | `/repositories?search=` | Sync + list repos |
| `GET` | `/repositories/:id/pull_requests` | Sync + list open PRs |
| `GET` | `/pull_requests/:id` | PR details (+ reviews) |
| `POST` | `/pull_requests/:id/review` | Generate AI review |
| `GET` | `/reviews` | Review history |
| `GET` | `/reviews/:id` | Single review |
| `DELETE` | `/reviews/:id` | Delete review |
| `GET` | `/up` | Health check |

## Project structure

```
app/
  controllers/     # auth + API endpoints
  models/          # users, repositories, pull_requests, reviews
  services/        # GitHub, Groq, sync, encryption
  serializers/     # JSON responses
```

## Production (Render)

```env
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
GITHUB_REDIRECT_URI=https://your-frontend.vercel.app
FRONTEND_ORIGIN=https://your-frontend.vercel.app
GROQ_API_KEY=
SECRET_KEY_BASE=          # bin/rails secret
DATABASE_URL=             # usually set by Render
```

Set `FRONTEND_ORIGIN` to your Vercel URL or CORS will block the browser.
