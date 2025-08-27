# 🏛️ CivicRMS & CivicAI

**CivicRMS** is a modular, transparent workspace platform built for civic-grade collaboration.  
**CivicAI** is its signature AI companion—an ethical, contributor-first assistant that scaffolds onboarding, generates documents, and guides public-good workflows.

Together, they empower nonprofits, agencies, and civic teams to work with clarity, joy, and reproducibility.

---

## ✨ Features

### CivicRMS
- 🧩 Modular workspaces inspired by Notion
- 📊 Structured data views with Airtable-style grids
- ✅ Task boards and Gantt timelines for project management
- 🔍 Audit logs and transparency-first architecture
- 🔐 Multi-provider authentication (Google, Facebook, X, Email)

### CivicAI
- 💬 Chat interface with markdown, code, and civic prompts
- 📝 Document generation (grants, onboarding guides, meeting notes)
- 📚 Dataset summarization and ethical nudges
- 🧠 Contributor onboarding and workspace guidance
- 📱 iOS app with offline support and push notifications

---

## 🚀 Getting Started

### Web App (Next.js + Supabase)
```bash
git clone https://github.com/your-org/civicrms.git
cd civicrms
npm install
cp .env.local.example .env.local
# Add your SUPABASE_URL and SUPABASE_KEY
npm run dev
```