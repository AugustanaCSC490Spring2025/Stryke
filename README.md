# Stryke App

[📘 View Our Dev Logs](https://sites.google.com/augustana.edu/stryke/home)

## 📋 Abstract  
**Stryke** is a mobile app built for college student-athletes and their coaches to track athletic performance, manage goals, and collaborate as a team. With clean UI, Firebase-powered data handling, and customizable metrics, Stryke helps athletes visualize progress and gives coaches insight into who may need additional support.

Built with **Flutter** and **Firebase**, the app combines seamless authentication, flexible data entry, and real-time analytics — all tailored for the unique needs of athletic programs.

---

## 🚀 Key Features

### ✅ User Authentication  
- Google Sign-In & Email/Password login  
- Conditional navigation based on account setup  
- Real-time error handling & input validation  

### 📊 Personalized Progress Tracking  
- Line chart displays for each tracked metric  
- Weekly/monthly/seasonal views  
- Editable metric history and dynamic goal tracking  
- Support for both weight loss and gain goals (with adaptive color feedback)

### 🧩 Custom Metric System  
- Add custom metrics (e.g., "50 Free", "Bench Press", "3pt %")  
- Set tracked fields per metric (e.g., time, reps, %, etc.)  
- Add values on specific dates and view charted performance over time  

### 🖼️ UI/UX Design  
- Modular, widget-based screens  
- Interactive goal progress bars  
- Intuitive flows based on user role and current app state  
- Fully responsive across devices  

### 🔥 Firebase Integration  
- Firestore backend with structured collections for each user and metric  
- User-specific metric and goal storage  
- Support for multi-role expansion (coach vs. athlete)  
- Teams collection with join codes  

---

## 💡 Development Highlights

### 1. Foundational Setup  
- Translated Figma wireframes into live Flutter screens  
- Firebase authentication & database initialized  
- Basic onboarding, login/signup flows implemented  

### 2. Authentication + Navigation Logic  
- Removed Bloc for clarity and simplicity  
- Implemented Google Sign-In with SHA-1 configs per developer  
- Added navigation logic based on user account and data existence  

### 3. Screens & Component Development  
- Finalized Home, Personal, and Input screens  
- Metric boxes dynamically built from Firestore  
- Reusable widgets created for easier scaling  

### 4. Advanced Charting & Goal Systems  
- Line charts built to reflect user input dynamically  
- Goals adjust based on direction (gain/loss) with red/yellow/green indicators  
- Chart scales with data and filters by date range  

### 5. Team Infrastructure Laid Out  
- Created Team collection and 5-letter join code system  
- UI for team joining screen designed  
- Coach/athlete structure in progress for future team dashboards  

---

## 🧭 Looking Ahead

- 🔄 **Real-time Data Updates** – Live sync for athlete performance  
- 🧑‍🤝‍🧑 **Coach Dashboards** – View athlete progress, highlight trends, identify support needs  
- 📈 **Team & Group Analytics** – Compare across teams, generate summaries  
- 🧱 **Enhanced Role Management** – Differentiated views and controls for coaches and athletes  
- 🎯 **Push Notifications** – Reminders for input logging, goal milestones  

---

## 💬 Feedback & Collaboration  
We’re actively improving Stryke and welcome feedback from athletes, coaches, and developers. Stay tuned as we roll out more features this season!

