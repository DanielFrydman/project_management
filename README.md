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

## 🤔 Questions (and Answers) I Would Have Asked and Waited For

### Project Basics

**Q: What are the valid project statuses we should support?**  
A: The system should support common statuses: "Not Started", "In Progress", "On Hold", and "Completed".

**Q: What fields are essential for a project beyond title, description, status, comments, and author?**  
A: These fields are sufficient for the MVP.

**Q: Should a project be linked to a user (owner)?**  
A: Yes, each project should be linked to a user and display "Created by ...".

---

### User Access & Permissions

**Q: Do we need full user authentication or just basic identification?**  
A: Basic authentication is enough to track who created projects, commented, and changed statuses.

**Q: Should projects be private to their creators or visible to all users?**  
A: All authenticated users should be able to view all projects in the MVP.

**Q: Do we need different permission levels for different actions?**  
A: No, any authenticated user should be able to create projects, comment, and change statuses.

---

### Project Interaction & UI

**Q: Should status changes and comments appear in a single timeline?**  
A: Yes, both should be shown in chronological order.

**Q: Should we include a filter bar for project comments and status changes?**  
A: No, filtering is not needed for the MVP.

**Q: Should the project listing page have sorting options?**  
A: Sorting by creation date is sufficient for now.

**Q: Should we implement search functionality?**  
A: Not needed for the MVP.

**Q: Should comments support formatting like rich text or markdown?**  
A: Simple text comments are fine for the MVP.

**Q: Do we need sub-tasks within projects?**  
A: No, sub-tasks are not needed for the MVP.

**Q: Do we need a dashboard view or just a project listing?**  
A: A simple project listing with clear status indicators is sufficient.

---

### Performance & Scaling

**Q: How many users are expected to access the MVP?**  
A: Not many, the system will be in beta testing.

**Q: Do we have any performance requirements for listing history?**  
A: No pagination is needed now, but it will be required later as the number of projects, comments and status changes grows.

**Q: How long should we retain project history?**  
A: Indefinitely for now, with potential archiving in the future.

**Q: Should we implement real-time updates for comments and status changes?**  
A: Yes, using Hotwire/Turbo for seamless updates without page refreshes.

---

### Infrastructure & Deployment

**Q: What’s the expected deployment environment?**  
A: Render.com should be used for deployment.

**Q: Do we need any specific monitoring setup?**  
A: No monitoring is needed for the MVP.

**Q: Should we implement automated QA processes?**  
A: Yes, basic CI/CD with RSpec tests and linting.

**Q: How should we handle mobile responsiveness?**  
A: Full responsive design using Tailwind CSS from the start.

---

### Future Considerations

**Q: Should we implement soft deletes for projects and comments?**  
A: Not needed for MVP but useful later to prevent data loss.

**Q: Do we need any data export functionality?**  
A: Not required for MVP but should be considered for future iterations.

**Q: Should we prepare for internationalization?**  
A: Not for MVP, but we should follow Rails i18n conventions to allow for future localization.

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
<br>
<br>
You can test the application in the following URL: https://project-management-se5e.onrender.com.
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
- Add pagination to the projects list and to the activity feed in each project
