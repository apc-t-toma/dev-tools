import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
    return NextResponse.json({
        message: 'Hello from Node.js Development Environment!',
        timestamp: new Date().toISOString(),
        environment: 'development',
        tech_stack: [
            'TypeScript',
            'React',
            'Next.js',
            'Tailwind CSS'
        ]
    })
}
