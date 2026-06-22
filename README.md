# TrueLens AI

> AI-powered deepfake and AI-generated media detection platform.

<div align="center">

![TrueLens AI](https://img.shields.io/badge/TrueLens-AI%20Detection-00C8F0?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)
![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=for-the-badge&logo=fastapi)
![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-MVP%20In%20Progress-FF8C42?style=for-the-badge)

**Upload any image. Know if it's real. In seconds.**

[Features](#features) · [Screenshots](#screenshots) · [Tech Stack](#tech-stack) · [Getting Started](#getting-started) · [Architecture](#architecture) · [Roadmap](#roadmap) · [Contributing](#contributing)

</div>

---

## The Problem

The internet is flooded with AI-generated images and videos. Deepfake technology is advancing faster than most people's ability to detect it. Journalists, researchers, students, and everyday users have no fast, accessible, reliable tool to verify whether what they're seeing is real.

## The Solution

TrueLens AI analyzes any uploaded image and returns:

- **AI Probability Score** — 0 to 100% likelihood the media is AI-generated
- **Risk Classification** — Low / Medium / High
- **Confidence Rating** — how certain the model is about its verdict
- **Plain-English Explanation** — no technical jargon
- **Downloadable PDF Report** — timestamped, shareable forensic summary
- **Scan History** — every analysis saved to your account

---

## Current Status

| Layer | Status |
|---|---|
| Flutter Frontend (UI/UX) | ✅ Complete |
| Upload Flow & Dashboard | ✅ Complete |
| Scan History & PDF Reports (UI) | ✅ Complete |
| FastAPI Backend | 🔄 In Progress |
| AI Detection Pipeline | 🔄 In Progress |
| Backend ↔ Frontend Integration | 🔄 In Progress |

> This is an early-stage MVP built for an entrepreneurship competition. The frontend is fully designed and functional with mock services. Backend and ML integration are actively being developed.

---

## Features

### MVP (Current)
- 📱 Cross-platform app — iOS, Android, Web (Flutter)
- 🖼️ Image upload with automatic media type detection
- 📊 Detection result with probability, confidence, and risk level
- 💬 Plain-English explanation for every scan
- 📁 Scan history with previous results
- 📄 Downloadable PDF forensic report
- 🔐 User authentication (email/password)
- 🎨 Professional dark-themed UI (Material 3)

### Coming Soon
- 🎥 Video deepfake detection
- 🔍 Visual heatmap overlay showing detected regions
- 🌐 Browser extension for instant in-page verification
- 🔌 Developer API for media organizations
- 🔊 Audio deepfake detection

---

## Screenshots

> *(Screenshots will be added once backend integration is complete)*

| Splash | Dashboard | Upload | Results |
|--------|-----------|--------|---------|
| — | — | — | — |

---

## Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| Flutter 3.x | Cross-platform UI framework |
| Riverpod | State management |
| GoRouter | Navigation and routing |
| Material 3 | Design system |

### Backend
| Technology | Purpose |
|---|---|
| FastAPI | REST API framework |
| Python 3.11+ | Backend language |
| PostgreSQL | Primary database |
| SQLAlchemy | ORM |
| Alembic | Database migrations |
| JWT | Authentication tokens |

### ML / AI
| Technology | Purpose |
|---|---|
| PyTorch | Deep learning inference |
| Hugging Face Transformers | Pretrained model loading |
| SigLIP2 + DINOv2 | Dual-encoder detection architecture |
| Pillow | Image preprocessing |

### Infrastructure
| Technology | Purpose |
|---|---|
| Firebase Storage / AWS S3 | Media file storage |
| Firebase Auth | Social authentication |
| Docker | Containerization |
| Render / Railway | Backend deployment |

---

## Architecture

```
┌─────────────────────────────────────┐
│           Flutter App                │
│   (Riverpod · GoRouter · Material3)  │
└────────────────┬────────────────────┘
                 │ HTTPS / REST
┌────────────────▼────────────────────┐
│          FastAPI Backend             │
│  Auth · Upload · Detection · Reports │
└──────┬──────────────────┬───────────┘
       │                  │
┌──────▼──────┐   ┌───────▼────────┐
│  PostgreSQL  │   │ Cloud Storage  │
└─────────────┘   └────────────────┘
       │
┌──────▼──────────────────────────────┐
│         ML Inference Layer           │
│   SigLIP2 + DINOv2 · PyTorch        │
└─────────────────────────────────────┘
```

Clean Architecture is enforced throughout:
```
Presentation → Use Cases → Repositories → Data Sources
(Widgets)      (Logic)     (Interfaces)   (API / DB)
```

Full architectural principles are documented in [`CONSTITUTION.md`](./CONSTITUTION.md).

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Python 3.11+
- PostgreSQL 14+
- Git

### 1. Clone the repository

```bash
git clone https://github.com/your-username/truelens-ai.git
cd truelens-ai
```

### 2. Flutter Frontend

```bash
cd frontend
flutter pub get
flutter run
```

> The app runs with mock services by default. No backend required to explore the UI.

### 3. Backend (when available)

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env      # Fill in your environment variables
alembic upgrade head      # Run database migrations
uvicorn main:app --reload
```

### 4. Environment Variables

Copy `.env.example` and fill in the required values:

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/truelens

# JWT
JWT_SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=15
REFRESH_TOKEN_EXPIRE_DAYS=7

# Storage
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET=

# ML Model
MODEL_ID=Bombek1/ai-image-detector-siglip-dinov2
AI_PROBABILITY_HIGH_THRESHOLD=0.85
AI_PROBABILITY_MEDIUM_THRESHOLD=0.50
```

---

## Project Structure

```
truelens-ai/
├── frontend/                  # Flutter application
│   └── lib/
│       ├── core/              # Shared utilities, theme, widgets
│       ├── features/          # Feature-first organization
│       │   ├── auth/
│       │   ├── upload/
│       │   ├── results/
│       │   ├── history/
│       │   └── reports/
│       └── router/            # GoRouter configuration
├── backend/                   # FastAPI application
│   ├── api/v1/                # Route handlers
│   ├── services/              # Business logic
│   ├── repositories/          # Data access layer
│   ├── models/                # DB models + Pydantic schemas
│   └── ml/                    # Detection pipeline
├── CONSTITUTION.md            # Engineering handbook
└── README.md
```

---

## API Overview

```
POST   /api/v1/auth/register
POST   /api/v1/auth/login

POST   /api/v1/upload/
GET    /api/v1/upload/{id}/status

POST   /api/v1/detect/image
POST   /api/v1/detect/video

GET    /api/v1/scans/
GET    /api/v1/scans/{id}

GET    /api/v1/reports/{scan_id}
POST   /api/v1/reports/{scan_id}/download
```

Full API documentation available at `/docs` when the backend is running (FastAPI auto-generated Swagger UI).

---

## Roadmap

- [x] Flutter frontend — all screens designed
- [x] Mock services and state management
- [x] Project architecture and constitution
- [ ] FastAPI backend — core endpoints
- [ ] PostgreSQL database integration
- [ ] ML model integration (SigLIP2 + DINOv2)
- [ ] Frontend ↔ Backend integration
- [ ] PDF report generation
- [ ] Video detection support
- [ ] Docker deployment
- [ ] Browser extension
- [ ] Developer API

---

## Contributing

Contributions, feedback, and bug reports are welcome.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit using conventional commits: `git commit -m "feat(scope): description"`
4. Push and open a Pull Request

Please read [`CONSTITUTION.md`](./CONSTITUTION.md) before contributing — it defines the architecture, coding standards, and rules every contributor must follow.

---

## Team

**Haseeb** — ML Engineering & Full-Stack Development
Riphah International University · BS Information Technology
ML Engineering Intern @ FlyRank

---

## License

This project is licensed under the MIT License. See [`LICENSE`](./LICENSE) for details.

---

## Acknowledgements

- [Hugging Face](https://huggingface.co) — pretrained model hosting
- [Bombek1/ai-image-detector-siglip-dinov2](https://huggingface.co/Bombek1/ai-image-detector-siglip-dinov2) — detection model
- [Flutter](https://flutter.dev) — cross-platform framework
- [FastAPI](https://fastapi.tiangolo.com) — backend framework

---

<div align="center">
  <strong>TrueLens AI</strong> · Stop guessing. Start knowing.<br>
  Built with purpose at Riphah International University · 2026
</div>
