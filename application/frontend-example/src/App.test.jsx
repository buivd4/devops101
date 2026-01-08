import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import App from './App'

describe('App', () => {
  it('renders the app with initial message', () => {
    render(<App />)
    expect(screen.getByText('Frontend Example')).toBeInTheDocument()
    expect(screen.getByText('Hello, React!')).toBeInTheDocument()
    expect(screen.getByText('Ping API')).toBeInTheDocument()
  })

  it('handles ping button click', async () => {
    global.fetch = vi.fn(() =>
      Promise.resolve({
        text: () => Promise.resolve('pong'),
      })
    )

    render(<App />)
    const button = screen.getByText('Ping API')
    fireEvent.click(button)

    // Wait for the async update
    expect(await screen.findByText('pong')).toBeInTheDocument()
  })
})





