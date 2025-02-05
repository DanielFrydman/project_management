# 🚀 Project Management

The developed application is a project management system built with Ruby on Rails and Hotwire (Turbo).
Its goal is to allow users to create projects, add comments, and track status changes in a conversation-like history.

## 🎯 Original Task & Extensions

Build a project conversation history where users could:
- Leave comments
- Change project status
- View a history of comments and status changes
- Sign up and sign in
- Create, read and update (CRU) a Project

## 🧑‍💻 Used Technologies

* `Ruby`: Version 3.3.6
* `Rails`: Version 8.0.1
* `PostgreSQL`: Version 16
* `Hotwire`: Latest
* `Tailwind CSS`: Version 4.0.3
* `Docker`: Latest
* `Docker Compose`: Latest

## 🔧 Gems added

* `slim-rails`: Added for cleaner view templates
* `view_component`: Added for reusable view components
* `propshaft`: Added for asset pipeline
* `tailwindcss-rails`: Added for styling
* `stimulus-rails`: Added for JavaScript sprinkles
* `turbo-rails`: Added for real-time features

## 🎢 Features

- **User Authentication**
  - Sign up with name, email, and password
  - Sign in with email and password

- **Projects**
  - Create new projects with title, description and status
  - View all projects in a card layout

- **Comments**
  - Add comments to projects
  - Comments appear in the conversation history

- **Status Management**
  - Change project status (e.g., "Not Started", "In Progress", "Completed")
  - Status changes are tracked in the conversation history

- **Activity Feed**
  - Chronological display of all project activities
  - Includes both comments and status changes

## 🐳 Run the project locally

1. Clone the repository:
```bash
git clone ...
cd project_management
```

2. Build and start the containers with all necessary setup:
```bash
# Stop any running containers and clean up
docker compose down

# Update compile assets
docker compose exec web rake assets:precompile
docker compose exec web bin/rails assets:clobber

# Rebuild and start containers
docker compose build
docker compose up -d
```

3. Create and setup the database:
```bash
docker compose exec web bin/rails db:create db:migrate db:seed
```

4. Visit http://localhost:3000 in your browser

Note: If you make changes to JavaScript files or have issues with assets, you might need to rerun the asset compilation steps:
```bash
docker compose exec web rake assets:precompile
docker compose exec web bin/rails assets:clobber
docker compose restart web
```

## 🚀 Deployment

This application is configured for deployment on Render.com.

### Prerequisites

1. Create a free account on [Render](https://render.com)
2. Fork or clone this repository to your GitHub account

### Deploy Steps

1. From the Render dashboard, click "New +" and select "Web Service"
2. Connect your GitHub repository
3. Fill in the following configuration:
   - **Name**: Choose a name for your service
   - **Environment**: Ruby
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `bundle exec rails server`
   - **Ruby Version**: 3.3.6

4. Add the following environment variables:
   - `RAILS_MASTER_KEY`: Your Rails master key from config/master.key
   - `DATABASE_URL`: Will be automatically added if you create a Render PostgreSQL database
   - `RAILS_ENV`: production

5. Click "Create Web Service"

### Database Setup

1. From the Render dashboard, click "New +" and select "PostgreSQL"
2. Choose the free plan
3. After creation, note the internal Database URL
4. Add this URL as the `DATABASE_URL` environment variable in your web service settings

The application will automatically run migrations during the build process (see bin/render-build.sh).

## 🧪 Future Improvements

- Add user roles and permissions
- Add file attachments to comments
- Add project search and filtering
- Add comment editing and deletion
- Add activity feed filtering by status, comment or chronological order
