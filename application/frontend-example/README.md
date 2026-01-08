# Frontend Example

A simple React frontend application built with Vite.

## Prerequisites

- Node.js 18 or higher
- npm or yarn

## Building the Project

### Using npm

```bash
# Install dependencies
npm install

# Run development server
npm run dev
```

The application will start on `http://localhost:3000`

### Build for Production

```bash
# Build the project
npm run build

# Preview production build
npm run preview
```

## Running Unit Tests

```bash
# Run tests
npm test

# Run tests with UI
npm run test:ui
```

## Docker

### Build Docker Image

```bash
docker build -t frontend-example:1.0.0 .
```

### Run Docker Container

```bash
docker run -p 80:80 frontend-example:1.0.0
```

The application will be available at `http://localhost`

## Features

- Simple React application with a ping button
- Clicking "Ping API" button attempts to fetch from `/api/ping` endpoint
- Modern build setup using Vite
- Unit tests with Vitest and React Testing Library





