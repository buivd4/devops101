import { useState } from 'react'
import './App.css'

function App() {
  const [message, setMessage] = useState('Hello, React!')

  const handlePing = async () => {
    try {
      const response = await fetch('/api/ping')
      const data = await response.text()
      setMessage(data)
    } catch (error) {
      setMessage('Error: Could not connect to API')
    }
  }

  return (
    <div className="App">
      <header className="App-header">
        <h1>Frontend Example</h1>
        <p>{message}</p>
        <button onClick={handlePing}>Ping API</button>
      </header>
    </div>
  )
}

export default App





