# 🚀 Smart Event Explorer
> **Leveraging AI to bridge the gap between students and verified campus events.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![NodeJS](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini%20AI-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

---

## 📌 Table of Contents
- [The Problem](#-the-problem)
- [Our Solution](#-our-solution)
- [Key Features](#-key-features)
- [App Glimpses](#-app-glimpses)
- [Tech Stack](#-tech-stack)
- [Installation & Setup](#-installation--setup)
- [Future Scope](#-future-scope)
- [Team](#-team)

---

## 🧐 The Problem
In the fast-paced digital ecosystem of university campuses, valuable opportunities—like hackathons, workshops, and meetups—are frequently missed due to **information fragmentation**.
- ❌ **Scattered Info:** Event details are buried in WhatsApp spam or Instagram stories.
- ❌ **Lack of Credibility:** Students can't verify if an event is legitimate or cancelled.
- ❌ **No Real-Time Support:** Static posters can't answer questions like *"Is a laptop required?"* or notify attendees about venue changes due to rain.

## 💡 Our Solution
**Smart Event Explorer** is a centralized, AI-powered mobile platform that bridges the gap between organizers and attendees. We don't just list events; we provide an **intelligent assistant** to help students navigate their campus life.

### 🌟 Why it stands out?
* **🤖 AI-Powered Chatbot:** Integrated with **Google Gemini API** to answer specific queries about any event instantly.
* **✅ Verified Organizers:** A strict approval system ensures only legitimate events are listed.
* **🔔 Real-Time Alerts:** Powered by **Firebase** to send instant notifications for schedule changes.

---

## ✨ Key Features

| Feature | Description |
| :--- | :--- |
| **🔍 Smart Discovery** | Advanced filtering by domain, date, and location to find the perfect hackathon. |
| **🤖 Event Chatbot** | A dedicated AI assistant for every event that answers user queries naturally. |
| **🛡️ Organizer Verification** | Admin-approved hosting rights to prevent spam and fake listings. |
| **🌐 Networking Hub** | Connect your **LinkedIn & GitHub** profiles to network with other attendees. |
| **📍 Location Services** | Integrated **Google Maps** to navigate students directly to the venue. |

---

## 📱 App Glimpses

| **Splash Screen** | **Login Screen** | **Signup Screen** |
| :---: | :---: | :---: |
| <img src="https://drive.google.com/thumbnail?id=15X7S2SMvIqhFlmDa5z7TClNzAAQrBdOV" height="400"> | <img src="https://drive.google.com/thumbnail?id=1CwX337TBDWu8PHYyAVTGlpIlCEGjmDqe" height="400"> | <img src="https://drive.google.com/thumbnail?id=1he3uX8joOFXh1wt8Zfz4ZoZV2DDzhkY7" height="400"> |

| **Home Feed** | **Search Event** | **Event Details** |
| :---: | :---: | :---: |
| <img src="https://drive.google.com/thumbnail?id=1QZbg1iDxMLeF0LWD7GAVuIV9ACm84Cm_" height="400"> | <img src="https://drive.google.com/thumbnail?id=1QA_-NkFRt_-0BH36mqoG-IeWa57hNXed" height="400"> | <img src="https://drive.google.com/thumbnail?id=1z7WRAPf60DybCQppdAb4SX_c-l7EV0OC" height="400"> |

| **Create Event** | **Forgot Password** |
| :---: | :---: |
| <img src="https://drive.google.com/thumbnail?id=1bphj1kzgd-Ywrpqu6mCHIZvfIEAbOWmG" height="400"> | <img src="https://drive.google.com/thumbnail?id=1H0xBB5ui75nTPxVPdbtSKr-igf0UQbmk" height="400"> |

---

## 🛠 Tech Stack

### **Frontend (Mobile App)**
* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **UI Engine:** Material Design 3

### **Backend (API)**
* **Runtime:** Node.js
* **Framework:** Express.js
* **Authentication:** JWT (JSON Web Tokens)

### **Database & Cloud**
* **Database:** MongoDB (NoSQL)
* **Real-time & Auth:** Firebase
* **AI Integration:** Google Gemini API

---

## 💻 Installation & Setup

### 1. Clone the Repository
Start by cloning the project to your local machine.
```bash
git clone [https://github.com/ankitsavaliya/smart-event-explorer.git](https://github.com/ankitsavaliya/smart-event-explorer.git)
cd smart-event-explorer

```

### 2. Backend Setup

You need to set up the Node.js server first.

```bash
cd backend
npm install

```

**Configure Environment Variables:**
Create a file named `.env` in the backend folder and add the following:

```env
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_secret_key
GEMINI_API_KEY=your_google_ai_key

```

**Run the Server:**

```bash
npm run server

```

### 3. Frontend Setup

Now, set up the Flutter mobile application.

```bash
cd frontend

```

**Install Dependencies:**

```bash
flutter pub get

```

**Run the App:**
Connect your device or emulator and run:

```bash
flutter run

```

---

## 🔮 Future Scope

* **🌤️ Weather Integration:** Auto-detect rain/bad weather and alert organizers to update venue details instantly.
* **🧠 Personalized Recommendations:** Using ML to suggest events based on a student's past attendance and interests.
* **🎟️ In-App Ticketing:** Secure payment gateway integration for paid workshops and QR code generation for entry.
* **📊 Feedback Analytics:** AI-summarized feedback for organizers to improve future events.

---

## 👥 Team Smart Event Explorer

| Member | Role |
| --- | --- |
| **Ankit Savaliya** | Team Lead & Full Stack Dev |
| **Yashvi Savaj** | UI/UX Designer |
| **Yug Sheth** | Backend Developer |
| **Pratham Rana** | App Developer |

---
