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

2. Start all services in the correct order:
```bash
# Build the images first
docker compose build

# Start the database and run migrations
docker compose up db setup -d

# Start the asset compilation
docker compose up assets

# Start the Tailwind watcher and web server
docker compose up tailwind web
```

The application will be available at http://localhost:3000

## 🔧 Common Tasks

### Database operations
```bash
# Reset database (will recreate and reseed)
docker compose run --rm setup bin/rails db:reset

# Run new migrations
docker compose run --rm setup bin/rails db:migrate

# Run seeds only
docker compose run --rm setup bin/rails db:seed

# Access database console
docker compose exec db psql -U postgres project_management_development
```

### First time setup
```bash
# Create and seed the database
docker compose exec web bin/rails db:setup
```

### Rebuild after changes
```bash
# If you change the Dockerfile or add new dependencies:
docker compose build

# If you change JavaScript or CSS:
docker compose restart assets tailwind

# If you change Ruby code:
docker compose restart web
```

### View logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f web
docker compose logs -f assets
docker compose logs -f tailwind
docker compose logs -f db
```

### Rails console
```bash
docker compose exec web bin/rails console
```

### Clean up
```bash
# Stop all services
docker compose down

# Remove all data (including database)
docker compose down -v
```

## 🔧 Useful Docker Commands

```bash
# View logs of all services
docker compose logs -f

# View logs of a specific service
docker compose logs -f web
docker compose logs -f css
docker compose logs -f db

# Rebuild assets
docker compose exec web bin/rails assets:precompile

# Reset database
docker compose exec web bin/rails db:reset

# Run Rails console
docker compose exec web bin/rails console

# Restart all services
docker compose restart

# Stop all services
docker compose down

# Stop all services and remove volumes (will delete database data)
docker compose down -v
```

## 🔧 Troubleshooting

If you encounter asset-related issues:

1. Clean and rebuild assets and restart the Rails server

```bash
docker compose exec web bin/rails assets:clean
docker compose exec web bin/rails assets:clobber
docker compose exec web bin/rails tailwindcss:build
docker compose exec web bin/rails assets:precompile
docker compose restart web
```

## 🚀 Deployment

This application is configured for deployment on Render.com.
<br>
<br>
You can test the application in the following URL: .
<br>
<br>
The page may take a while to load as it is a free service and the system sleeps but once it loads, it is quick.
<br>
<br>
The PostgreSQL DB in Render will be erased after 90 days.
<br>
<br>
***Please be aware that the link may be inactive, depending on when you access my repository, as the Render database associated with the free version could potentially have expired. Thank you for your understanding.***

## 🧪 Future Improvements

- Add user roles and permissions
- Add file attachments to comments
- Add project search and filtering
- Add comment editing and deletion
- Add activity feed filtering by status, comment or chronological order
